import 'package:cdl_prep/api/api.dart';
import 'package:cdl_prep/colour_scheme.dart';
import 'package:cdl_prep/models/dataModels.dart';
import 'package:cdl_prep/screens/website.dart';
import 'package:cdl_prep/widgets/dashboardExtras.dart';
import 'package:flutter/material.dart';

class ResultScreen extends StatefulWidget {
  final int totalAnswer;
  final int correctAnswer;
  final int wrongAnswer;
  final int totalQuestions;
  final int categoryId;
  final List<CdlQuestions> wrong;
  ResultScreen({
    Key? key,
    required this.totalAnswer,
    required this.correctAnswer,
    required this.wrongAnswer,
    required this.totalQuestions,
    required this.categoryId,
    required this.wrong,
  }) : super(key: key);

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  WebApi webApi = new WebApi();

  var lastSelected = 0;
  int _currentTab = 0;

  @override
  Widget build(BuildContext context) {
    final int report =
        ((widget.correctAnswer / widget.totalQuestions) * 100).round();

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
    );
  }
}
