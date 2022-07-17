import 'package:eldtprep/api/api.dart';
import 'package:eldtprep/api/userPrefs.dart';
import 'package:eldtprep/colour_scheme.dart';
import 'package:eldtprep/logic/resume_practice_logic.dart';
import 'package:eldtprep/models/userModel.dart';
import 'package:eldtprep/screens/resetPassword.dart';
import 'package:eldtprep/screens/student_panel/beginExam.dart';
import 'package:eldtprep/screens/student_panel/exam.dart';
import 'package:eldtprep/screens/student_panel/practice.dart';
import 'package:eldtprep/screens/student_panel/student_profile.dart';
import 'package:eldtprep/screens/website.dart';
import 'package:eldtprep/services/category_info.dart';
import 'package:eldtprep/widgets/dashboardExtras.dart';
//import 'package:dropdown_below/dropdown_below.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class BeginPractice extends StatefulWidget {
  BeginPractice({Key? key}) : super(key: key);

  @override
  _BeginPracticeState createState() => _BeginPracticeState();
}

class _BeginPracticeState extends State<BeginPractice> {
  OpenWebsite openWebsite =
      new OpenWebsite(initialUrl: 'https://cdlprepapp.com/');

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  WebApi webApi = new WebApi();
  Future<dynamic> getCat() => WebApi().getCategories();

  var lastSelected = 6;
  var lastSelectedTile = 0;

  var selectedCategory, selectedCategoryName;
  int cat = 0;

  List timeNdQuestions = [
    {
      'time': '60',
      'questions': '66',
    },
    {
      'time': '60',
      'questions': '78',
    },
    {
      'time': '40',
      'questions': '34',
    },
    {
      'time': '60',
      'questions': '255',
    },
    {
      'time': '40',
      'questions': '54',
    },
    {
      'time': '50',
      'questions': '50',
    },
    {
      'time': '49',
      'questions': '40',
    },
    {
      'time': '40',
      'questions': '33',
    },
  ];

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

