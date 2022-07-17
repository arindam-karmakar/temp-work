import 'package:eldtprep/api/api.dart';
import 'package:eldtprep/colour_scheme.dart';
import 'package:eldtprep/models/dataModels.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class ResetPassword extends StatefulWidget {
  ResetPassword({Key? key}) : super(key: key);

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  WebApi webApi = new WebApi();
  FToast fluttertoast = new FToast();
  String receivedOTP = "0000";
  String enteredOTP = "0000";

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
                        "Reset Password",
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
                  height: double.maxFinite,
                  width: double.maxFinite,
                  color: Colors.transparent,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 30.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: kEldtButton,
                            borderRadius: BorderRadius.circular(15.0),
                            border: Border.all(color: kTheTexts),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 20.0),
                          child: Column(
                            children: [
                              TextFormField(
                                controller: phoneController,
                                cursorColor: kTheTexts,
                                cursorRadius: Radius.circular(30.0),
                                maxLines: 1,
                                maxLength: 10,
                                obscureText: false,
                                keyboardType: TextInputType.phone,
                                style: TextStyle(color: kTheTexts),
                                enableInteractiveSelection: true,
                                decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: kTheTexts),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: kTheTexts),
                                  ),
                                  labelText: "Phone *",
                                  labelStyle: TextStyle(color: kTheTexts),
                                  counterText: "",
                                ),
                                validator: (input) {},
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () async {
                                      if (phoneController.text.length == 10) {
                                        String temp =
                                            await webApi.getOtpByPhone(
                                                phoneController.text);
                                        Fluttertoast.showToast(
                                          msg: "OTP sent",
                                          gravity: ToastGravity.BOTTOM,
                                          backgroundColor: kTheTexts,
                                          textColor: Colors.white,
                                        );

                                        setState(() {
                                          receivedOTP = temp;
                                        });
                                      } else {
                                        Fluttertoast.showToast(
                                          msg: "Enter a valid phone number",
                                          gravity: ToastGravity.BOTTOM,
                                          backgroundColor: kTheTexts,
                                          textColor: Colors.white,
                                        );
                                      }
                                    },
                                    child: Text(
                                      "Send OTP",
                                      style: TextStyle(
                                        color: kTheTexts,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05),
                        Text(
                          "Enter the verification code sent to your phone number",
                          textScaleFactor: 1.2,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: kTheTexts,
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05),
                        PinCodeTextField(
                          controller: otpController,
                          appContext: context,
                          length: 4,
                          enablePinAutofill: true,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: false,
                          useHapticFeedback: true,
                          cursorColor: kTheTexts,
                          textStyle: TextStyle(color: kTheTexts),
                          enableActiveFill: true,
                          pinTheme: PinTheme(
                            shape: PinCodeFieldShape.box,
                            fieldHeight: 50.0,
                            fieldWidth: 50.0,
                            borderRadius: BorderRadius.circular(5.0),
                            activeColor: kEldtButton.withOpacity(0.8),
                            selectedColor: kEldtButton.withOpacity(0.8),
                            disabledColor: kEldtButton.withOpacity(0.8),
                            inactiveColor: kEldtButton.withOpacity(0.8),
                            activeFillColor: kEldtButton,
                            errorBorderColor: kEldtButton.withOpacity(0.8),
                            inactiveFillColor: kEldtButton,
                            selectedFillColor: kEldtButton,
                          ),
                          onChanged: (input) {},
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05),
                        GestureDetector(
                          onTap: () {
                            if (otpController.text == receivedOTP) {
                              Fluttertoast.showToast(
                                msg: "OTP verified!",
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor: kTheTexts,
                                textColor: Colors.white,
                              );
                              Navigator.of(context).pushNamed('/setNewPassword',
                                  arguments: ScreenArguments(
                                      phoneController.text, "phone"));
                            } else {
                              Fluttertoast.showToast(
                                msg: "Enter the correct otp",
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
                              borderRadius: BorderRadius.circular(13.0),
                              color: kEldtButton,
                            ),
                            child: Center(
                              child: Text(
                                "Verify",
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
