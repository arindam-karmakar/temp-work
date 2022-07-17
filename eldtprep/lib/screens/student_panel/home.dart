import 'package:eldtprep/api/api.dart';
import 'package:eldtprep/api/userPrefs.dart';
import 'package:eldtprep/colour_scheme.dart';
import 'package:eldtprep/logic/resume_practice_logic.dart';
import 'package:eldtprep/models/dataModels.dart';
import 'package:eldtprep/models/userModel.dart';
import 'package:eldtprep/screens/resetPassword.dart';
import 'package:eldtprep/screens/student_panel/practice.dart';
import 'package:eldtprep/screens/student_panel/student_profile.dart';
import 'package:eldtprep/screens/website.dart';
import 'package:eldtprep/widgets/dashboardExtras.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class SetDashboard extends StatelessWidget {
  final String lastCategory;
  final List<ResumeModule> allLast;
  final List allCategoryWiseQuestionsDone;

  const SetDashboard({
    Key? key,
    required this.lastCategory,
    required this.allLast,
    required this.allCategoryWiseQuestionsDone,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var resumePracticeProvider =
        Provider.of<ResumePracticeProvider>(context, listen: false);

    resumePracticeProvider.setLastCategory(lastCategory.toString());

    for (var i = 0; i < allLast.length; i++) {
      resumePracticeProvider.setModules(allLast[i]);
    }

    if (allCategoryWiseQuestionsDone.length > 0) {
      for (var i = 0; i < allCategoryWiseQuestionsDone.length; i++) {
        for (var j = 0;
            j < allCategoryWiseQuestionsDone[i]['data'].length;
            j++) {
          resumePracticeProvider.setCategoryWiseQuestionsDone(
              allCategoryWiseQuestionsDone[i]['data'][j],
              allCategoryWiseQuestionsDone[i]['key']
                  .toString()
                  .replaceFirstMapped('QuestionsAttempted', (match) => ''));
        }
      }
    }

    /*return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () {
        Progress progress = Progress();

        progress.setQuestionsAttempted('3', 'Tanks');

        Fluttertoast.showToast(msg: "done");
      }),
      body: SafeArea(
          child: Text(
              resumePracticeProvider.categoryWiseQuestionsDone.toString())),
    );*/

    return Dashboard();
  }
}

class Dashboard extends StatefulWidget {
  //final CdlUser currentUser;

  Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> viewNotification() async {
    RemoteMessage? msg = await FirebaseMessaging.instance.getInitialMessage();

    if (msg != null) handleMessage(msg);

    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  }

  void handleMessage(RemoteMessage message) {
    Navigator.of(context).pushNamed('/studentNotification');
  }

  WebApi webApi = new WebApi();

  String testOTP = "null for now";
  var selectedState;

  OpenWebsite openWebsite =
      new OpenWebsite(initialUrl: 'https://www.eldtinc.com/');

  List<CdlState> stateList = [];

  int lastSelected = 0;

  bool readForThisSession = false;

  @override
  void initState() {
    super.initState();
    viewNotification();
    getStateListInVar();
  }

