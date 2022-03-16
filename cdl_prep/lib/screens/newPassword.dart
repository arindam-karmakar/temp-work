import 'package:cdl_prep/api/api.dart';
import 'package:cdl_prep/colour_scheme.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NewPassword extends StatefulWidget {
  final String phone;
  NewPassword({Key? key, required this.phone}) : super(key: key);

  @override
  _NewPasswordState createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
  TextEditingController newPassword = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  WebApi webApi = WebApi();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
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
                        "Set Password",
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
                flex: 11,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue.shade900,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  margin: EdgeInsets.fromLTRB(
                      20.0,
                      20.0,
                      20.0,
                      (MediaQuery.of(context).viewInsets.bottom == 0)
                          ? 250.0
                          : 80.0),
                  padding:
                      EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        TextFormField(
                          controller: newPassword,
                          cursorColor: Colors.white,
                          cursorRadius: Radius.circular(30.0),
                          maxLines: 1,
                          maxLength: 20,
                          obscureText: true,
                          keyboardType: TextInputType.visiblePassword,
                          style: TextStyle(color: Colors.white),
                          enableInteractiveSelection: false,
                          decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            labelText: "New Password",
                            labelStyle: TextStyle(color: Colors.white),
                            counterText: "",
                          ),
                          validator: (input) {},
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                        TextFormField(
                          controller: confirmPassword,
                          cursorColor: Colors.white,
                          cursorRadius: Radius.circular(30.0),
                          maxLines: 1,
                          maxLength: 20,
                          obscureText: false,
                          keyboardType: TextInputType.visiblePassword,
                          style: TextStyle(color: Colors.white),
                          enableInteractiveSelection: false,
                          decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            labelText: "Confirm new password",
                            labelStyle: TextStyle(color: Colors.white),
                            counterText: "",
                          ),
                          validator: (input) {},
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05),
                        GestureDetector(
                          onTap: () async {
                            if ((newPassword.text == confirmPassword.text) &&
                                newPassword.text != "") {
                              String temp = await webApi.changePassword(
                                  widget.phone, newPassword.text);

                              if (temp == 'SUCCESS') {
                                Fluttertoast.showToast(
                                  msg: "Password reset successful!",
                                  gravity: ToastGravity.BOTTOM,
                                  backgroundColor: kTheTexts,
                                  textColor: Colors.white,
                                );

                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              } else {
                                Fluttertoast.showToast(
                                  msg: "Something went wrong",
                                  gravity: ToastGravity.BOTTOM,
                                  backgroundColor: kTheTexts,
                                  textColor: Colors.white,
                                );

                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              }
                            } else if (newPassword.text.isEmpty ||
                                confirmPassword.text.isEmpty) {
                              Fluttertoast.showToast(
                                msg: "Please enter password",
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor: kTheTexts,
                                textColor: Colors.white,
                              );
                            } else {
                              Fluttertoast.showToast(
                                msg: "Passwords don't match",
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor: kTheTexts,
                                textColor: Colors.white,
                              );
                            }
                          },
                          child: Container(
                            height: 50.0,
                            width: 150.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                              color: Colors.white,
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
                      ],
                    ),
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
