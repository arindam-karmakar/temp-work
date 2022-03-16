import 'package:cdl_prep/api/api.dart';
import 'package:cdl_prep/api/userPrefs.dart';
import 'package:cdl_prep/colour_scheme.dart';
import 'package:cdl_prep/logic/resume_practice_logic.dart';
import 'package:cdl_prep/models/dataModels.dart';
import 'package:cdl_prep/models/userModel.dart';
import 'package:cdl_prep/screens/resetPassword.dart';
import 'package:cdl_prep/screens/student_panel/student_profile.dart';
import 'package:cdl_prep/screens/website.dart';
import 'package:cdl_prep/widgets/dashboardExtras.dart';
import 'package:dropdown_below/dropdown_below.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class PracticeScreen extends StatefulWidget {
  final int initialCategory;
  final String categoryName;
  int? continueQ;

  PracticeScreen({
    Key? key,
    required this.initialCategory,
    required this.categoryName,
    this.continueQ,
  }) : super(key: key);

  @override
  _PracticeScreenState createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  OpenWebsite openWebsite =
      new OpenWebsite(initialUrl: 'https://cdlprepapp.com/');

  WebApi webApi = new WebApi();
  Future<dynamic> getCat() => WebApi().getCategories();

  var selectedCategory;
  var _value;
  var qL;
  var lastSelected = 6;

  int questionIndex = 1;
  int cat = 0;

  bool showAnswer = false;

  late final List<CdlQuestions> temp;

  @override
  void initState() {
    super.initState();
    cat = widget.initialCategory;
    if (widget.continueQ != null) questionIndex = widget.continueQ as int;
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

    restartPractice() {
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
                          "Exit",
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
                          "Do you really want to exit practice & go to categories page?",
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
                                Navigator.of(context).pop();
                                Navigator.of(context)
                                    .pushReplacementNamed('/beginPractice');
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
                  color: Colors.blue.shade900,
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
                                  color: Colors.white,
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
                                color: Colors.white,
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
                          cursorColor: Colors.white,
                          cursorRadius: Radius.circular(30.0),
                          maxLines: 1,
                          keyboardType: TextInputType.number,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            labelText: "Question to start from (1 - $qL)",
                            labelStyle: TextStyle(color: Colors.white),
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
                            color: Colors.white,
                          ),
                          child: Center(
                            child: Text(
                              "Ok",
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
            ),
          );
        },
      );
    }

    addToResumePracticeProvider(ResumeModule input) {
      var data =
          Provider.of<ResumePracticeProvider>(context, listen: false).modules;

      if (data!.length != 0) {
        for (var i = 0; i < data.length; i++) {
          if (data[i].categoryName == input.categoryName) {
            Provider.of<ResumePracticeProvider>(context, listen: false)
                .replaceModule(i, input);
          } else {
            if (i == data.length - 1) {
              Provider.of<ResumePracticeProvider>(context, listen: false)
                  .setModules(input);
            }
          }
        }
      } else {
        Provider.of<ResumePracticeProvider>(context, listen: false)
            .setModules(input);
      }
    }

    removeFromResumePracticeProvider(String input) {
      var data =
          Provider.of<ResumePracticeProvider>(context, listen: false).modules;

      for (var i = 0; i < data!.length; i++) {
        if (data[i].categoryName == input) {
          Provider.of<ResumePracticeProvider>(context, listen: false)
              .removeModule(i);
        }
      }
    }

    Widget questionAndAnswer(AsyncSnapshot snapshot) {
      Color colorLogic(String currentOpt) {
        if (showAnswer) {
          if (snapshot.data[questionIndex - 1].correctAnswer == currentOpt)
            return Colors.green;
          else {
            if (_value == currentOpt)
              return Colors.red;
            else
              return Colors.blue.shade900;
          }
        } else
          return Colors.blue.shade900;
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
                        style: TextStyle(color: Colors.blue.shade900),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: MaterialButton(
                        onPressed: () => startFrom(),
                        child: Text('Start From'),
                        textColor: Colors.white,
                        color: Colors.blue.shade900,
                        padding: EdgeInsets.zero,
                        elevation: 0.0,
                        highlightElevation: 0.0,
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
                "${snapshot.data[questionIndex - 1].question}",
                textScaleFactor: 1.4,
                style: TextStyle(color: Colors.blue.shade900),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: RadioListTile(
                  value: "A",
                  groupValue: _value,
                  title: Text(
                    "${snapshot.data[questionIndex - 1].optA}",
                    textScaleFactor: 1.25,
                    style: TextStyle(color: colorLogic("A")),
                  ),
                  activeColor: Colors.blue.shade900,
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
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: RadioListTile(
                  value: "B",
                  groupValue: _value,
                  title: Text(
                    "${snapshot.data[questionIndex - 1].optB}",
                    textScaleFactor: 1.25,
                    style: TextStyle(color: colorLogic("B")),
                  ),
                  activeColor: Colors.blue.shade900,
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
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: RadioListTile(
                  value: "C",
                  groupValue: _value,
                  title: Text(
                    "${snapshot.data[questionIndex - 1].optC}",
                    textScaleFactor: 1.25,
                    style: TextStyle(color: colorLogic("C")),
                  ),
                  activeColor: Colors.blue.shade900,
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
                  Progress progress = Progress();

                  if (_value != null) {
                    setState(() {
                      showAnswer = false;
                      _value = null;
                      if (questionIndex == snapshot.data.length) {
                        Navigator.of(context).pop();

                        progress.remove(widget.categoryName);
                        progress.remove('lastCategoryPractice');

                        Provider.of<ResumePracticeProvider>(context,
                                listen: false)
                            .setLastCategory('null');

                        removeFromResumePracticeProvider(widget.categoryName);

                        progress.resetQuestionsAttempted(widget.categoryName);
                        Provider.of<ResumePracticeProvider>(context,
                                listen: false)
                            .resetCategoryWiseQuestionsDone(
                                widget.categoryName);

                        Fluttertoast.showToast(
                          msg: "All questions completed!",
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: kTheTexts,
                          textColor: Colors.white,
                        );
                      } else {
                        progress.save(ResumeModule(
                          categoryId: widget.initialCategory,
                          categoryName: widget.categoryName,
                          question: questionIndex,
                        ));

                        progress.setLast(widget.categoryName);

                        Provider.of<ResumePracticeProvider>(context,
                                listen: false)
                            .setLastCategory(widget.categoryName);

                        addToResumePracticeProvider(ResumeModule(
                          categoryId: widget.initialCategory,
                          categoryName: widget.categoryName,
                          question: questionIndex,
                        ));

                        progress.setQuestionsAttempted(
                            questionIndex.toString(), widget.categoryName);
                        Provider.of<ResumePracticeProvider>(context,
                                listen: false)
                            .setCategoryWiseQuestionsDone(
                                questionIndex.toString(), widget.categoryName);

                        questionIndex++;
                      }
                    });
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
                      color: Colors.blue.shade900,
                    ),
                    child: Center(
                      child: Text(
                        "Submit",
                        textScaleFactor: 1.2,
                        style: TextStyle(
                          color: Colors.white,
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
                    "Practice",
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

                      restartPractice();
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
        child: FutureBuilder(
          future: setQuestions(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
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
                  child: CircularProgressIndicator(color: kTheTexts),
                ),
              );
          },
        ),
      ),
    );

    /*return Scaffold(
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
    );*/
  }
}