  getStateListInVar() async {
    stateList = await webApi.getStates();
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    UserPreferences userPreferences = UserPreferences();

    confirmLogout() {
      showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            elevation: 15.0,
            insetPadding: EdgeInsets.all(24.0),
            child: GestureDetector(
              onTap: () {
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) currentFocus.unfocus();
              },
              child: Container(
                height: MediaQuery.of(context).size.height * 0.3,
                width: double.maxFinite,
                padding: EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  color: kEldtCard,
                  border: Border.all(
                    color: Colors.blue.shade900.withOpacity(0.7),
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: Text(
                          "Logout",
                          textScaleFactor: 1.4,
                          style: TextStyle(
                            color: kTheTexts,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Center(
                        child: Text(
                          "Do you really want to logout from the app?",
                          textAlign: TextAlign.center,
                          textScaleFactor: 1.2,
                          style: TextStyle(
                            color: kTheTexts,
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Flexible(
                            child: GestureDetector(
                              onTap: () => Navigator.of(context).pop(),
                              child: Container(
                                height: 50.0,
                                width: 100.0,
                                color: Colors.transparent,
                                child: Center(
                                  child: Text(
                                    "No",
                                    textScaleFactor: 1.2,
                                    style: TextStyle(
                                      color: kTheTexts,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            child: GestureDetector(
                              onTap: () async {
                                await authProvider.logout();
                                CdlUser logoutUser =
                                    await userPreferences.getUser();

                                Provider.of<CdlUserProvider>(context,
                                        listen: false)
                                    .setUser(logoutUser);

                                Navigator.of(context).pop();
                                Navigator.of(context)
                                    .pushReplacementNamed('/handleLogin');

                                setState(() {
                                  lastSelected = 0;
                                });

                                Fluttertoast.showToast(
                                  msg: "Successfully logged out!",
                                  gravity: ToastGravity.BOTTOM,
                                  backgroundColor: kTheTexts,
                                  textColor: Colors.white,
                                );
                              },
                              child: Container(
                                height: 50.0,
                                width: 100.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50.0),
                                  color: kEldtButton,
                                  border: Border.all(color: kTheTexts),
                                ),
                                child: Center(
                                  child: Text(
                                    "Yes",
                                    textScaleFactor: 1.2,
                                    style: TextStyle(
                                      color: Colors.blue.shade900,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }

    List<Map<String, dynamic>> homeList = [
      {
        'img': 'assets/images/Group 9.png',
        'title': "ELDT Prep Test",
        'onTap': () {
          setState(() {
            lastSelected = 1;
          });
          Future.delayed(
            Duration(milliseconds: 30),
            () {
              Navigator.of(context).pushNamed('/beginExam');
            },
          );
        },
      },
      {
        'img': 'assets/images/Group 10.png',
        'title': "ELDT Practice",
        'onTap': () {
          setState(() {
            lastSelected = 2;
          });
          Future.delayed(
            Duration(milliseconds: 30),
            () {
              Navigator.of(context).pushNamed('/beginPractice');
            },
          );
        },
      },
      {
        'img': 'assets/images/Group 11.png',
        'title': "Visit Website",
        'onTap': () {
          setState(() {
            lastSelected = 3;
          });

          Future.delayed(
            Duration(milliseconds: 30),
            () async {
              await openWebsite.open();
            },
          );
        },
      },
      {
        'img': 'assets/images/Group 12.png',
        'title': "News",
        'onTap': () {
          setState(() {
            lastSelected = 4;
          });

          Future.delayed(
            Duration(milliseconds: 30),
            () async {
              await openWebsite.open();
            },
          );
        },
      },
    ];

    return Consumer<CdlUserProvider>(
      builder: (context, userData, newWidget) {
        bool haveUser() {
          if (userData.user.name == "null" || userData.user.name == "name")
            return false;
          else
            return true;
        }

        return Scaffold(
          key: _scaffoldKey,
          drawer: Drawer(
            backgroundColor: kEldtCard,
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 3,
                    child: ListView(
                      children: [
                        SizedBox(
                          height: 150.0,
                          child: DrawerHeader(
                            padding: EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(
                                  'assets/images/logo.png',
                                  height: 50.0,
                                ),
                                IconButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  icon: Icon(
                                    Icons.close,
                                    color: Colors.blue.shade900,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        ListTile(
                          leading: Icon(Icons.home),
                          title: Text(
                            "Dashboard",
                            textScaleFactor: 1.3,
                          ),
                          iconColor: Colors.blue.shade900,
                          textColor: Colors.blue.shade900,
                          dense: true,
                          horizontalTitleGap: 8.0,
                          style: ListTileStyle.drawer,
                          onTap: () => Navigator.of(context).pop(),
                        ),
                        Divider(
                          color: Colors.blue.shade900,
                          thickness: 1.0,
                          height: 8.0,
                        ),
                        ListTile(
                          leading: Icon(Icons.key),
                          title: Text(
                            "Change Password",
                            textScaleFactor: 1.3,
                          ),
                          iconColor: Colors.blue.shade900,
                          textColor: Colors.blue.shade900,
                          dense: true,
                          horizontalTitleGap: 8.0,
                          style: ListTileStyle.drawer,
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ResetPassword(),
                            ),
                          ),
                        ),
                        Divider(
                          color: Colors.blue.shade900,
                          thickness: 1.0,
                          height: 8.0,
                        ),
                        ListTile(
                          leading: Icon(Icons.person),
                          title: Text(
                            "Profile",
                            textScaleFactor: 1.3,
                          ),
                          iconColor: Colors.blue.shade900,
                          textColor: Colors.blue.shade900,
                          dense: true,
                          horizontalTitleGap: 8.0,
                          style: ListTileStyle.drawer,
                          onTap: () {
                            Navigator.of(context).pop();

                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => StudentProfile()));
                          },
                        ),
                        Divider(
                          color: Colors.blue.shade900,
                          thickness: 1.0,
                          height: 8.0,
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Divider(
                          color: Colors.blue.shade900,
                          thickness: 1.0,
                          height: 8.0,
                        ),
                        ListTile(
                          leading: ImageIcon(
                            AssetImage(
                              'assets/images/logoutVector.png',
                            ),
                            size: 20.0,
                          ),
                          title: Text(
                            "Logout",
                            textScaleFactor: 1.3,
                          ),
                          iconColor: Colors.blue.shade900,
                          textColor: Colors.blue.shade900,
                          dense: true,
                          horizontalTitleGap: 8.0,
                          style: ListTileStyle.drawer,
                          onTap: () {
                            Navigator.of(context).pop();

                            confirmLogout();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            leading: IconButton(
              onPressed: () => _scaffoldKey.currentState!.openDrawer(),
              icon: ImageIcon(
                AssetImage('assets/images/drawerVector2.png'),
                color: Colors.blue[900],
              ),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  child: Container(),
                ),
                Flexible(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Dashboard",
                        textScaleFactor: 1.1,
                        style: TextStyle(color: Colors.blue[900]),
                      ),
                      Divider(
                        height: 8.0,
                        color: Colors.blue[900],
                        thickness: 1.0,
                        indent: 15.0,
                        endIndent: 15.0,
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed('/studentNotification');
                      setState(() {
                        readForThisSession = true;
                      });

                      Future.delayed(
                        Duration(seconds: 2),
                        () async {
                          final listOfNotif = await webApi.getNotifications(
                              userData.user.userid.toString());

                          if (listOfNotif.isNotEmpty)
                            await webApi.markNotif(listOfNotif);
                        },
                      );
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(
                          Icons.notifications_outlined,
                          color: Colors.blue[900],
                        ),
                        (!readForThisSession)
                            ? FutureBuilder(
                                future: webApi.getNotifCount(
                                    userData.user.userid.toString()),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData && snapshot.data != 0)
                                    return Container(
                                      height: 17.0,
                                      width: 17.0,
                                      margin: EdgeInsets.only(
                                          bottom: 18.0, left: 14.0),
                                      padding: EdgeInsets.all(3.0),
                                      decoration: BoxDecoration(
                                        color: kPending,
                                        shape: BoxShape.circle,
                                      ),
                                      child: FittedBox(
                                        alignment: Alignment.center,
                                        child: Text(
                                          snapshot.data.toString(),
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    );
                                  else
                                    return Container();
                                },
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              (!haveUser())
                  ? Container()
                  : IconButton(
                      onPressed: () => confirmLogout(),
                      icon: ImageIcon(
                        AssetImage('assets/images/logoutVector.png'),
                        size: 20.0,
                        color: Colors.red,
                      ),
                    ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(12.0),
            child: ListView(
              children: [
                for (var i = 0; i < 4; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: HomeWidget(
                      img: homeList[i]['img'],
                      title: homeList[i]['title'],
                      onTap: homeList[i]['onTap'],
                      isActive: (i + 1 == lastSelected),
                    ),
                  ),
                SizedBox(height: 10.0),
                LastPractice(),
              ],
            ),
          ),
          /* body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            // decoration: BoxDecoration(
            //   gradient: LinearGradient(
            //     colors: [kBlueWhite, kPrimary, kPrimary],
            //     begin: Alignment.topLeft,
            //     end: Alignment.bottomRight,
            //   ),
            // ),
            child: SafeArea(
              child: Column(
                children: [
                  /* Expanded(
                    flex: 11,
                    child: Container(
                      height: double.maxFinite,
                      width: double.maxFinite,
                      color: Colors.transparent,
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                    },
                                    child: (lastSelected == 1)
                                        ? PressedButton(
                                            icon: Image.asset(
                                                'assets/images/4-icon 1.png'),
                                            text: "ELDT Prep Test",
                                          )
                                        : UnpressedButton(
                                            icon: Image.asset(
                                                'assets/images/4-icon 1.png'),
                                            text: "ELDT Prep Test",
                                          ),
                                  ),
                                ),
                                SizedBox(width: 20.0),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                    },
                                    child: (lastSelected == 2)
                                        ? PressedButton(
                                            icon: Image.asset(
                                                'assets/images/4 1.png'),
                                            text: "ELDT Practice",
                                          )
                                        : UnpressedButton(
                                            icon: Image.asset(
                                                'assets/images/4 1.png'),
                                            text: "ELDT Practice",
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20.0),
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                    },
                                    child: (lastSelected == 3)
                                        ? PressedButton(
                                            icon: Image.asset(
                                                'assets/images/3-icon 1.png'),
                                            text: "Visit Website",
                                          )
                                        : UnpressedButton(
                                            icon: Image.asset(
                                                'assets/images/3-icon 1.png'),
                                            text: "Visit Website",
                                          ),
                                  ),
                                ),
                                SizedBox(width: 20.0),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      
                                      
                                    },
                                    child: (lastSelected == 4)
                                        ? PressedButton(
                                            icon: Image.asset(
                                                'assets/images/2-icon 1.png'),
                                            text: "News",
                                          )
                                        : UnpressedButton(
                                            icon: Image.asset(
                                                'assets/images/2-icon 1.png'),
                                            text: "News",
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),*/
                ],
              ),
            ),
          ),*/
          bottomNavigationBar: Container(
            height: 80.0,
            child: Column(
              children: [
                Divider(
                  color: Colors.grey,
                  thickness: 1.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            lastSelected = 5;
                          });
                          Future.delayed(
                            Duration(milliseconds: 30),
                            () {
                              Navigator.of(context).pushNamed('/beginExam');
                            },
                          );
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: ImageIcon(
                                AssetImage('assets/images/5.png'),
                                size: 32.0,
                                color: (lastSelected == 5)
                                    ? kEldtButton
                                    : Colors.grey,
                              ),
                            ),
                            Flexible(
                              child: Text(
                                "ELDT Prep Test",
                                textScaleFactor: 0.9,
                                style: TextStyle(
                                  color: (lastSelected == 5)
                                      ? kEldtButton
                                      : Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Flexible(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            lastSelected = 6;
                          });
                          Future.delayed(
                            Duration(milliseconds: 30),
                            () {
                              Navigator.of(context).pushNamed('/beginPractice');
                            },
                          );
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: ImageIcon(
                                AssetImage('assets/images/9 1.png'),
                                size: 38.0,
                                color: (lastSelected == 6)
                                    ? kEldtButton
                                    : Colors.grey,
                              ),
                            ),
                            Flexible(
                              child: Text(
                                "ELDT Practice",
                                textScaleFactor: 0.9,
                                style: TextStyle(
                                  color: (lastSelected == 6)
                                      ? kEldtButton
                                      : Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Flexible(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            lastSelected = 7;
                          });

                          Future.delayed(
                            Duration(milliseconds: 30),
                            () async {
                              await openWebsite.open();
                            },
                          );
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: ImageIcon(
                                AssetImage('assets/images/6.png'),
                                size: 32.0,
                                color: (lastSelected == 7)
                                    ? kEldtButton
                                    : Colors.grey,
                              ),
                            ),
                            Flexible(
                              child: Text(
                                "Visit Website",
                                textScaleFactor: 0.9,
                                style: TextStyle(
                                  color: (lastSelected == 7)
                                      ? kEldtButton
                                      : Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Flexible(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            lastSelected = 8;
                          });

                          Future.delayed(
                            Duration(milliseconds: 30),
                            () async {
                              await openWebsite.open();
                            },
                          );
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: ImageIcon(
                                AssetImage('assets/images/7.png'),
                                size: 32.0,
                                color: (lastSelected == 8)
                                    ? kEldtButton
                                    : Colors.grey,
                              ),
                            ),
                            Flexible(
                              child: Text(
                                "News",
                                textScaleFactor: 0.9,
                                style: TextStyle(
                                  color: (lastSelected == 8)
                                      ? kEldtButton
                                      : Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class HomeWidget extends StatelessWidget {
  final String img, title;
  final VoidCallback onTap;
  final bool isActive;

  const HomeWidget({
    Key? key,
    required this.img,
    required this.title,
    required this.onTap,
    required this.isActive,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10.0,
      color: isActive ? kEldtButton : Colors.white,
      shadowColor: Color.fromARGB(146, 232, 232, 232),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10.0,
        ),
        child: ListTile(
          leading: Image.asset(
            img,
            height: 53.0,
          ),
          title: Text(
            title,
            textScaleFactor: 1.15,
            style: TextStyle(
              color: Colors.blue.shade900,
            ),
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}

class LastPractice extends StatefulWidget {
  LastPractice({Key? key}) : super(key: key);

  @override
  State<LastPractice> createState() => _LastPracticeState();
}

class _LastPracticeState extends State<LastPractice> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ResumePracticeProvider>(
      builder: (context, lastCategory, _) => (lastCategory.lastCategory
                  .toString()
                  .toLowerCase() !=
              'null')
          ? Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Last Practice",
                      textScaleFactor: 1.3,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: double.maxFinite,
                  padding: const EdgeInsets.all(12.0),
                  margin: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    color: kEldtCard,
                    border: Border.all(color: kTheTexts),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                child: Text(
                                  lastCategory.lastCategory.toString(),
                                  textScaleFactor: 1.6,
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              Flexible(
                                child: SizedBox(
                                  height: 24.0,
                                ),
                              ),
                              Flexible(
                                child: MaterialButton(
                                  onPressed: () {
                                    var modules =
                                        Provider.of<ResumePracticeProvider>(
                                                context,
                                                listen: false)
                                            .modules;

                                    for (var i = 0; i < modules!.length; i++) {
                                      if (modules[i].categoryName ==
                                          lastCategory.lastCategory
                                              .toString()) {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) => PracticeScreen(
                                            initialCategory:
                                                modules[i].categoryId as int,
                                            categoryName: modules[i]
                                                .categoryName
                                                .toString(),
                                            continueQ: modules[i].question! + 1,
                                          ),
                                        ));
                                      }
                                    }
                                  },
                                  child: Text(
                                    "Resume Practice Now",
                                    textScaleFactor: 1.05,
                                    style: TextStyle(
                                      color: Colors.blue[900],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  color: kEldtButton,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    side: BorderSide(color: kTheTexts),
                                  ),
                                  elevation: 0.0,
                                  highlightElevation: 0.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          height: 70.0,
                          child: Center(
                            child: Image.asset(
                              'assets/images/practiceVector.png',
                              height: 50.0,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : Container(),
    );
  }
}
