import 'package:eldtprep/api/api.dart';
import 'package:eldtprep/api/userPrefs.dart';
import 'package:eldtprep/colour_scheme.dart';
import 'package:eldtprep/models/dataModels.dart';
import 'package:eldtprep/models/userModel.dart';
import 'package:eldtprep/coreModules.dart';
import 'package:eldtprep/screens/verifyOTP.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';

class EditProfile extends StatefulWidget {
  final CdlSchool school;
  EditProfile({Key? key, required this.school}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _stateController = TextEditingController();
  TextEditingController _countryController = TextEditingController();

  bool predictionActive = false;
  bool timeActive = false;
  bool showCityStateCountry = false;
  List predictions = [];
  List items = [];
  List<String> availableSlots = ['15', '30', '45', '60'];
  var selectedSlot;
  DateTime _from = DateTime.now();
  DateTime _to = DateTime.now();

  TextFormField dialogTextField(
    TextEditingController currentController,
    int maxLength,
    bool obscureText,
    bool enableInteractiveSelection,
    bool readOnly,
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
      readOnly: readOnly,
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
  void initState() {
    super.initState();
    _nameController.text = widget.school.name;
    _phoneController.text = widget.school.phone;
    _addressController.text =
        widget.school.address.replaceAll(RegExp(r'%2C'), ',');
    _cityController.text = widget.school.city;
    _stateController.text = widget.school.state;
    _countryController.text = widget.school.country;
    selectedSlot = availableSlots.indexOf(widget.school.slotTime);
  }

  @override
  Widget build(BuildContext context) {
    LocationProvider _locationProvider =
        Provider.of<LocationProvider>(context, listen: false);

    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);

    CdlSchool currentSchool =
        Provider.of<CdlSchoolProvider>(context, listen: false).school;

    List<DropdownMenuItem<int>> buildItems() {
      List<DropdownMenuItem<int>> items = [];

      for (var i = 0; i < availableSlots.length; i++)
        items.add(
          DropdownMenuItem<int>(
            value: i,
            child: Text(
              availableSlots[i],
            ),
          ),
        );

      return items;
    }

    void splitAddress() {
      List<String> parts = _addressController.text.split(", ");
      setState(() {
        _addressController.text = "";
        for (var i = parts.length - 1; i >= 0; i--) {
          if (i == parts.length - 1)
            _countryController.text = parts[i];
          else if (i == parts.length - 2)
            _stateController.text = parts[i];
          else if (i == parts.length - 3)
            _cityController.text = parts[i];
          else {
            if (_addressController.text.isNotEmpty)
              _addressController.text =
                  "${parts[i]}, ${_addressController.text}";
            else
              _addressController.text = parts[i];
          }
        }
      });
    }

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

    return Column(
      children: [
        Center(
          child: Text(
            "*** Please verify ***",
            textAlign: TextAlign.center,
            textScaleFactor: 0.8,
            style: TextStyle(color: kTheTexts),
          ),
        ),
        Center(
          child: Text(
            "all the fields before submitting",
            textAlign: TextAlign.center,
            textScaleFactor: 0.8,
            style: TextStyle(color: kTheTexts),
          ),
        ),
        Center(
          child: Text(
            "(except phone number)",
            textAlign: TextAlign.center,
            textScaleFactor: 0.8,
            style: TextStyle(color: kTheTexts),
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        dialogTextField(_nameController, 50, false, true, false,
            TextInputType.name, "School Name *"),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        dialogTextField(_phoneController, 10, false, true, true,
            TextInputType.phone, "Phone *"),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        TextFormField(
          controller: _addressController,
          cursorColor: kTheTexts,
          cursorRadius: Radius.circular(30.0),
          maxLines: 1,
          keyboardType: TextInputType.streetAddress,
          style: TextStyle(color: kTheTexts),
          decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: kTheTexts),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: kTheTexts),
            ),
            labelText: "Full Address *",
            labelStyle: TextStyle(color: kTheTexts),
            counterText: "",
          ),
          onChanged: (input) async {
            setState(() {
              showCityStateCountry = false;
            });
            predictions = await _locationProvider.getLocations(input);
            setState(() {
              predictionActive = true;
              showCityStateCountry = false;
              _cityController.text =
                  _stateController.text = _countryController.text = "";
            });
          },
        ),
        (predictionActive)
            ? Consumer<LocationProvider>(
                builder: (context, data, _w) {
                  return Container(
                    width: double.maxFinite,
                    padding: EdgeInsets.symmetric(horizontal: 5.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01),
                        for (var i = 0; i < predictions.length; i++)
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 3.0),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _addressController.text =
                                      predictions[i]['description'].toString();
                                  splitAddress();
                                  predictionActive = false;
                                  showCityStateCountry = true;
                                });
                              },
                              child: Text(
                                "${predictions[i]['description']}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: TextStyle(color: kTheTexts),
                              ),
                            ),
                          ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01),
                        Image.asset(
                          'assets/images/powered_by_google_on_white.png',
                          width: MediaQuery.of(context).size.width * 0.35,
                        ),
                        Divider(
                          color: kTheTexts,
                          thickness: 1.0,
                        ),
                      ],
                    ),
                  );
                },
              )
            : Container(),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        (showCityStateCountry)
            ? Column(
                children: [
                  dialogTextField(_cityController, 100, false, false, true,
                      TextInputType.streetAddress, "City *"),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  dialogTextField(_stateController, 100, false, false, true,
                      TextInputType.streetAddress, "State *"),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  dialogTextField(_countryController, 100, false, false, true,
                      TextInputType.streetAddress, "Country *"),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                ],
              )
            : Container(),
        DropdownButton<int>(
          itemHeight: 50,
          isExpanded: true,
          underline: Container(),
          hint: Text(
            "Slot Time *",
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
          value: selectedSlot,
          items: buildItems(),
          onChanged: (value) {
            setState(() {
              selectedSlot = value as int;
            });
          },
        ),
        Divider(
          color: kTheTexts,
          thickness: 1,
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        GestureDetector(
          onTap: () {
            setState(() {
              timeActive = !timeActive;
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "School driving Time *",
                style: TextStyle(
                  color: kTheTexts,
                  fontFamily: 'Amazon_Ember',
                ),
              ),
              Icon(
                (timeActive)
                    ? Icons.arrow_drop_up_rounded
                    : Icons.arrow_drop_down_rounded,
                color: kTheTexts,
                size: 28.0,
              ),
            ],
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        (timeActive)
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Center(
                            child: Text(
                              "From: ",
                              style: TextStyle(
                                color: kTheTexts,
                                fontFamily: 'Amazon_Ember',
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: TimePickerWidget(
                            initDateTime: _from,
                            onChange: (time, index) {
                              setState(() {
                                _from = time;
                              });
                            },
                            dateFormat: 'HHhr:mmmin',
                            pickerTheme: DateTimePickerTheme(
                              backgroundColor: Colors.transparent,
                              itemTextStyle: TextStyle(
                                color: kTheTexts,
                                fontSize: 16,
                                fontFamily: 'Amazon_Ember',
                              ),
                              showTitle: false,
                              pickerHeight: 150,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Center(
                            child: Text(
                              "To: ",
                              style: TextStyle(
                                color: kTheTexts,
                                fontFamily: 'Amazon_Ember',
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: TimePickerWidget(
                            initDateTime: _to,
                            onChange: (time, index) {
                              setState(() {
                                _to = time;
                              });
                            },
                            dateFormat: 'HHhr:mmmin',
                            pickerTheme: DateTimePickerTheme(
                              backgroundColor: Colors.transparent,
                              itemTextStyle: TextStyle(
                                color: kTheTexts,
                                fontSize: 16,
                                fontFamily: 'Amazon_Ember',
                              ),
                              showTitle: false,
                              pickerHeight: 150,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  ],
                ),
              )
            : Container(),
        Divider(
          color: kTheTexts,
          thickness: 1,
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.03),
        GestureDetector(
          onTap: () async {
            if (_nameController.text.isEmpty ||
                _phoneController.text.isEmpty ||
                _addressController.text.isEmpty ||
                _from.toString() == _to.toString() ||
                selectedSlot == null ||
                _phoneController.text.length != 10)
              Fluttertoast.showToast(
                msg: "Please fill-up all the fields with accurate address",
                gravity: ToastGravity.BOTTOM,
                backgroundColor: kTheTexts,
                textColor: Colors.white,
              );
            else {
              Overlay.of(context)!.insert(
                overlayEntry,
              );

              Map<String, dynamic> updateStatus =
                  await authProvider.updateSchool(
                _nameController.text,
                _phoneController.text,
                _addressController.text,
                _cityController.text,
                _stateController.text,
                _countryController.text,
                availableSlots[selectedSlot],
                DateFormat('HH:mm', 'en_US').format(_from),
                DateFormat('HH:mm', 'en_US').format(_to),
                currentSchool.schoolId.toString(),
              );

              overlayEntry.remove();

              if (updateStatus['status']) {
                Provider.of<CdlSchoolProvider>(context, listen: false)
                    .setSchool(updateStatus['school']);

                Fluttertoast.showToast(
                  msg: "Profile update successful!",
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: kTheTexts,
                  textColor: Colors.white,
                );

                Navigator.of(context).pop();
                Navigator.of(context).pop();

                MyApp.restartApp(context);
              } else
                Fluttertoast.showToast(
                  msg: "Request unsuccessful, try again!",
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
      ],
    );
  }
}