    return Consumer<ResumePracticeProvider>(
      builder: (context, resumeData, _) {
        var _resumeData = resumeData.modules;
        var _totalData = resumeData.categoryWiseQuestionsDone;

        int getStatus(String name) {
          int temp = 0;
          /*var data = Provider.of<ResumePracticeProvider>(context, listen: false)
              .modules;*/
          var data = _totalData;

          for (var i = 0; i < data.length; i++) {
            // if (data[i].categoryName == name) temp = data[i].question as int;
            if (data[i]['key'] == 'QuestionsAttempted$name') {
              temp = data[i]['data'].length;
            }
          }
          return temp;
        }

        List<InkWell> buildItems(AsyncSnapshot snapshot) {
          List<InkWell> items = [];

          for (var i = 0; i < snapshot.data.length; i++)
            items.add(
              InkWell(
                onTap: () {
                  setState(() {
                    lastSelectedTile = 50 + snapshot.data[i].categoryId as int;
                  });

                  Future.delayed(Duration(milliseconds: 300), () {
                    setState(() {
                      selectedCategory = snapshot.data[i].categoryId;
                      selectedCategoryName = snapshot.data[i].name;
                      cat = snapshot.data[i].categoryId as int;
                    });
                  });
                },
                child: CategoryWidget(
                  isActive: (lastSelectedTile ==
                      50 + snapshot.data[i].categoryId as int),
                  isPractice: true, //(getStatus(snapshot.data[i].name) != 0),
                  categoryData: getCategoryInfo(snapshot.data[i].name),
                  categoryId: snapshot.data[i].categoryId,
                  name: snapshot.data[i].name,
                  done: getStatus(snapshot.data[i].name),
                  total: int.parse(timeNdQuestions[i]['questions']),
                ),
              ),
            );

          return items;
        }

        Map<String, dynamic> canResume() {
          bool test = false;
          int data = 0;

          var modules =
              Provider.of<ResumePracticeProvider>(context, listen: false)
                  .modules;

          for (var i = 0; i < modules!.length; i++) {
            if (modules[i].categoryName == selectedCategoryName) {
              test = true;
              data = modules[i].question as int;
            }
          }

          return {
            'test': test,
            'data': data,
          };
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
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          },
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
                  child: SizedBox(
                    height: 25.0,
                    width: 25.0,
                  ),
                ),
                Flexible(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        (1 <= cat && cat <= 8) ? "Begin Practice" : "Category",
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
                    onTap: () =>
                        Navigator.of(context).pushNamed('/studentNotification'),
                    child: Icon(
                      Icons.notifications_outlined,
                      color: Colors.blue[900],
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                onPressed: () => confirmLogout(),
                icon: ImageIcon(
                  AssetImage('assets/images/logoutVector.png'),
                  size: 20.0,
                  color: Colors.red,
                ),
              )
            ],
          ),
          body: FutureBuilder(
            future: getCat(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data[0].name == 'null') {
                  return Center(
                    child: Text(
                      "Could not load data, try again!",
                      style: TextStyle(color: Colors.blue.shade900),
                    ),
                  );
                } else {
                  return SizedBox(
                    width: double.maxFinite,
                    height: double.maxFinite,
                    child: (1 <= cat && cat <= 8)
                        /*? MaterialButton(
                          onPressed: () {
                            setState(() {
                              cat = 0;
                              selectedCategory = null;
                            });
                          },
                          child: Text('data'),
                        )*/
                        ? SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: SizedBox(height: 30.0),
                                ),
                                Flexible(
                                  flex: 2,
                                  child: Container(
                                    color: kEldtButton,
                                    width: double.maxFinite,
                                    height: 70.0,
                                    child: Center(
                                      child: Text(
                                        selectedCategoryName,
                                        textScaleFactor: 1.7,
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: SizedBox(height: 45.0),
                                ),
                                Flexible(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/images/question.png',
                                        height: 50.0,
                                      ),
                                      SizedBox(width: 20.0),
                                      Text(
                                        "${timeNdQuestions[cat - 1]['questions']} questions",
                                        textScaleFactor: 1.3,
                                        style:
                                            TextStyle(color: Colors.blue[900]),
                                      ),
                                    ],
                                  ),
                                ),
                                Flexible(
                                  child: SizedBox(height: 30.0),
                                ),
                                Flexible(
                                  child: MaterialButton(
                                    onPressed: () => Navigator.of(context)
                                        .pushReplacement(MaterialPageRoute(
                                      builder: (context) => PracticeScreen(
                                        initialCategory: cat,
                                        categoryName: selectedCategoryName,
                                      ),
                                    )),
                                    color: kEldtButton,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 30.0,
                                        vertical: 10.0,
                                      ),
                                      child: Text(
                                        "Start",
                                        textScaleFactor: 1.25,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                if (canResume()['test'])
                                  Flexible(
                                    child: SizedBox(height: 5.0),
                                  ),
                                if (canResume()['test'])
                                  Flexible(
                                    child: MaterialButton(
                                      onPressed: () => Navigator.of(context)
                                          .pushReplacement(MaterialPageRoute(
                                        builder: (context) => PracticeScreen(
                                          initialCategory: cat,
                                          categoryName: selectedCategoryName,
                                          continueQ: canResume()['data'] + 1,
                                        ),
                                      )),
                                      color: kEldtButton,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 30.0,
                                          vertical: 10.0,
                                        ),
                                        child: Text(
                                          "Resume",
                                          textScaleFactor: 1.25,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                Flexible(
                                  child: SizedBox(height: 30.0),
                                ),
                                Flexible(
                                  child: Text(
                                    "Do you want to change the category?",
                                    textScaleFactor: 1.1,
                                    style:
                                        TextStyle(color: Colors.blue.shade900),
                                  ),
                                ),
                                Flexible(
                                  child: TextButton(
                                    onPressed: () {
                                      setState(() {
                                        cat = 0;
                                        selectedCategory = null;
                                        selectedCategoryName = null;
                                      });
                                    },
                                    child: Text(
                                      "Click Here",
                                      textScaleFactor: 1.1,
                                      style: TextStyle(
                                        color: Colors.blue.shade900,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: SingleChildScrollView(
                              child: Wrap(
                                alignment: WrapAlignment.spaceEvenly,
                                runSpacing: 10.0,
                                children: buildItems(snapshot),
                              ),
                            ),
                          ),
                  );
                }
              } else
                return Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: 40,
                      maxWidth: 40,
                    ),
                    child: CircularProgressIndicator.adaptive(
                        valueColor: AlwaysStoppedAnimation<Color>(kTheTexts)),
                  ),
                );
            },
          ),
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
                              Navigator.of(context)
                                  .pushReplacementNamed('/beginExam');
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

    /*List<DropdownMenuItem<int>> buildItems(AsyncSnapshot snapshot) {
      List<DropdownMenuItem<int>> items = [];

      for (var i = 0; i < snapshot.data.length; i++)
        items.add(
          DropdownMenuItem<int>(
            value: snapshot.data[i].categoryId,
            child: Text(snapshot.data[i].name),
          ),
        );
      return items;
    }

    return Scaffold(
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
                      Spacer(),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: IconButton(
                              onPressed: () => Navigator.of(context).pop(),
                              icon: Icon(
                                Icons.home,
                                color: Colors.blue[900],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Center(
                              child: Text(
                                "Begin Practice",
                                textScaleFactor: 1.5,
                                style: TextStyle(color: Colors.blue[900]),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(),
                          ),
                        ],
                      ),
                      Spacer(),
                      Divider(
                        color: kTheDivider.withOpacity(0.3),
                        thickness: 2.0,
                        indent: 20.0,
                        endIndent: 20.0,
                      ),
                      Spacer(),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 9,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 15.0),
                  child: Column(
                    children: [
                      Row(),
                      FutureBuilder(
                        future: getCat(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData)
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                DropdownBelow<int?>(
                                  boxHeight: 40,
                                  boxWidth:
                                      MediaQuery.of(context).size.width * 0.85,
                                  itemWidth:
                                      MediaQuery.of(context).size.width * 0.55,
                                  hint: Text("Choose Category"),
                                  boxTextstyle: TextStyle(
                                    color: kTheTexts,
                                    fontFamily: 'Amazon_Ember',
                                  ),
                                  itemTextstyle: TextStyle(
                                    color: kTheTexts,
                                    fontFamily: 'Amazon_Ember',
                                  ),
                                  icon: Icon(
                                    Icons.arrow_drop_down_rounded,
                                    color: kTheTexts,
                                    size: 28.0,
                                  ),
                                  items: buildItems(snapshot),
                                  value: selectedCategory,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedCategory = value;
                                      cat = value as int;
                                    });
                                  },
                                ),
                                Divider(
                                  color: kTheTexts,
                                  thickness: 1.1,
                                  indent: 20.0,
                                  endIndent: 20.0,
                                ),
                              ],
                            );
                          else
                            return ConstrainedBox(
                              constraints: BoxConstraints(
                                maxHeight: 40,
                                maxWidth: 40,
                              ),
                              child:
                                  CircularProgressIndicator(color: kTheTexts),
                            );
                        },
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.12),
                      (1 <= cat && cat <= 8)
                          ? GestureDetector(
                              onTap: () =>
                                  Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      PracticeScreen(initialCategory: cat),
                                ),
                              ),
                              child: Container(
                                height: 50.0,
                                width: 150.0,
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
                                    "Start",
                                    textScaleFactor: 1.2,
                                    style: TextStyle(
                                      color: kTheTexts,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Container(),
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
                              () => Navigator.of(context)
                                  .pushReplacementNamed('/beginExam'),
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
                              () {},
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

                            OpenWebsite openWebsite = new OpenWebsite(
                                initialUrl: 'https://cdlprepapp.com/');

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
                          onTap: () {
                            setState(() {
                              lastSelected = 8;
                            });

                            OpenWebsite openWebsite = new OpenWebsite(
                                initialUrl: 'https://cdlprepapp.com/');

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
    );*/
  }
}
