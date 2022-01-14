import 'package:cdl_prep/api/api.dart';
import 'package:cdl_prep/colour_scheme.dart';
import 'package:cdl_prep/models/dataModels.dart';
import 'package:cdl_prep/screens/website.dart';
import 'package:cdl_prep/widgets/dashboardExtras.dart';
import 'package:dropdown_below/dropdown_below.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PracticeScreen extends StatefulWidget {
  final int initialCategory;
  PracticeScreen({Key? key, required this.initialCategory}) : super(key: key);

  @override
  _PracticeScreenState createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  WebApi webApi = new WebApi();
  Future<dynamic> getCat() => WebApi().getCategories();

  var selectedCategory;
  var _value;
  var qL;
  var lastSelected = 0;

  int questionIndex = 1;
  int cat = 0;

  bool showAnswer = false;

  late final List<CdlQuestions> temp;

  @override
  void initState() {
    super.initState();
    cat = widget.initialCategory;
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController questionController = TextEditingController();

    Future<List<CdlQuestions>> setQuestions() =>
        WebApi().getQuestions(cat.toString(), "1");

    List<DropdownMenuItem<int>> buildItems(AsyncSnapshot snapshot) {
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

    startFrom() {
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
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(),
                          ),
                          Expanded(
                            flex: 2,
                            child: Center(
                              child: Text(
                                "Start From",
                                textScaleFactor: 1.4,
                                style: TextStyle(
                                  color: kTheTexts,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              onPressed: () => Navigator.of(context).pop(),
                              icon: Icon(
                                Icons.close_rounded,
                                color: kTheTexts,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Center(
                        child: TextFormField(
                          controller: questionController,
                          cursorColor: kTheTexts,
                          cursorRadius: Radius.circular(30.0),
                          maxLines: 1,
                          keyboardType: TextInputType.number,
                          style: TextStyle(color: kTheTexts),
                          decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: kTheTexts),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: kTheTexts),
                            ),
                            labelText: "Question to start from (1 - $qL)",
                            labelStyle: TextStyle(color: kTheTexts),
                            counterText: "",
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: GestureDetector(
                        onTap: () {
                          if (1 <= int.parse(questionController.text) &&
                              int.parse(questionController.text) <= qL) {
                            setState(() {
                              questionIndex =
                                  int.parse(questionController.text);
                            });
                            Navigator.of(context).pop();
                          } else
                            Fluttertoast.showToast(
                              msg: "input in range 1 - $qL",
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
            ),
          );
        },
      );
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
                flex: 3,
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
                                "Practice",
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
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => startFrom(),
                          child: Text(
                            "Start from",
                            style: TextStyle(color: kTheTexts),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 13,
                child: Padding(
                  padding:
                      EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15.0),
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
                                  hint: Text("Change Category"),
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
                                      showAnswer = false;
                                      _value = null;
                                      questionIndex = 1;
                                    });
                                  },
                                ),
                                Divider(
                                  color: kTheTexts,
                                  thickness: 1.1,
                                  indent: 5.0,
                                  endIndent: 5.0,
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
                          height: MediaQuery.of(context).size.height * 0.04),
                      Expanded(
                        child: FutureBuilder(
                          future: setQuestions(),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData) {
                              qL = snapshot.data.length as int;
                              return questionAndAnswer(snapshot);
                            } else if (snapshot.hasError)
                              return Center(
                                child: Text("Something went wrong :("),
                              );
                            else
                              return Center(
                                child: Container(
                                  height: 50,
                                  width: 50,
                                  child: CircularProgressIndicator(
                                      color: kTheTexts),
                                ),
                              );
                          },
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
                  padding:
                      EdgeInsets.only(bottom: 15.0, left: 15.0, right: 15.0),
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

  Widget questionAndAnswer(AsyncSnapshot snapshot) {
    Color colorLogic(String currentOpt) {
      if (showAnswer) {
        if (snapshot.data[questionIndex - 1].correctAnswer == currentOpt)
          return kCorrectAnswer;
        else {
          if (_value == currentOpt)
            return kWrongAnswer;
          else
            return Colors.transparent;
        }
      } else
        return Colors.transparent;
    }

    return Container(
      //height: double.maxFinite,
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
                      "Question $questionIndex of ${snapshot.data.length}",
                      textScaleFactor: 1.1,
                      style: TextStyle(color: kTheTexts),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(),
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
              "${snapshot.data[questionIndex - 1].question}",
              textScaleFactor: 1.4,
              style: TextStyle(color: kTheTexts),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            Container(
              decoration: BoxDecoration(
                color: colorLogic("A"),
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: RadioListTile(
                value: "A",
                groupValue: _value,
                title: Text(
                  "${snapshot.data[questionIndex - 1].optA}",
                  textScaleFactor: 1.25,
                  style: TextStyle(color: kTheTexts),
                ),
                activeColor: kTheTexts,
                onChanged: (value) {
                  setState(() {
                    _value = value;
                    showAnswer = true;
                  });
                },
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            Container(
              decoration: BoxDecoration(
                color: colorLogic("B"),
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: RadioListTile(
                value: "B",
                groupValue: _value,
                title: Text(
                  "${snapshot.data[questionIndex - 1].optB}",
                  textScaleFactor: 1.25,
                  style: TextStyle(color: kTheTexts),
                ),
                activeColor: kTheTexts,
                onChanged: (value) {
                  setState(() {
                    _value = value;
                    showAnswer = true;
                  });
                },
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            Container(
              decoration: BoxDecoration(
                color: colorLogic("C"),
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: RadioListTile(
                value: "C",
                groupValue: _value,
                title: Text(
                  "${snapshot.data[questionIndex - 1].optC}",
                  textScaleFactor: 1.25,
                  style: TextStyle(color: kTheTexts),
                ),
                activeColor: kTheTexts,
                onChanged: (value) {
                  setState(() {
                    _value = value;
                    showAnswer = true;
                  });
                },
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            GestureDetector(
              onTap: () {
                if (_value != null) {
                  setState(() {
                    showAnswer = false;
                    _value = null;
                    (questionIndex == snapshot.data.length)
                        ? Navigator.of(context).pop()
                        : questionIndex++;
                  });
                  if (questionIndex == snapshot.data.length)
                    Fluttertoast.showToast(
                      msg: "All questions completed!",
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: kTheTexts,
                      textColor: Colors.white,
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
