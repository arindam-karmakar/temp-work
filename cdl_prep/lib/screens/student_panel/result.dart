import 'package:cdl_prep/api/api.dart';
import 'package:cdl_prep/api/userPrefs.dart';
import 'package:cdl_prep/colour_scheme.dart';
import 'package:cdl_prep/models/dataModels.dart';
import 'package:cdl_prep/models/userModel.dart';
import 'package:cdl_prep/screens/resetPassword.dart';
import 'package:cdl_prep/screens/student_panel/exam.dart';
import 'package:cdl_prep/screens/student_panel/student_profile.dart';
import 'package:cdl_prep/screens/website.dart';
import 'package:cdl_prep/widgets/dashboardExtras.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ResultScreen extends StatefulWidget {
  final int totalAnswer;
  final int correctAnswer;
  final int wrongAnswer;
  final int totalQuestions;
  final int categoryId, time, questions;

  final List<CdlQuestions> wrong;

  ResultScreen({
    Key? key,
    required this.totalAnswer,
    required this.correctAnswer,
    required this.wrongAnswer,
    required this.totalQuestions,
    required this.categoryId,
    required this.wrong,
    required this.questions,
    required this.time,
  }) : super(key: key);

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  OpenWebsite openWebsite =
      new OpenWebsite(initialUrl: 'https://cdlprepapp.com/');

  WebApi webApi = new WebApi();

  var lastSelected = 0;
  int _currentTab = 0;

  @override
  Widget build(BuildContext context) {
    final int report =
        ((widget.correctAnswer / widget.totalQuestions) * 100).round();

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
                  color: Colors.blue.shade900,
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
                            color: Colors.white,
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
                            color: Colors.white,
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
                                      color: Colors.white,
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
                                  color: Colors.white,
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

    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        backgroundColor: Colors.blue.shade900,
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
                              height: 45.0,
                            ),
                            IconButton(
                              onPressed: () => Navigator.of(context).pop(),
                              icon: Icon(
                                Icons.close,
                                color: Colors.white,
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
                      iconColor: Colors.white,
                      textColor: Colors.white,
                      dense: true,
                      horizontalTitleGap: 8.0,
                      style: ListTileStyle.drawer,
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                    ),
                    Divider(
                      color: Colors.white,
                      thickness: 1.0,
                      height: 8.0,
                    ),
                    ListTile(
                      leading: Icon(Icons.key),
                      title: Text(
                        "Change Password",
                        textScaleFactor: 1.3,
                      ),
                      iconColor: Colors.white,
                      textColor: Colors.white,
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
                      color: Colors.white,
                      thickness: 1.0,
                      height: 8.0,
                    ),
                    ListTile(
                      leading: Icon(Icons.person),
                      title: Text(
                        "Profile",
                        textScaleFactor: 1.3,
                      ),
                      iconColor: Colors.white,
                      textColor: Colors.white,
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
                      color: Colors.white,
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
                      color: Colors.white,
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
                      iconColor: Colors.white,
                      textColor: Colors.white,
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
              child: Image.asset(
                'assets/images/logo.png',
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
                    "Result",
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
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Align(
                alignment: Alignment.topRight,
                child: MaterialButton(
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          WrongAnswerPage(wrong: widget.wrong))),
                  color: Colors.blue[900],
                  elevation: 0.0,
                  highlightElevation: 0.0,
                  child: Text(
                    "Wrong Answers",
                    textScaleFactor: 1.2,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                SfCircularChart(
                  series: [
                    RadialBarSeries<ChartData, String>(
                      dataSource: <ChartData>[
                        ChartData(
                          x: 'Result',
                          y: widget.correctAnswer,
                          text: '100%',
                          pointColor: Color.fromARGB(255, 91, 155, 213),
                        ),
                      ],
                      maximumValue:
                          double.parse(widget.totalQuestions.toString()),
                      xValueMapper: (ChartData data, _) => data.x,
                      yValueMapper: (ChartData data, _) => data.y,
                      cornerStyle: CornerStyle.bothCurve,
                      innerRadius: '80',
                    ),
                  ],
                ),
                Text(
                  "$report%",
                  textScaleFactor: 2.5,
                  style: TextStyle(
                    color: Color.fromARGB(255, 91, 155, 213),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 15.0),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                "Correct: ${widget.correctAnswer}",
                textScaleFactor: 1.5,
                style: TextStyle(color: Colors.blue.shade900),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                "Incorrect: ${widget.wrongAnswer}",
                textScaleFactor: 1.5,
                style: TextStyle(color: Colors.blue.shade900),
              ),
            ),
            SizedBox(height: 15.0),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: MaterialButton(
                  onPressed: () =>
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => ExamScreen(
                                categoryId: widget.categoryId,
                                questions: widget.questions,
                                time: widget.time,
                              ))),
                  color: Colors.blue[900],
                  elevation: 0.0,
                  highlightElevation: 0.0,
                  child: Text(
                    "    Restart    ",
                    textScaleFactor: 1.2,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: MaterialButton(
                  onPressed: () => Navigator.of(context).pop(),
                  color: Colors.blue[900],
                  elevation: 0.0,
                  highlightElevation: 0.0,
                  child: Text(
                    "Go to Home",
                    textScaleFactor: 1.2,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
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
                                ? Colors.blue.shade900
                                : Colors.grey,
                          ),
                        ),
                        Flexible(
                          child: Text(
                            "CDL Prep Test",
                            style: TextStyle(
                              color: (lastSelected == 5)
                                  ? Colors.blue.shade900
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
                          Navigator.of(context)
                              .pushReplacementNamed('/beginPractice');
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
                                ? Colors.blue.shade900
                                : Colors.grey,
                          ),
                        ),
                        Flexible(
                          child: Text(
                            "CDL Practice",
                            style: TextStyle(
                              color: (lastSelected == 6)
                                  ? Colors.blue.shade900
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
                                ? Colors.blue.shade900
                                : Colors.grey,
                          ),
                        ),
                        Flexible(
                          child: Text(
                            "Visit Website",
                            style: TextStyle(
                              color: (lastSelected == 7)
                                  ? Colors.blue.shade900
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
                                ? Colors.blue.shade900
                                : Colors.grey,
                          ),
                        ),
                        Flexible(
                          child: Text(
                            "News",
                            style: TextStyle(
                              color: (lastSelected == 8)
                                  ? Colors.blue.shade900
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

    /*return Scaffold(
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
                                "Results",
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
                child: DefaultTabController(
                  length: 2,
                  child: Container(
                    height: double.maxFinite,
                    width: double.maxFinite,
                    child: Scaffold(
                      backgroundColor: Colors.transparent,
                      appBar: TabBar(
                        enableFeedback: true,
                        indicator: BoxDecoration(),
                        onTap: (index) {
                          setState(() {
                            _currentTab = index;
                          });
                        },
                        tabs: [
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 3.0),
                            decoration: (_currentTab == 0)
                                ? BoxDecoration(
                                    borderRadius: BorderRadius.circular(50.0),
                                    gradient: LinearGradient(
                                      colors: [
                                        kOrangeOne,
                                        kOrangeTwo.withOpacity(0.05)
                                      ],
                                    ),
                                  )
                                : BoxDecoration(
                                    borderRadius: BorderRadius.circular(50.0),
                                  ),
                            child: Center(
                              child: Text(
                                "Score",
                                style: TextStyle(
                                  color: kTheTexts,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 3.0),
                            decoration: (_currentTab == 1)
                                ? BoxDecoration(
                                    borderRadius: BorderRadius.circular(50.0),
                                    gradient: LinearGradient(
                                      colors: [
                                        kOrangeOne,
                                        kOrangeTwo.withOpacity(0.05)
                                      ],
                                    ),
                                  )
                                : BoxDecoration(
                                    borderRadius: BorderRadius.circular(50.0),
                                  ),
                            child: Center(
                              child: Text(
                                "Wrong Answers",
                                style: TextStyle(
                                  color: kTheTexts,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      body: TabBarView(
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          Column(
                            children: [
                              Expanded(
                                child: Divider(
                                  color: kTheDivider.withOpacity(0.3),
                                  thickness: 2.0,
                                  indent: 20.0,
                                  endIndent: 20.0,
                                ),
                              ),
                              Expanded(
                                flex: 20,
                                child: Center(
                                  child: Container(
                                    height: MediaQuery.of(context).size.width *
                                        0.45,
                                    width: MediaQuery.of(context).size.width *
                                        0.45,
                                    padding: EdgeInsets.all(15.0),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        colors: [
                                          kOrangeOne,
                                          kOrangeTwo.withOpacity(0.05)
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          report.toString() + "%",
                                          textScaleFactor: 1.5,
                                          style: TextStyle(
                                            color: kTheTexts,
                                          ),
                                        ),
                                        //SizedBox(height: 5.0),
                                        Text(
                                          (report >= 80)
                                              ? "Passed!"
                                              : "Try Again!",
                                          textScaleFactor: 1.5,
                                          style: TextStyle(
                                            color: kTheTexts,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Expanded(
                                child: Divider(
                                  color: kTheDivider.withOpacity(0.3),
                                  thickness: 2.0,
                                  indent: 20.0,
                                  endIndent: 20.0,
                                ),
                              ),
                              Expanded(
                                flex: 20,
                                child: ListView.builder(
                                  itemCount: widget.wrong.length,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(10.0),
                                          child: Text(
                                            "Q: ${widget.wrong[index].question}",
                                            textScaleFactor: 1.3,
                                            style: TextStyle(color: kTheTexts),
                                          ),
                                        ),
                                        Container(
                                          width: double.maxFinite,
                                          padding: EdgeInsets.all(10.0),
                                          margin: EdgeInsets.all(10.0),
                                          decoration: BoxDecoration(
                                            color: kCorrectAnswer,
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                          ),
                                          child: Builder(
                                            builder: (context) {
                                              switch (widget
                                                  .wrong[index].correctAnswer) {
                                                case 'A':
                                                  return Text(
                                                    "${widget.wrong[index].optA}",
                                                    textScaleFactor: 1.2,
                                                    style: TextStyle(
                                                        color: kTheTexts),
                                                  );

                                                case 'B':
                                                  return Text(
                                                    "${widget.wrong[index].optB}",
                                                    textScaleFactor: 1.2,
                                                    style: TextStyle(
                                                        color: kTheTexts),
                                                  );

                                                default:
                                                  return Text(
                                                    "${widget.wrong[index].optC}",
                                                    textScaleFactor: 1.25,
                                                    style: TextStyle(
                                                        color: kTheTexts),
                                                  );
                                              }
                                            },
                                          ),
                                        ),
                                        Divider(
                                          color: kTheDivider.withOpacity(0.3),
                                          thickness: 2.0,
                                          indent: 20.0,
                                          endIndent: 20.0,
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
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
                              () => Navigator.of(context)
                                  .pushReplacementNamed('/beginPractice'),
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

class WrongAnswerPage extends StatefulWidget {
  final List<CdlQuestions> wrong;

  WrongAnswerPage({Key? key, required this.wrong}) : super(key: key);

  @override
  State<WrongAnswerPage> createState() => _WrongAnswerPageState();
}

class _WrongAnswerPageState extends State<WrongAnswerPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  OpenWebsite openWebsite =
      new OpenWebsite(initialUrl: 'https://cdlprepapp.com/');

  var lastSelected = 0;

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
                  color: Colors.blue.shade900,
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
                            color: Colors.white,
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
                            color: Colors.white,
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
                                      color: Colors.white,
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
                                  color: Colors.white,
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

    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        backgroundColor: Colors.blue.shade900,
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
                              height: 45.0,
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: Icon(
                                Icons.close,
                                color: Colors.white,
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
                      iconColor: Colors.white,
                      textColor: Colors.white,
                      dense: true,
                      horizontalTitleGap: 8.0,
                      style: ListTileStyle.drawer,
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                    ),
                    Divider(
                      color: Colors.white,
                      thickness: 1.0,
                      height: 8.0,
                    ),
                    ListTile(
                      leading: Icon(Icons.key),
                      title: Text(
                        "Change Password",
                        textScaleFactor: 1.3,
                      ),
                      iconColor: Colors.white,
                      textColor: Colors.white,
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
                      color: Colors.white,
                      thickness: 1.0,
                      height: 8.0,
                    ),
                    ListTile(
                      leading: Icon(Icons.person),
                      title: Text(
                        "Profile",
                        textScaleFactor: 1.3,
                      ),
                      iconColor: Colors.white,
                      textColor: Colors.white,
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
                      color: Colors.white,
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
                      color: Colors.white,
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
                      iconColor: Colors.white,
                      textColor: Colors.white,
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
              child: Image.asset(
                'assets/images/logo.png',
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
                    "Wrong Answers",
                    textScaleFactor: 0.9,
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
                          Navigator.of(context).pop();
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
                                ? Colors.blue.shade900
                                : Colors.grey,
                          ),
                        ),
                        Flexible(
                          child: Text(
                            "CDL Prep Test",
                            style: TextStyle(
                              color: (lastSelected == 5)
                                  ? Colors.blue.shade900
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
                          Navigator.of(context).pop();
                          Navigator.of(context)
                              .pushReplacementNamed('/beginPractice');
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
                                ? Colors.blue.shade900
                                : Colors.grey,
                          ),
                        ),
                        Flexible(
                          child: Text(
                            "CDL Practice",
                            style: TextStyle(
                              color: (lastSelected == 6)
                                  ? Colors.blue.shade900
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
                                ? Colors.blue.shade900
                                : Colors.grey,
                          ),
                        ),
                        Flexible(
                          child: Text(
                            "Visit Website",
                            style: TextStyle(
                              color: (lastSelected == 7)
                                  ? Colors.blue.shade900
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
                                ? Colors.blue.shade900
                                : Colors.grey,
                          ),
                        ),
                        Flexible(
                          child: Text(
                            "News",
                            style: TextStyle(
                              color: (lastSelected == 8)
                                  ? Colors.blue.shade900
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
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView.builder(
          itemCount: widget.wrong.length,
          itemBuilder: (context, index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    "Q: ${widget.wrong[index].question}",
                    textScaleFactor: 1.3,
                    style: TextStyle(color: Colors.blue.shade900),
                  ),
                ),
                Container(
                  width: double.maxFinite,
                  padding: EdgeInsets.all(10.0),
                  margin: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Builder(
                    builder: (context) {
                      switch (widget.wrong[index].correctAnswer) {
                        case 'A':
                          return Text(
                            "${widget.wrong[index].optA}",
                            textScaleFactor: 1.25,
                            style: TextStyle(color: Colors.green),
                          );

                        case 'B':
                          return Text(
                            "${widget.wrong[index].optB}",
                            textScaleFactor: 1.25,
                            style: TextStyle(color: Colors.green),
                          );

                        default:
                          return Text(
                            "${widget.wrong[index].optC}",
                            textScaleFactor: 1.25,
                            style: TextStyle(color: Colors.green),
                          );
                      }
                    },
                  ),
                ),
                Divider(
                  color: Colors.blue.shade900.withOpacity(0.3),
                  thickness: 2.0,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
