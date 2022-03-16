import 'package:cdl_prep/api/api.dart';
import 'package:cdl_prep/api/userPrefs.dart';
import 'package:cdl_prep/colour_scheme.dart';
import 'package:cdl_prep/models/userModel.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class VerifyOTP extends StatefulWidget {
  final String name;
  final String password;
  final String phone;
  final String stateId;
  final String toResume;
  final String address,
      city,
      state,
      country,
      slottime,
      schooltimefrom,
      schooltimeto;
  VerifyOTP({
    Key? key,
    required this.name,
    required this.password,
    required this.phone,
    required this.stateId,
    required this.toResume,
    required this.address,
    required this.city,
    required this.state,
    required this.country,
    required this.slottime,
    required this.schooltimefrom,
    required this.schooltimeto,
  }) : super(key: key);

  @override
  _VerifyOTPState createState() => _VerifyOTPState();
}

class _VerifyOTPState extends State<VerifyOTP> {
  TextEditingController otpController = TextEditingController();
  WebApi webApi = new WebApi();
  String receivedOTP = "dummyOTP";

  @override
  void initState() {
    super.initState();
    getOTP();
  }

  getOTP() async {
    receivedOTP = await webApi.getOtpByPhone(widget.phone);
    Fluttertoast.showToast(
      msg: "OTP sent",
      gravity: ToastGravity.BOTTOM,
      backgroundColor: kTheTexts,
      textColor: Colors.white,
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
      resizeToAvoidBottomInset: false,
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
                        "Verification code",
                        //widget.stateId,
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
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(),
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
                          enableActiveFill: true,
                          useHapticFeedback: true,
                          cursorColor: Colors.white,
                          textStyle: TextStyle(color: Colors.white),
                          pinTheme: PinTheme(
                            shape: PinCodeFieldShape.box,
                            fieldHeight: 50.0,
                            fieldWidth: 50.0,
                            borderRadius: BorderRadius.circular(5.0),
                            activeColor: kTheTexts.withOpacity(0.8),
                            selectedColor: kTheTexts.withOpacity(0.8),
                            disabledColor: kTheTexts.withOpacity(0.8),
                            inactiveColor: kTheTexts.withOpacity(0.8),
                            activeFillColor: Colors.blue.shade900,
                            errorBorderColor: kTheTexts.withOpacity(0.8),
                            inactiveFillColor: Colors.blue.shade900,
                            selectedFillColor: Colors.blue.shade900,
                          ),
                          onChanged: (input) {},
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05),
                        GestureDetector(
                          onTap: () async {
                            if (otpController.text == receivedOTP) {
                              if (int.parse(widget.toResume) == 0) {
                                Overlay.of(context)!.insert(
                                  overlayEntry,
                                );

                                CdlUser _cdlUser = await authProvider.signup(
                                  widget.name,
                                  widget.password,
                                  "1",
                                  widget.phone,
                                  widget.stateId,
                                );

                                overlayEntry.remove();

                                if (_cdlUser.name == "null" ||
                                    _cdlUser.name == "name") {
                                  Fluttertoast.showToast(
                                    msg: "Try again!",
                                    gravity: ToastGravity.BOTTOM,
                                    backgroundColor: kTheTexts,
                                    textColor: Colors.white,
                                  );
                                } else {
                                  Provider.of<CdlUserProvider>(context,
                                          listen: false)
                                      .setUser(_cdlUser);
                                  Fluttertoast.showToast(
                                    msg: "Signup successful",
                                    gravity: ToastGravity.BOTTOM,
                                    backgroundColor: kTheTexts,
                                    textColor: Colors.white,
                                  );

                                  Navigator.of(context).pop();
                                  Navigator.of(context).pushReplacementNamed(
                                      '/studentDashboard');
                                }
                              } else {
                                Overlay.of(context)!.insert(
                                  overlayEntry,
                                );

                                CdlSchool _cdlSchool =
                                    await authProvider.signupSchool(
                                  widget.name,
                                  widget.password,
                                  widget.phone,
                                  widget.address,
                                  widget.city,
                                  widget.state,
                                  widget.country,
                                  widget.slottime,
                                  widget.schooltimefrom,
                                  widget.schooltimeto,
                                );

                                overlayEntry.remove();

                                if (_cdlSchool.name == "null" ||
                                    _cdlSchool.name == "name") {
                                  Fluttertoast.showToast(
                                    msg: "Try again!",
                                    gravity: ToastGravity.BOTTOM,
                                    backgroundColor: kTheTexts,
                                    textColor: Colors.white,
                                  );
                                } else {
                                  Provider.of<CdlSchoolProvider>(context,
                                          listen: false)
                                      .setSchool(_cdlSchool);
                                  Fluttertoast.showToast(
                                    msg: "Signup successful",
                                    gravity: ToastGravity.BOTTOM,
                                    backgroundColor: kTheTexts,
                                    textColor: Colors.white,
                                  );

                                  Navigator.of(context).pop();
                                  Navigator.of(context)
                                      .pushReplacementNamed('/schoolDashboard');
                                }
                              }
                            } else
                              Fluttertoast.showToast(
                                msg: "Please enter valid otp",
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor: kTheTexts,
                                textColor: Colors.white,
                              );
                          },
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
