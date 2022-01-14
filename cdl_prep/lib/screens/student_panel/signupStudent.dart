import 'package:cdl_prep/api/api.dart';
import 'package:cdl_prep/colour_scheme.dart';
import 'package:cdl_prep/models/dataModels.dart';
import 'package:cdl_prep/screens/verifyOTP.dart';
import 'package:dropdown_below/dropdown_below.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class StudentSignup extends StatefulWidget {
  StudentSignup({Key? key}) : super(key: key);

  @override
  _StudentSignupState createState() => _StudentSignupState();
}

class _StudentSignupState extends State<StudentSignup> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  var selectedState;

  Future<List<CdlState>> stateList() => WebApi().getStates();

  List<DropdownMenuItem<int>> buildItems(List<CdlState> list) {
    List<DropdownMenuItem<int>> items = [];

    for (var i = 1; i < list.length; i++) {
      items.add(
        DropdownMenuItem(
          value: list[i].stateid,
          child: Text("${list[i].state}, ${list[i].country}"),
        ),
      );
    }

    return items;
  }

  TextFormField dialogTextField(
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
        child: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) currentFocus.unfocus();
          },
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
                        Center(
                          child: Text(
                            "Signup as Student",
                            textScaleFactor: 1.5,
                            style: TextStyle(color: Colors.blue[900]),
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
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        dialogTextField(_nameController, 50, false, true,
                            TextInputType.name, "Name *"),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01),
                        dialogTextField(_phoneController, 10, false, true,
                            TextInputType.phone, "Phone *"),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01),
                        Column(
                          children: [
                            FutureBuilder<List<CdlState>>(
                              future: stateList(),
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                if (snapshot.hasData)
                                  return DropdownButton(
                                    itemHeight: 50,
                                    isExpanded: true,
                                    underline: Container(),
                                    hint: Text(
                                      "Choose State *",
                                      style: TextStyle(
                                        color: kTheTexts,
                                        fontFamily: 'Amazon_Ember',
                                      ),
                                    ),
                                    style: TextStyle(
                                      color: kTheTexts,
                                      fontFamily: 'Amazon_Ember',
                                    ),
                                    icon: Icon(
                                      Icons.arrow_drop_down_rounded,
                                      color: kTheTexts,
                                      size: 28.0,
                                    ),
                                    items: buildItems(snapshot.data),
                                    value: selectedState,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedState = value;
                                      });
                                    },
                                  );
                                /*return DropdownBelow<int?>(
                                    boxHeight: 50,
                                    boxWidth:
                                        MediaQuery.of(context).size.width -
                                            15.0,
                                    itemWidth:
                                        MediaQuery.of(context).size.width * 0.7,
                                    hint: Text("Choose State *"),
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
                                    items: buildItems(snapshot.data),
                                    value: selectedState,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedState = value;
                                      });
                                    },
                                  );*/
                                else
                                  return Center(
                                    child: Container(
                                      margin: EdgeInsets.all(5.0),
                                      height: 30,
                                      width: 30,
                                      child: CircularProgressIndicator(
                                          color: kTheTexts),
                                    ),
                                  );
                              },
                            ),
                            Divider(
                              color: kTheTexts,
                              thickness: 1,
                            ),
                          ],
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01),
                        dialogTextField(_passwordController, 20, true, false,
                            TextInputType.visiblePassword, "Password *"),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03),
                        GestureDetector(
                          onTap: () async {
                            if (_nameController.text.isEmpty ||
                                _phoneController.text.isEmpty ||
                                _passwordController.text.isEmpty ||
                                int.parse(selectedState.toString()) <= 0 ||
                                selectedState == null ||
                                _phoneController.text.length != 10)
                              Fluttertoast.showToast(
                                msg: "Please fill-up all the fields",
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor: kTheTexts,
                                textColor: Colors.white,
                              );
                            else {
                              Overlay.of(context)!.insert(overlayEntry);

                              bool status = await WebApi()
                                  .checkPhone(_phoneController.text);

                              overlayEntry.remove();

                              (status)
                                  ? Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (context) => VerifyOTP(
                                          name: _nameController.text,
                                          password: _passwordController.text,
                                          phone: _phoneController.text,
                                          stateId: selectedState.toString(),
                                          toResume: "0",
                                          address: "null",
                                          city: "null",
                                          country: "null",
                                          schooltimefrom: "null",
                                          schooltimeto: "null",
                                          slottime: "null",
                                          state: "null",
                                        ),
                                      ),
                                    )
                                  : Fluttertoast.showToast(
                                      msg: "Phone already registered!",
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
                                "Submit",
                                textScaleFactor: 1.2,
                                style: TextStyle(
                                  color: kTheTexts,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Text(
                                "Already have account ?",
                                textScaleFactor: 0.9,
                                style: TextStyle(
                                  color: kTheTexts,
                                ),
                              ),
                            ),
                            Flexible(
                              child: TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: Text(
                                  "Login",
                                  textScaleFactor: 0.9,
                                  style: TextStyle(
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
