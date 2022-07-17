import 'package:eldtprep/api/api.dart';
import 'package:eldtprep/api/userPrefs.dart';
import 'package:eldtprep/colour_scheme.dart';
import 'package:eldtprep/models/dataModels.dart';
import 'package:eldtprep/models/userModel.dart';
import 'package:eldtprep/screens/school_panel/schoolDrawer.dart';
import 'package:eldtprep/screens/school_panel/studentDetails.dart';
import 'package:eldtprep/widgets/dashboardExtras.dart';
import 'package:eldtprep/widgets/studentCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EnrollStudent extends StatefulWidget {
  EnrollStudent({Key? key}) : super(key: key);

  @override
  _EnrollStudentState createState() => _EnrollStudentState();
}

class _EnrollStudentState extends State<EnrollStudent> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _stateController = TextEditingController();
  TextEditingController _countryController = TextEditingController();

  bool predictionActive = false;
  bool showCityStateCountry = false;
  List predictions = [];
  bool preTrip = false;
  bool skill = false;
  bool road = false;

  int lastSelected = 0;
  int lastStudent = 0;

  DateTime scheduleDateTime = DateTime.now();

  String imageName = "Upload Picture *";
  String testSchedule = "Test Schedule *";

  var selectedState;
  var paymentStatusOfEnroll;

  Future<List<CdlState>> stateList() => WebApi().getStates();
  WebApi webApi = WebApi();
  ImagePicker _picker = new ImagePicker();
  var _image;

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
  Widget build(BuildContext context) {
    CdlSchool cdlSchool = Provider.of<CdlSchoolProvider>(context).school;
    Future<List<CdlStudent>> getStudent() =>
        WebApi().getEnroll(cdlSchool.schoolId);

    LocationProvider _locationProvider =
        Provider.of<LocationProvider>(context, listen: false);

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

    enrollSuccess() {
      setState(() {
        _nameController.text = "";
        _phoneController.text = "";
        _addressController.text = "";
        _cityController.text = "";
        _stateController.text = "";
        _countryController.text = "";
        preTrip = false;
        skill = false;
        road = false;
        selectedState = null;
        paymentStatusOfEnroll = null;
        testSchedule = "Test Schedule *";
        scheduleDateTime = DateTime.now();
        imageName = "Upload Picture *";
        _image = null;
      });

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
                      flex: 3,
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Image.asset('assets/images/vippng 1.png'),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Center(
                        child: Text(
                          "Enroll Success",
                          textScaleFactor: 1.4,
                          style: TextStyle(
                            color: kTheTexts,
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: Center(
                        child: GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Container(
                            height: 40.0,
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
                                "OK",
                                textScaleFactor: 1.2,
                                style: TextStyle(
                                  color: kTheTexts,
                                ),
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
      key: _scaffoldKey,
      drawer: getDrawer(2),
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) currentFocus.unfocus();
        },
        child: Container(
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
                              flex: 2,
                              child: IconButton(
                                onPressed: () =>
                                    _scaffoldKey.currentState!.openDrawer(),
                                icon: ImageIcon(
                                  AssetImage('assets/images/drawerVector.png'),
                                  size: 18.0,
                                  color: Colors.blue[900],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Center(
                                child: Text(
                                  "Students",
                                  textScaleFactor: 1.5,
                                  style: TextStyle(color: Colors.blue[900]),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Flexible(
                                    child: IconButton(
                                      onPressed: () => Navigator.of(context)
                                          .pushNamed('/searchEnroll'),
                                      icon: Icon(Icons.search),
                                      color: Colors.blue[900],
                                    ),
                                  ),
                                  Flexible(
                                    child: IconButton(
                                      onPressed: () => Navigator.of(context)
                                          .pushNamed('/schoolNotification'),
                                      icon: Icon(
                                        Icons.notifications,
                                        color: Colors.blue[900],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
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
                  flex: 12,
                  child: DefaultTabController(
                    length: 2,
                    child: Container(
                      height: double.maxFinite,
                      width: double.maxFinite,
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      child: Column(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: TabBar(
                                    indicatorColor: Colors.blue,
                                    labelColor: Colors.blue,
                                    unselectedLabelColor: kTheTexts,
                                    labelStyle: TextStyle(
                                      fontSize: 18.0,
                                      fontFamily: 'Amazon_Ember',
                                    ),
                                    unselectedLabelStyle: TextStyle(
                                      fontSize: 18.0,
                                      fontFamily: 'Amazon_Ember',
                                    ),
                                    tabs: [
                                      Text("Enroll"),
                                      Text("Student List"),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Divider(
                                    thickness: 2,
                                    color: kTheDivider.withOpacity(0.3),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 10,
                            child: TabBarView(
                              children: [
                                SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.01),
                                      dialogTextField(
                                          _nameController,
                                          50,
                                          false,
                                          true,
                                          false,
                                          TextInputType.name,
                                          "Student Name *"),
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.01),
                                      dialogTextField(
                                          _phoneController,
                                          10,
                                          false,
                                          true,
                                          false,
                                          TextInputType.phone,
                                          "Phone *"),
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.01),
                                      TextFormField(
                                        controller: _addressController,
                                        cursorColor: kTheTexts,
                                        cursorRadius: Radius.circular(30.0),
                                        maxLines: 1,
                                        keyboardType:
                                            TextInputType.streetAddress,
                                        style: TextStyle(color: kTheTexts),
                                        decoration: InputDecoration(
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide:
                                                BorderSide(color: kTheTexts),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide:
                                                BorderSide(color: kTheTexts),
                                          ),
                                          labelText: "Full Address *",
                                          labelStyle:
                                              TextStyle(color: kTheTexts),
                                          counterText: "",
                                        ),
                                        onChanged: (input) async {
                                          predictions = await _locationProvider
                                              .getLocations(input);
                                          setState(() {
                                            predictionActive = true;
                                            /*showCityStateCountry = false;
                                            _cityController.text =
                                                _stateController.text =
                                                    _countryController.text =
                                                        "";*/
                                          });
                                        },
                                      ),
                                      (predictionActive)
                                          ? Consumer<LocationProvider>(
                                              builder: (context, data, _w) {
                                                return Container(
                                                  width: double.maxFinite,
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 5.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      SizedBox(
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.01),
                                                      for (var i = 0;
                                                          i <
                                                              predictions
                                                                  .length;
                                                          i++)
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical:
                                                                      3.0),
                                                          child:
                                                              GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                _addressController
                                                                    .text = predictions[
                                                                            i][
                                                                        'description']
                                                                    .toString();
                                                                splitAddress();
                                                                predictionActive =
                                                                    false;
                                                                showCityStateCountry =
                                                                    true;
                                                              });
                                                            },
                                                            child: Text(
                                                              "${predictions[i]['description']}",
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: TextStyle(
                                                                  color:
                                                                      kTheTexts),
                                                            ),
                                                          ),
                                                        ),
                                                      SizedBox(
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.01),
                                                      Image.asset(
                                                        'assets/images/powered_by_google_on_white.png',
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.35,
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
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.01),
                                      (showCityStateCountry)
                                          ? Column(
                                              children: [
                                                dialogTextField(
                                                    _cityController,
                                                    100,
                                                    false,
                                                    false,
                                                    true,
                                                    TextInputType.streetAddress,
                                                    "City *"),
                                                SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.01),
                                                dialogTextField(
                                                    _stateController,
                                                    100,
                                                    false,
                                                    false,
                                                    true,
                                                    TextInputType.streetAddress,
                                                    "State *"),
                                                SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.01),
                                                dialogTextField(
                                                    _countryController,
                                                    100,
                                                    false,
                                                    false,
                                                    true,
                                                    TextInputType.streetAddress,
                                                    "Country *"),
                                                SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.01),
                                              ],
                                            )
                                          : Container(),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              "Pre-Trip Ready *",
                                              style:
                                                  TextStyle(color: kTheTexts),
                                            ),
                                          ),
                                          Expanded(
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: RadioListTile<bool>(
                                                    contentPadding:
                                                        EdgeInsets.zero,
                                                    value: true,
                                                    groupValue: preTrip,
                                                    title: Text(
                                                      "Yes",
                                                      style: TextStyle(
                                                          color: kTheTexts),
                                                    ),
                                                    activeColor: kTheTexts,
                                                    onChanged: (currentValue) {
                                                      setState(() {
                                                        preTrip = currentValue
                                                            as bool;
                                                      });
                                                    },
                                                  ),
                                                ),
                                                Expanded(
                                                  child: RadioListTile<bool>(
                                                    contentPadding:
                                                        EdgeInsets.zero,
                                                    value: false,
                                                    groupValue: preTrip,
                                                    title: Text(
                                                      "No",
                                                      style: TextStyle(
                                                          color: kTheTexts),
                                                    ),
                                                    activeColor: kTheTexts,
                                                    onChanged: (currentValue) {
                                                      setState(() {
                                                        preTrip = currentValue
                                                            as bool;
                                                        skill = road = false;
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Divider(
                                        color: kTheTexts,
                                        thickness: 1.0,
                                      ),
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.01),
                                      (preTrip)
                                          ? Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        "Skill Ready *",
                                                        style: TextStyle(
                                                            color: kTheTexts),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child:
                                                                RadioListTile<
                                                                    bool>(
                                                              contentPadding:
                                                                  EdgeInsets
                                                                      .zero,
                                                              value: true,
                                                              groupValue: skill,
                                                              title: Text(
                                                                "Yes",
                                                                style: TextStyle(
                                                                    color:
                                                                        kTheTexts),
                                                              ),
                                                              activeColor:
                                                                  kTheTexts,
                                                              onChanged:
                                                                  (currentValue) {
                                                                setState(() {
                                                                  skill =
                                                                      currentValue
                                                                          as bool;
                                                                });
                                                              },
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child:
                                                                RadioListTile<
                                                                    bool>(
                                                              contentPadding:
                                                                  EdgeInsets
                                                                      .zero,
                                                              value: false,
                                                              groupValue: skill,
                                                              title: Text(
                                                                "No",
                                                                style: TextStyle(
                                                                    color:
                                                                        kTheTexts),
                                                              ),
                                                              activeColor:
                                                                  kTheTexts,
                                                              onChanged:
                                                                  (currentValue) {
                                                                setState(() {
                                                                  skill =
                                                                      currentValue
                                                                          as bool;
                                                                  road = false;
                                                                });
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Divider(
                                                  color: kTheTexts,
                                                  thickness: 1.0,
                                                ),
                                                SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.01),
                                              ],
                                            )
                                          : Container(),
                                      (skill)
                                          ? Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        "Road Ready *",
                                                        style: TextStyle(
                                                            color: kTheTexts),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child:
                                                                RadioListTile<
                                                                    bool>(
                                                              contentPadding:
                                                                  EdgeInsets
                                                                      .zero,
                                                              value: true,
                                                              groupValue: road,
                                                              title: Text(
                                                                "Yes",
                                                                style: TextStyle(
                                                                    color:
                                                                        kTheTexts),
                                                              ),
                                                              activeColor:
                                                                  kTheTexts,
                                                              onChanged:
                                                                  (currentValue) {
                                                                setState(() {
                                                                  road =
                                                                      currentValue
                                                                          as bool;
                                                                });
                                                              },
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child:
                                                                RadioListTile<
                                                                    bool>(
                                                              contentPadding:
                                                                  EdgeInsets
                                                                      .zero,
                                                              value: false,
                                                              groupValue: road,
                                                              title: Text(
                                                                "No",
                                                                style: TextStyle(
                                                                    color:
                                                                        kTheTexts),
                                                              ),
                                                              activeColor:
                                                                  kTheTexts,
                                                              onChanged:
                                                                  (currentValue) {
                                                                setState(() {
                                                                  road =
                                                                      currentValue
                                                                          as bool;
                                                                });
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Divider(
                                                  color: kTheTexts,
                                                  thickness: 1.0,
                                                ),
                                                SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.01),
                                              ],
                                            )
                                          : Container(),
                                      FutureBuilder<List<CdlState>>(
                                        future: stateList(),
                                        builder: (BuildContext context,
                                            AsyncSnapshot snapshot) {
                                          if (snapshot.hasData)
                                            return DropdownButton<int>(
                                              itemHeight: 50,
                                              isExpanded: true,
                                              underline: Container(),
                                              hint: Text(
                                                "CDL State *",
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
                                          else
                                            return Center(
                                              child: Container(
                                                margin: EdgeInsets.all(5.0),
                                                height: 30,
                                                width: 30,
                                                child:
                                                    CircularProgressIndicator(
                                                        color: kTheTexts),
                                              ),
                                            );
                                        },
                                      ),
                                      Divider(
                                        color: kTheTexts,
                                        thickness: 1,
                                      ),
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.03),
                                      GestureDetector(
                                        onTap: () async {
                                          var temp = await _picker.pickImage(
                                            source: ImageSource.gallery,
                                          );

                                          setState(() {
                                            _image = temp;
                                            imageName = temp!.name;
                                          });
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                              child: Text(
                                                imageName,
                                                style:
                                                    TextStyle(color: kTheTexts),
                                              ),
                                            ),
                                            Flexible(
                                              child: Icon(
                                                Icons.photo_outlined,
                                                color: kTheTexts,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Divider(
                                        color: kTheTexts,
                                        thickness: 1,
                                        height: 32.0,
                                      ),
                                      DropdownButton<String>(
                                        itemHeight: 50,
                                        isExpanded: true,
                                        underline: Container(),
                                        hint: Text(
                                          "Payment Status *",
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
                                        items: ['Paid', 'Pending']
                                            .map<DropdownMenuItem<String>>(
                                              (e) => DropdownMenuItem(
                                                value: e,
                                                child: Text(e),
                                              ),
                                            )
                                            .toList(),
                                        value: paymentStatusOfEnroll,
                                        onChanged: (value) {
                                          setState(() {
                                            paymentStatusOfEnroll = value;
                                          });
                                        },
                                      ),
                                      Divider(
                                        color: kTheTexts,
                                        thickness: 1,
                                      ),
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.03),
                                      GestureDetector(
                                        onTap: () async {
                                          DatePicker.showDatePicker(
                                            context,
                                            dateFormat:
                                                'yyyy-MMM-dd,HHhr:mmmin',
                                            //minDateTime: DateTime.now(),
                                            initialDateTime: scheduleDateTime,
                                            onConfirm: (dateTime, ind) {
                                              setState(() {
                                                scheduleDateTime = dateTime;
                                                testSchedule =
                                                    dateTime.toString();
                                              });
                                            },
                                            pickerMode:
                                                DateTimePickerMode.datetime,
                                            pickerTheme: DateTimePickerTheme(
                                              backgroundColor: kPrimary,
                                              itemTextStyle: TextStyle(
                                                color: kTheTexts,
                                                fontSize: 16,
                                                fontFamily: 'Amazon_Ember',
                                              ),
                                              cancelTextStyle: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 16,
                                                fontFamily: 'Amazon_Ember',
                                              ),
                                              confirmTextStyle: TextStyle(
                                                color: kTheTexts,
                                                fontSize: 16,
                                                fontFamily: 'Amazon_Ember',
                                              ),
                                            ),
                                          );
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                              child: Text(
                                                testSchedule,
                                                style:
                                                    TextStyle(color: kTheTexts),
                                              ),
                                            ),
                                            Flexible(
                                              child: Icon(
                                                Icons.calendar_today_outlined,
                                                size: 22.0,
                                                color: kTheTexts,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Divider(
                                        color: kTheTexts,
                                        thickness: 1,
                                        height: 32.0,
                                      ),
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.02),
                                      GestureDetector(
                                        onTap: () async {
                                          if (_nameController.text.isEmpty ||
                                              _phoneController.text.isEmpty ||
                                              _phoneController.text.length !=
                                                  10 ||
                                              _addressController.text.isEmpty ||
                                              _cityController.text.isEmpty ||
                                              _stateController.text.isEmpty ||
                                              _countryController.text.isEmpty ||
                                              selectedState == null ||
                                              paymentStatusOfEnroll == null ||
                                              testSchedule ==
                                                  "Test Schedule *" ||
                                              scheduleDateTime ==
                                                  DateTime.now() ||
                                              _image == null)
                                            Fluttertoast.showToast(
                                              msg:
                                                  "Please fill-up all the fields with accurate address",
                                              gravity: ToastGravity.BOTTOM,
                                              backgroundColor: kTheTexts,
                                              textColor: Colors.white,
                                            );
                                          else {
                                            Overlay.of(context)!
                                                .insert(overlayEntry);

                                            String report =
                                                await webApi.addEnroll(
                                              _nameController.text,
                                              _phoneController.text,
                                              _addressController.text,
                                              _cityController.text,
                                              _stateController.text,
                                              _countryController.text,
                                              (preTrip) ? "Yes" : "No",
                                              (skill) ? "Yes" : "No",
                                              (road) ? "Yes" : "No",
                                              selectedState.toString(),
                                              paymentStatusOfEnroll.toString(),
                                              "Yes",
                                              DateFormat('yyyy-MM-dd HH:mm',
                                                      'en_US')
                                                  .format(scheduleDateTime),
                                              cdlSchool.schoolId.toString(),
                                              _image.path,
                                            );

                                            overlayEntry.remove();

                                            (report == 'SUCCESS')
                                                ? enrollSuccess()
                                                : Fluttertoast.showToast(
                                                    msg:
                                                        "Enroll Unsuccessful, try again!",
                                                    gravity:
                                                        ToastGravity.BOTTOM,
                                                    backgroundColor: kTheTexts,
                                                    textColor: Colors.white,
                                                  );
                                          }
                                        },
                                        child: Container(
                                          height: 50.0,
                                          width: 150.0,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(50.0),
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
                                          height: MediaQuery.of(context)
                                              .viewInsets
                                              .bottom),
                                    ],
                                  ),
                                ),
                                FutureBuilder<List<CdlStudent>>(
                                  future: getStudent(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot snapshot) {
                                    if (snapshot.hasData)
                                      return ListView.builder(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10.0),
                                        itemCount: snapshot.data.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                lastStudent = index + 1;
                                              });

                                              Future.delayed(
                                                Duration(milliseconds: 30),
                                                () {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          StudentDetails(
                                                        currentStudent: snapshot
                                                            .data[index],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            child: (lastStudent == index + 1)
                                                ? PressedCard(
                                                    name: snapshot
                                                        .data[index].name,
                                                    phone: snapshot
                                                        .data[index].phone,
                                                    image: snapshot
                                                        .data[index].image,
                                                  )
                                                : UnpressedCard(
                                                    name: snapshot
                                                        .data[index].name,
                                                    phone: snapshot
                                                        .data[index].phone,
                                                    image: snapshot
                                                        .data[index].image,
                                                  ),
                                          );
                                        },
                                      );
                                    else
                                      return Center(
                                        child: Container(
                                          height: 40.0,
                                          width: 40.0,
                                          child: CircularProgressIndicator(
                                              color: kTheTexts),
                                        ),
                                      );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    height: double.maxFinite,
                    width: double.maxFinite,
                    color: Colors.transparent,
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Flexible(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                lastSelected = 9;
                              });
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 7,
                                  child: (lastSelected == 9)
                                      ? IconPressedButton(
                                          iconPath: "assets/images/11 1.png")
                                      : IconUnpressedButton(
                                          iconPath: 'assets/images/11 1.png'),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    "Enroll Student",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: kTheTexts),
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
                                lastSelected = 10;
                              });

                              Future.delayed(
                                Duration(milliseconds: 30),
                                () {
                                  Navigator.of(context)
                                      .pushReplacementNamed('/payments');
                                },
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 7,
                                  child: Padding(
                                    padding: EdgeInsets.all(2.0),
                                    child: (lastSelected == 10)
                                        ? IconPressedButton(
                                            iconPath: "assets/images/10 2.png")
                                        : IconUnpressedButton(
                                            iconPath: 'assets/images/10 2.png'),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    "Payment Status",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: kTheTexts),
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
                                lastSelected = 11;
                              });

                              Future.delayed(
                                Duration(milliseconds: 30),
                                () {
                                  Navigator.of(context)
                                      .pushReplacementNamed('/slots');
                                },
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 7,
                                  child: (lastSelected == 11)
                                      ? IconPressedButton(
                                          iconPath:
                                              "assets/images/4-icon 1.png")
                                      : IconUnpressedButton(
                                          iconPath:
                                              'assets/images/4-icon 1.png'),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    "Slots",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: kTheTexts),
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
                                lastSelected = 12;
                              });

                              Future.delayed(
                                Duration(milliseconds: 30),
                                () {
                                  Navigator.of(context)
                                      .pushReplacementNamed('/driveTime');
                                },
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 7,
                                  child: (lastSelected == 12)
                                      ? IconPressedButton(
                                          iconPath: "assets/images/4 1.png")
                                      : IconUnpressedButton(
                                          iconPath: 'assets/images/4 1.png'),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    "Drive Time",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: kTheTexts),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
