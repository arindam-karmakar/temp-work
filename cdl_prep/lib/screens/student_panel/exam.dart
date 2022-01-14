import 'dart:async';
import 'package:cdl_prep/api/api.dart';
import 'package:cdl_prep/api/userPrefs.dart';
import 'package:cdl_prep/colour_scheme.dart';
import 'package:cdl_prep/models/dataModels.dart';
import 'package:cdl_prep/models/userModel.dart';
import 'package:cdl_prep/screens/student_panel/result.dart';
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

  @override
  Widget build(BuildContext context) {
    CdlUser user = Provider.of<CdlUserProvider>(context).user;
    setState(() {
      cdlUser = user;
    });

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
    );
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
                      style: TextStyle(color: kTheTexts),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: CustomTimer(
                      from: Duration(minutes: widget.time),
                      to: Duration(seconds: 0),
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
                            ),
                          ),
                        );
                      },
                      builder: (remaining) {
                        return Text(
                          "${remaining.minutes}:${remaining.seconds}",
                          textScaleFactor: 1.35,
                          style: TextStyle(
                            color: kTheTexts,
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
              color: kTheDivider.withOpacity(0.3),
              thickness: 2.0,
              indent: 5.0,
              endIndent: 5.0,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            Text(
              "${thisRoundQuestions[questionIndex - 1].question}",
              textScaleFactor: 1.4,
              style: TextStyle(color: kTheTexts),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            RadioListTile(
              value: "A",
              groupValue: _value,
              title: Text(
                "${thisRoundQuestions[questionIndex - 1].optA}",
                textScaleFactor: 1.25,
                style: TextStyle(color: kTheTexts),
              ),
              activeColor: kTheTexts,
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
                style: TextStyle(color: kTheTexts),
              ),
              activeColor: kTheTexts,
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
                style: TextStyle(color: kTheTexts),
              ),
              activeColor: kTheTexts,
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
                    borderRadius: BorderRadius.circular(50.0),
                    gradient: LinearGradient(
                      colors: [kOrangeOne, kOrangeTwo.withOpacity(0.05)],
                    ),
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
