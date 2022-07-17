import 'package:eldtprep/api/api.dart';
import 'package:eldtprep/api/userPrefs.dart';
import 'package:eldtprep/colour_scheme.dart';
import 'package:eldtprep/logic/resume_practice_logic.dart';
import 'package:eldtprep/models/userModel.dart';
import 'package:eldtprep/screens/student_panel/home.dart';
import 'package:eldtprep/widgets/extras.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  TextEditingController schoolPhoneController = TextEditingController();
  TextEditingController schoolPasswordController = TextEditingController();

  WebApi webApi = new WebApi();

  TextFormField myTextField(
    TextEditingController currentController,
    int maxLength,
    bool obscureText,
    bool enableInteractiveSelection,
    TextInputType keyboardType,
    String labelText,
  ) {
    return TextFormField(
      controller: currentController,
      cursorColor: kTheTexts,
      cursorRadius: Radius.circular(30.0),
      maxLines: 1,
      maxLength: maxLength,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: TextStyle(color: kTheTexts),
      enableInteractiveSelection: enableInteractiveSelection,
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: kTheTexts),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: kTheTexts),
        ),
        labelText: labelText,
        labelStyle: TextStyle(color: kTheTexts),
        counterText: "",
      ),
      validator: (input) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);

    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) {
        return Container(
          height: double.maxFinite,
          width: double.maxFinite,
          color: Colors.black.withOpacity(0.2),
          child: Center(
            child: Container(
              height: 30.0,
              width: 30.0,
              child: CircularProgressIndicator(color: kTheTexts),
            ),
          ),
        );
      },
    );

    return Scaffold(
      //resizeToAvoidBottomInset: false,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        // decoration: BoxDecoration(
        //   gradient: LinearGradient(
        //     colors: [kBlueWhite, kPrimary, kPrimary],
        //     begin: Alignment.topLeft,
        //     end: Alignment.bottomRight,
        //  ),
        // ),
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
                      Text(
                        "Login",
                        textScaleFactor: 1.5,
                        style: TextStyle(color: Colors.blue[900]),
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
                flex: 12,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 15.0),
                  child: Stack(
                    children: [
                      Container(
                        height: double.maxFinite,
                        width: double.maxFinite,
                        child: Column(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: ListView(
                                      padding: EdgeInsets.only(
                                          left: 15.0, right: 30.0),
                                      children: [
                                        Center(
                                          child: Text(
                                            "Login as Student",
                                            textScaleFactor: 1.2,
                                            style: TextStyle(color: kTheTexts),
                                          ),
                                        ),
                                        Center(
                                          child: myTextField(
                                              phoneController,
                                              10,
                                              false,
                                              true,
                                              TextInputType.phone,
                                              "Phone *"),
                                        ),
                                        Center(
                                          child: myTextField(
                                              passwordController,
                                              50,
                                              true,
                                              false,
                                              TextInputType.visiblePassword,
                                              "Password *"),
                                        ),
                                        Center(
                                          child: GestureDetector(
                                            onTap: () async {
                                              if (phoneController
                                                      .text.isEmpty ||
                                                  passwordController
                                                      .text.isEmpty)
                                                Fluttertoast.showToast(
                                                  msg:
                                                      "Please fill-up all the fields",
                                                  gravity: ToastGravity.BOTTOM,
                                                  backgroundColor: kTheTexts,
                                                  textColor: Colors.white,
                                                );
                                              else {
                                                if (phoneController
                                                        .text.length !=
                                                    10)
                                                  Fluttertoast.showToast(
                                                    msg:
                                                        "Please enter valid phone number",
                                                    gravity:
                                                        ToastGravity.BOTTOM,
                                                    backgroundColor: kTheTexts,
                                                    textColor: Colors.white,
                                                  );
                                                else {
                                                  Overlay.of(context)!.insert(
                                                    overlayEntry,
                                                  );

                                                  String userType = await webApi
                                                      .checkLoginAccount(
                                                          phoneController.text);

                                                  if (userType == 'Student') {
                                                    CdlUser _cdlUser =
                                                        await authProvider.login(
                                                            phoneController
                                                                .text,
                                                            passwordController
                                                                .text);

                                                    overlayEntry.remove();

                                                    if (_cdlUser.name ==
                                                            "null" ||
                                                        _cdlUser.name == "name")
                                                      Fluttertoast.showToast(
                                                        msg:
                                                            "Enter correct credentials!",
                                                        gravity:
                                                            ToastGravity.BOTTOM,
                                                        backgroundColor:
                                                            kTheTexts,
                                                        textColor: Colors.white,
                                                      );
                                                    else {
                                                      Provider.of<CdlUserProvider>(
                                                              context,
                                                              listen: false)
                                                          .setUser(_cdlUser);

                                                      Fluttertoast.showToast(
                                                        msg: "Login successful",
                                                        gravity:
                                                            ToastGravity.BOTTOM,
                                                        backgroundColor:
                                                            kTheTexts,
                                                        textColor: Colors.white,
                                                      );
                                                      Navigator.of(context).pushReplacement(
                                                          MaterialPageRoute(
                                                              builder: (_) =>
                                                                  FutureBuilder<
                                                                      Map<String,
                                                                          dynamic>>(
                                                                    future: Progress()
                                                                        .getLast(),
                                                                    builder:
                                                                        (context,
                                                                            lastData) {
                                                                      if (lastData
                                                                          .hasData) {
                                                                        return FutureBuilder<
                                                                            List>(
                                                                          future:
                                                                              Progress().getAll(),
                                                                          builder:
                                                                              (BuildContext context, AsyncSnapshot getAllData) {
                                                                            if (getAllData.hasData) {
                                                                              return FutureBuilder<List>(
                                                                                future: Progress().getAllQuestionsAttempted(),
                                                                                builder: (context, categoryWiseQuestionsDone) {
                                                                                  if (categoryWiseQuestionsDone.hasData) {
                                                                                    return SetDashboard(
                                                                                      lastCategory: (lastData.data!['status'] == 'ok') ? lastData.data!['data'] : "null",
                                                                                      allLast: getAllData.data,
                                                                                      allCategoryWiseQuestionsDone: categoryWiseQuestionsDone.data as List,
                                                                                    );
                                                                                  } else {
                                                                                    return homeWaiting();
                                                                                  }
                                                                                },
                                                                              );
                                                                            } else
                                                                              return homeWaiting();
                                                                          },
                                                                        );
                                                                      } else
                                                                        return homeWaiting();
                                                                    },
                                                                  )));
                                                    }
                                                  } else {
                                                    overlayEntry.remove();
                                                    Fluttertoast.showToast(
                                                      msg:
                                                          "This is a school account, please login as school!",
                                                      gravity:
                                                          ToastGravity.BOTTOM,
                                                      backgroundColor:
                                                          kTheTexts,
                                                      textColor: Colors.white,
                                                    );
                                                  }
                                                }
                                              }
                                            },
                                            child: Container(
                                              margin:
                                                  EdgeInsets.only(top: 10.0),
                                              height: 30.0,
                                              width: 120.0,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                color: kEldtButton,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  "Submit",
                                                  textScaleFactor: 1.2,
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Center(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Flexible(
                                                flex: 2,
                                                child: Text(
                                                  "Don't have account ?",
                                                  textScaleFactor: 0.9,
                                                  style: TextStyle(
                                                    color: kTheTexts,
                                                  ),
                                                ),
                                              ),
                                              Flexible(
                                                child: TextButton(
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pushNamed(
                                                              '/studentSignup'),
                                                  child: Text(
                                                    "Signup",
                                                    textScaleFactor: 0.9,
                                                    style: TextStyle(
                                                      color:
                                                          Colors.blue.shade900,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Center(
                                          child: GestureDetector(
                                            onTap: () => Navigator.of(context)
                                                .pushNamed('/resetPassword'),
                                            child: Text(
                                              "Reset Password",
                                              style: TextStyle(
                                                color: kTheTexts,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: ListView(
                                      reverse: true,
                                      padding: EdgeInsets.only(
                                          left: 30.0, right: 15.0),
                                      children: [
                                        Center(
                                          child: GestureDetector(
                                            onTap: () => Navigator.of(context)
                                                .pushNamed('/resetPassword'),
                                            child: Text(
                                              "Reset Password",
                                              style: TextStyle(
                                                color: kTheTexts,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Center(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Flexible(
                                                flex: 2,
                                                child: Text(
                                                  "Don't have account ?",
                                                  textScaleFactor: 0.9,
                                                  style: TextStyle(
                                                    color: kTheTexts,
                                                  ),
                                                ),
                                              ),
                                              Flexible(
                                                child: TextButton(
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pushNamed(
                                                              '/schoolSignup'),
                                                  child: Text(
                                                    "Signup",
                                                    textScaleFactor: 0.9,
                                                    style: TextStyle(
                                                      color:
                                                          Colors.blue.shade900,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Center(
                                          child: GestureDetector(
                                            onTap: () async {
                                              if (schoolPhoneController
                                                      .text.isEmpty ||
                                                  schoolPasswordController
                                                      .text.isEmpty)
                                                Fluttertoast.showToast(
                                                  msg:
                                                      "Please fill-up all the fields",
                                                  gravity: ToastGravity.BOTTOM,
                                                  backgroundColor: kTheTexts,
                                                  textColor: Colors.white,
                                                );
                                              else {
                                                if (schoolPhoneController
                                                        .text.length !=
                                                    10)
                                                  Fluttertoast.showToast(
                                                    msg:
                                                        "Please enter valid phone number",
                                                    gravity:
                                                        ToastGravity.BOTTOM,
                                                    backgroundColor: kTheTexts,
                                                    textColor: Colors.white,
                                                  );
                                                else {
                                                  Overlay.of(context)!.insert(
                                                    overlayEntry,
                                                  );

                                                  String userType = await webApi
                                                      .checkLoginAccount(
                                                          schoolPhoneController
                                                              .text);

                                                  if (userType == 'School') {
                                                    CdlSchool _cdlSchool =
                                                        await authProvider.loginSchool(
                                                            schoolPhoneController
                                                                .text,
                                                            schoolPasswordController
                                                                .text);

                                                    overlayEntry.remove();

                                                    if (_cdlSchool.name ==
                                                            "null" ||
                                                        _cdlSchool.name ==
                                                            "name")
                                                      Fluttertoast.showToast(
                                                        msg:
                                                            "Enter correct credentials!",
                                                        gravity:
                                                            ToastGravity.BOTTOM,
                                                        backgroundColor:
                                                            kTheTexts,
                                                        textColor: Colors.white,
                                                      );
                                                    else {
                                                      Provider.of<CdlSchoolProvider>(
                                                              context,
                                                              listen: false)
                                                          .setSchool(
                                                              _cdlSchool);

                                                      Fluttertoast.showToast(
                                                        msg: "Login successful",
                                                        gravity:
                                                            ToastGravity.BOTTOM,
                                                        backgroundColor:
                                                            kTheTexts,
                                                        textColor: Colors.white,
                                                      );
                                                      Navigator.of(context)
                                                          .pushReplacementNamed(
                                                              '/schoolDashboard');
                                                    }
                                                  } else {
                                                    overlayEntry.remove();
                                                    Fluttertoast.showToast(
                                                      msg:
                                                          "This is a student account, please login as student!",
                                                      gravity:
                                                          ToastGravity.BOTTOM,
                                                      backgroundColor:
                                                          kTheTexts,
                                                      textColor: Colors.white,
                                                    );
                                                  }
                                                }
                                              }
                                            },
                                            child: Container(
                                              margin:
                                                  EdgeInsets.only(top: 10.0),
                                              height: 30.0,
                                              width: 120.0,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                color: kEldtButton,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  "Submit",
                                                  textScaleFactor: 1.2,
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Center(
                                          child: myTextField(
                                              schoolPasswordController,
                                              50,
                                              true,
                                              false,
                                              TextInputType.visiblePassword,
                                              "Password *"),
                                        ),
                                        Center(
                                          child: myTextField(
                                              schoolPhoneController,
                                              10,
                                              false,
                                              true,
                                              TextInputType.phone,
                                              "Phone *"),
                                        ),
                                        Center(
                                          child: Text(
                                            "Login as School",
                                            textScaleFactor: 1.2,
                                            style: TextStyle(color: kTheTexts),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      (MediaQuery.of(context).viewInsets.bottom == 0.0)
                          ? Center(
                              child: Container(
                                height: double.maxFinite,
                                width: double.maxFinite,
                                child: Transform.rotate(
                                  angle: -45.0,
                                  child: Divider(
                                    color: kTheDivider.withOpacity(0.0),
                                    thickness: 2,
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                      (MediaQuery.of(context).viewInsets.bottom == 0.0)
                          ? Center(
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.07,
                                width: MediaQuery.of(context).size.height *
                                    0.07 *
                                    3,
                                child: Image.asset(
                                  'assets/images/logo.png',
                                ),
                              ),
                            )
                          : Container(),
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
