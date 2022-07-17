import 'dart:async';
import 'package:eldtprep/api/api.dart';
import 'package:eldtprep/api/userPrefs.dart';
import 'package:eldtprep/colour_scheme.dart';
import 'package:eldtprep/models/dataModels.dart';
import 'package:eldtprep/models/userModel.dart';
import 'package:eldtprep/screens/resetPassword.dart';
import 'package:eldtprep/screens/student_panel/result.dart';
import 'package:eldtprep/screens/student_panel/student_profile.dart';
import 'package:custom_timer/custom_timer.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class ExamScreen extends StatefulWidget {
  final int categoryId, time, questions;
  ExamScreen({
    Key? key,
    required this.categoryId,
    required this.questions,
    required this.time,
  }) : super(key: key);

  @override
  _ExamScreenState createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<List<CdlQuestions>> setQuestions() =>
      WebApi().getQuestions(widget.categoryId.toString(), "1");

  WebApi webApi = new WebApi();
  late CdlUser cdlUser;

  int totalAnswer = 0;
  int correctAnswer = 0;
  int wrongAnswer = 0;
  int questionIndex = 1;

  late final List<CdlQuestions> temp;
  List<CdlQuestions> wrong = [];
  bool listHasData = false;

  var _value;

  setResult() async {
    final String report = await webApi.setUserScore(
      cdlUser.userid.toString(),
      widget.categoryId.toString(),
      totalAnswer,
      wrongAnswer,
      correctAnswer,
    );

    Fluttertoast.showToast(
      msg: "Result upload: " + report,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: kTheTexts,
      textColor: Colors.white,
    );
  }

  void confirmEndTest() {
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
                        "Finish",
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
                        "Do you really want to finish exam?",
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
                            onTap: () {
                              setResult();
                              Navigator.of(context).pop();
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => ResultScreen(
                                    totalAnswer: totalAnswer,
                                    correctAnswer: correctAnswer,
                                    wrongAnswer: wrongAnswer,
                                    totalQuestions: widget.questions,
                                    categoryId: widget.categoryId,
                                    wrong: wrong,
                                    questions: widget.questions,
                                    time: widget.time,
                                  ),
                                ),
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

  @override
  Widget build(BuildContext context) {
    CdlUser user = Provider.of<CdlUserProvider>(context).user;
    setState(() {
      cdlUser = user;
    });

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
                    "Exam",
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Align(
              alignment: Alignment.topRight,
              child: MaterialButton(
                onPressed: () => confirmEndTest(),
                color: kEldtButton,
                elevation: 0.0,
                highlightElevation: 0.0,
                child: Text(
                  "Finish",
                  textScaleFactor: 1.2,
                  style: TextStyle(color: kTheTexts),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: FutureBuilder(
                future: setQuestions(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData)
                    return questionAndAnswer(snapshot);
                  else if (snapshot.hasError)
                    return Center(
                      child: Text("Something went wrong :("),
                    );
                  else
                    return Center(
                      child: Container(
                        height: 50,
                        width: 50,
                        child: CircularProgressIndicator(color: kTheTexts),
                      ),
                    );
                },
              ),
            ),
          ),
        ],
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
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Exam",
                                  textScaleFactor: 1.4,
                                  style: TextStyle(color: Colors.blue[900]),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: GestureDetector(
                                  onTap: () {
                                    setResult();
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (context) => ResultScreen(
                                          totalAnswer: totalAnswer,
                                          correctAnswer: correctAnswer,
                                          wrongAnswer: wrongAnswer,
                                          totalQuestions: widget.questions,
                                          categoryId: widget.categoryId,
                                          wrong: wrong,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "Finish",
                                    textScaleFactor: 1.4,
                                    style: TextStyle(color: Colors.blue[900]),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
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
                flex: 11,
                child: Padding(
                  padding: EdgeInsets.all(15.0),
                  child: FutureBuilder(
                    future: setQuestions(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData)
                        return questionAndAnswer(snapshot);
                      else if (snapshot.hasError)
                        return Center(
                          child: Text("Something went wrong :("),
                        );
                      else
                        return Center(
                          child: Container(
                            height: 50,
                            width: 50,
                            child: CircularProgressIndicator(color: kTheTexts),
                          ),
                        );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );*/
  }

  Widget questionAndAnswer(AsyncSnapshot snapshot) {
    if (!listHasData) {
      temp = snapshot.data;
      temp.shuffle();
      listHasData = true;
    }

    final List<CdlQuestions> thisRoundQuestions =
        temp.sublist(0, widget.questions);

    checkAnswer() {
      if (_value != null) {
        if (_value.toString() ==
            thisRoundQuestions[questionIndex - 1].correctAnswer) {
          setState(() {
            correctAnswer++;
          });
        } else {
          setState(() {
            wrongAnswer++;
            wrong.add(thisRoundQuestions[questionIndex - 1]);
          });
        }
        setState(() {
          totalAnswer++;
        });
      }
    }

    return Container(
      height: double.maxFinite,
      width: double.maxFinite,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Question $questionIndex of ${widget.questions}",
                      textScaleFactor: 1.1,
                      style: TextStyle(color: Colors.blue.shade900),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: CustomTimer(
                      from: Duration(minutes: widget.time),
                      to: const Duration(seconds: 0),
                      onBuildAction: CustomTimerAction.auto_start,
                      onFinish: () {
                        setResult();
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => ResultScreen(
                              totalAnswer: totalAnswer,
                              correctAnswer: correctAnswer,
                              wrongAnswer: wrongAnswer,
                              totalQuestions: widget.questions,
                              categoryId: widget.categoryId,
                              wrong: wrong,
                              questions: widget.questions,
                              time: widget.time,
                            ),
                          ),
                        );
                      },
                      builder: (remaining) {
                        return Text(
                          "${remaining.minutes}:${remaining.seconds}",
                          textScaleFactor: 1.35,
                          style: TextStyle(
                            color: Colors.blue.shade900,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.0),
            Divider(
              color: Colors.blue.shade900.withOpacity(0.3),
              thickness: 2.0,
              indent: 5.0,
              endIndent: 5.0,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            Text(
              "${thisRoundQuestions[questionIndex - 1].question}",
              textScaleFactor: 1.4,
              style: TextStyle(color: Colors.blue.shade900),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            RadioListTile(
              value: "A",
              groupValue: _value,
              title: Text(
                "${thisRoundQuestions[questionIndex - 1].optA}",
                textScaleFactor: 1.25,
                style: TextStyle(color: Colors.blue.shade900),
              ),
              activeColor: Colors.blue.shade900,
              onChanged: (value) {
                setState(() {
                  _value = value;
                });
              },
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            RadioListTile(
              value: "B",
              groupValue: _value,
              title: Text(
                "${thisRoundQuestions[questionIndex - 1].optB}",
                textScaleFactor: 1.25,
                style: TextStyle(color: Colors.blue.shade900),
              ),
              activeColor: Colors.blue.shade900,
              onChanged: (value) {
                setState(() {
                  _value = value;
                });
              },
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            RadioListTile(
              value: "C",
              groupValue: _value,
              title: Text(
                "${thisRoundQuestions[questionIndex - 1].optC}",
                textScaleFactor: 1.25,
                style: TextStyle(color: Colors.blue.shade900),
              ),
              activeColor: Colors.blue.shade900,
              onChanged: (value) {
                setState(() {
                  _value = value;
                });
              },
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            GestureDetector(
              onTap: (questionIndex < widget.questions)
                  ? () {
                      if (_value != null) {
                        setState(() {
                          checkAnswer();
                          _value = null;
                          questionIndex++;
                        });
                      } else
                        Fluttertoast.showToast(
                          msg: "Please choose an answer before proceeding",
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: kTheTexts,
                          textColor: Colors.white,
                        );
                    }
                  : () {
                      if (_value != null) {
                        setState(() {
                          checkAnswer();
                          _value = null;
                        });
                        setResult();
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => ResultScreen(
                              totalAnswer: totalAnswer,
                              correctAnswer: correctAnswer,
                              wrongAnswer: wrongAnswer,
                              totalQuestions: widget.questions,
                              categoryId: widget.categoryId,
                              wrong: wrong,
                              questions: widget.questions,
                              time: widget.time,
                            ),
                          ),
                        );
                      } else
                        Fluttertoast.showToast(
                          msg: "Please choose an answer before proceeding",
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: kTheTexts,
                          textColor: Colors.white,
                        );
                    },
              child: Center(
                child: Container(
                  height: 50.0,
                  width: 150.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    color: kEldtButton,
                  ),
                  child: Center(
                    child: Text(
                      "Submit",
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
    );
  }
}
