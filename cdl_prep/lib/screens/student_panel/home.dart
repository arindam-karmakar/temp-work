import 'package:cdl_prep/api/api.dart';
import 'package:cdl_prep/api/userPrefs.dart';
import 'package:cdl_prep/colour_scheme.dart';
import 'package:cdl_prep/models/dataModels.dart';
import 'package:cdl_prep/models/userModel.dart';
import 'package:cdl_prep/screens/website.dart';
import 'package:cdl_prep/widgets/dashboardExtras.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Dashboard extends StatefulWidget {
  //final CdlUser currentUser;

  Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  /* Future<void> viewNotification() async {
    RemoteMessage? msg = await FirebaseMessaging.instance.getInitialMessage();

    if (msg != null) handleMessage(msg);

    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  }

  void handleMessage(RemoteMessage message) {
    Navigator.of(context).pushNamed('/studentNotification');
  } */

  WebApi webApi = new WebApi();

  String testOTP = "null for now";
  var selectedState;

  OpenWebsite openWebsite =
      new OpenWebsite(initialUrl: 'https://cdlprepapp.com/');

  List<CdlState> stateList = [];

  int lastSelected = 0;

  bool readForThisSession = false;

  @override
  void initState() {
    super.initState();
    // viewNotification();
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
                  color: kTheDialog,
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
                                  gradient: LinearGradient(
                                    colors: [
                                      kOrangeOne,
                                      kOrangeTwo.withOpacity(0.05)
                                    ],
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    "Yes",
                                    textScaleFactor: 1.2,
                                    style: TextStyle(
                                      color: kTheTexts,
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

    return Consumer<CdlUserProvider>(
      builder: (context, userData, newWidget) {
        bool haveUser() {
          if (userData.user.name == "null" || userData.user.name == "name")
            return false;
          else
            return true;
        }

        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [kBlueWhite, kPrimary, kPrimary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: double.maxFinite,
                      width: double.maxFinite,
                      color: Colors.transparent,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //Spacer(),
                          Expanded(
                            flex: 6,
                            child: Center(
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.of(context)
                                            .pushNamed('/studentNotification');
                                        setState(() {
                                          readForThisSession = true;
                                        });

                                        Future.delayed(
                                          Duration(seconds: 2),
                                          () async {
                                            final listOfNotif =
                                                await webApi.getNotifications(
                                                    userData.user.userid
                                                        .toString());

                                            if (listOfNotif.isNotEmpty)
                                              await webApi
                                                  .markNotif(listOfNotif);
                                          },
                                        );
                                      },
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Icon(
                                            Icons.notifications,
                                            color: Colors.blue[900],
                                          ),
                                          (!readForThisSession)
                                              ? FutureBuilder(
                                                  future: webApi.getNotifCount(
                                                      userData.user.userid
                                                          .toString()),
                                                  builder: (context, snapshot) {
                                                    if (snapshot.hasData &&
                                                        snapshot.data != 0)
                                                      return Container(
                                                        height: 17.0,
                                                        width: 17.0,
                                                        margin: EdgeInsets.only(
                                                            bottom: 18.0,
                                                            left: 14.0),
                                                        padding:
                                                            EdgeInsets.all(3.0),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: kPending,
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                        child: FittedBox(
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text(
                                                            snapshot.data
                                                                .toString(),
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
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
                                  Expanded(
                                    flex: 2,
                                    child: Center(
                                      child: Text(
                                        "Dashboard",
                                        //userData.user.name,
                                        textScaleFactor: 1.5,
                                        style:
                                            TextStyle(color: Colors.blue[900]),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: (!haveUser())
                                        ? Container()
                                        : IconButton(
                                            onPressed: () => confirmLogout(),
                                            icon: ImageIcon(
                                              AssetImage(
                                                  'assets/images/logoutVector.png'),
                                              size: 20.0,
                                              color: Colors.blue[900],
                                            ),
                                          ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          //Spacer(),
                          Expanded(
                            flex: 2,
                            child: Center(
                              child: Divider(
                                color: kTheDivider.withOpacity(0.3),
                                thickness: 2.0,
                                indent: 20.0,
                                endIndent: 20.0,
                              ),
                            ),
                          ),
                          //Spacer(),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 9,
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
                                      setState(() {
                                        lastSelected = 1;
                                      });
                                      Future.delayed(
                                        Duration(milliseconds: 30),
                                        () {
                                          /*if (!haveUser())
                                            showNewUserDialog(0);
                                          else
                                            Navigator.of(context)
                                                .pushNamed('/beginExam');*/
                                          Navigator.of(context)
                                              .pushNamed('/beginExam');
                                        },
                                      );
                                    },
                                    child: (lastSelected == 1)
                                        ? PressedButton(
                                            icon: Image.asset(
                                                'assets/images/4-icon 1.png'),
                                            text: "CDL Prep Test",
                                          )
                                        : UnpressedButton(
                                            icon: Image.asset(
                                                'assets/images/4-icon 1.png'),
                                            text: "CDL Prep Test",
                                          ),
                                  ),
                                ),
                                SizedBox(width: 20.0),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        lastSelected = 2;
                                      });
                                      Future.delayed(
                                        Duration(milliseconds: 30),
                                        () {
                                          Navigator.of(context)
                                              .pushNamed('/beginPractice');
                                        },
                                      );
                                    },
                                    child: (lastSelected == 2)
                                        ? PressedButton(
                                            icon: Image.asset(
                                                'assets/images/4 1.png'),
                                            text: "CDL Practice",
                                          )
                                        : UnpressedButton(
                                            icon: Image.asset(
                                                'assets/images/4 1.png'),
                                            text: "CDL Practice",
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
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: double.maxFinite,
                      width: double.maxFinite,
                      color: Colors.transparent,
                      padding: EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  lastSelected = 5;
                                });
                                Future.delayed(
                                  Duration(milliseconds: 30),
                                  () {
                                    Navigator.of(context)
                                        .pushNamed('/beginExam');
                                  },
                                );
                              },
                              child: (lastSelected == 5)
                                  ? IconPressedButton(
                                      iconPath: 'assets/images/5.png',
                                    )
                                  : IconUnpressedButton(
                                      iconPath: 'assets/images/5.png',
                                    ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  lastSelected = 6;
                                });
                                Future.delayed(
                                  Duration(milliseconds: 30),
                                  () {
                                    Navigator.of(context)
                                        .pushNamed('/beginPractice');
                                  },
                                );
                              },
                              child: (lastSelected == 6)
                                  ? IconPressedButton(
                                      iconPath: 'assets/images/9 1.png',
                                    )
                                  : IconUnpressedButton(
                                      iconPath: 'assets/images/9 1.png',
                                    ),
                            ),
                          ),
                          Expanded(
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
                              child: (lastSelected == 7)
                                  ? IconPressedButton(
                                      iconPath: 'assets/images/6.png',
                                    )
                                  : IconUnpressedButton(
                                      iconPath: 'assets/images/6.png',
                                    ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {
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
                              child: (lastSelected == 8)
                                  ? IconPressedButton(
                                      iconPath: 'assets/images/7.png',
                                    )
                                  : IconUnpressedButton(
                                      iconPath: 'assets/images/7.png',
                                    ),
                            ),
                          ),
                        ],
                      ),
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
}
