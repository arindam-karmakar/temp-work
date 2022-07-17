import 'package:eldtprep/api/api.dart';
import 'package:eldtprep/api/userPrefs.dart';
import 'package:eldtprep/colour_scheme.dart';
import 'package:eldtprep/models/userModel.dart';
import 'package:eldtprep/screens/school_panel/allStudents.dart';
import 'package:eldtprep/screens/school_panel/schoolDrawer.dart';
import 'package:eldtprep/widgets/dashboardExtras.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class InitSlot extends StatelessWidget {
  const InitSlot({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CdlSchool school = Provider.of<CdlSchoolProvider>(context).school;

    return Consumer<CdlSchoolProvider>(
      builder: (context, data, w) {
        return Slots(
          school: school,
          enrollId: "null",
          enrollPhone: "null",
        );
      },
    );
  }
}

class Slots extends StatefulWidget {
  final CdlSchool school;
  final String enrollId, enrollPhone;
  Slots({
    Key? key,
    required this.school,
    required this.enrollId,
    required this.enrollPhone,
  }) : super(key: key);

  @override
  _SlotsState createState() => _SlotsState();
}

class _SlotsState extends State<Slots> {
  WebApi webApi = new WebApi();

  DateTime currentDateTime = DateTime.now();
  int lastSelected = 0;
  int selectedSlot = -1;
  var selectedTime;

  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    Future<List<Map<String, dynamic>>> mySlot() =>
        WebApi().createSlots(widget.school, currentDateTime);

    generateColour(int index, bool available) {
      if (available) {
        if (index == selectedSlot)
          return Colors.white;
        else
          return kTheTexts;
      } else
        return Colors.grey[500];
    }

    scheduleSuccess() {
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
                          "Schedule Successfully",
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
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          },
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
      key: _scaffoldKey,
      drawer: getDrawer(2),
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
                            flex: 2,
                            child: Center(
                              child: Text(
                                "Slots",
                                textScaleFactor: 1.5,
                                style: TextStyle(color: Colors.blue[900]),
                              ),
                            ),
                          ),
                          Expanded(
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
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                        child: GestureDetector(
                          onTap: () {
                            DatePicker.showDatePicker(
                              context,
                              dateFormat: 'yyyy-MMM-dd',
                              initialDateTime: currentDateTime,
                              onConfirm: (dateTime, ind) {
                                setState(() {
                                  currentDateTime = dateTime;
                                  selectedSlot = -1;
                                });
                              },
                              pickerMode: DateTimePickerMode.datetime,
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                DateFormat('dd-MM-yyyy', 'en_US')
                                    .format(currentDateTime),
                                textScaleFactor: 1.2,
                                style: TextStyle(color: kTheTexts),
                              ),
                              Icon(
                                Icons.calendar_today_outlined,
                                color: kTheTexts,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Flexible(
                        child: Divider(
                          color: kTheDivider.withOpacity(0.3),
                          thickness: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 9,
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: mySlot(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      return StatefulBuilder(
                        builder: (BuildContext context, setState) {
                          int selectedButton = selectedSlot;

                          return ListView.builder(
                            itemCount: snapshot.data.length,
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  if (snapshot.data[index]['available']) {
                                    selectedSlot = index;
                                    selectedTime = snapshot.data[index];

                                    setState(() {
                                      selectedButton = index;
                                    });
                                  } else
                                    Fluttertoast.showToast(
                                      msg: "Slot already booked!",
                                      gravity: ToastGravity.BOTTOM,
                                      backgroundColor: kTheTexts,
                                      textColor: Colors.white,
                                    );
                                },
                                child: Container(
                                  height: (index == selectedButton)
                                      ? MediaQuery.of(context).size.height *
                                          0.07
                                      : MediaQuery.of(context).size.height *
                                          0.05,
                                  width: double.maxFinite,
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 15.0),
                                  decoration: BoxDecoration(
                                    color: (selectedButton == index)
                                        ? kActiveSlot
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          DateFormat('dd-MM-yyyy', 'en_US')
                                              .format(snapshot.data[index]
                                                  ['start']),
                                          textScaleFactor: 1.1,
                                          style: TextStyle(
                                              color: generateColour(
                                                  index,
                                                  snapshot.data[index]
                                                      ['available'])),
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                          DateFormat('HH:mm', 'en_US').format(
                                                  snapshot.data[index]
                                                      ['start']) +
                                              " - " +
                                              DateFormat('HH:mm', 'en_US')
                                                  .format(snapshot.data[index]
                                                      ['end']),
                                          textScaleFactor: 1.1,
                                          style: TextStyle(
                                              color: generateColour(
                                                  index,
                                                  snapshot.data[index]
                                                      ['available'])),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    } else
                      return Center(
                        child: Container(
                          height: 40.0,
                          width: 40.0,
                          child: CircularProgressIndicator(color: kTheTexts),
                        ),
                      );
                  },
                ),
              ),
              Expanded(
                flex: 2,
                child: Center(
                  child: GestureDetector(
                    onTap: () async {
                      if (selectedSlot != -1 && selectedTime != null) {
                        if (widget.enrollId == "null") {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      StudentListPage(data: selectedTime)));
                        } else {
                          Overlay.of(context)!.insert(overlayEntry);

                          bool report = await webApi.setSlot(
                            DateFormat('yyyy-MM-dd HH:mm:ss', 'en_US')
                                .format(selectedTime['end']),
                            DateFormat('yyyy-MM-dd HH:mm:ss', 'en_US')
                                .format(selectedTime['start']),
                            widget.school.schoolId.toString(),
                            widget.enrollId,
                            widget.enrollPhone,
                            widget.school.name,
                          );

                          overlayEntry.remove();

                          if (report) {
                            scheduleSuccess();
                          } else {
                            Navigator.of(context).pop();
                            Fluttertoast.showToast(
                              msg: "Schedule Unsuccessful!",
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: kTheTexts,
                              textColor: Colors.white,
                            );
                          }
                        }
                      } else
                        Fluttertoast.showToast(
                          msg: "Please select a slot",
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: kTheTexts,
                          textColor: Colors.white,
                        );
                    },
                    child: Container(
                      width: 150.0,
                      margin: EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.0),
                        gradient: LinearGradient(
                          colors: [kOrangeOne, kOrangeTwo.withOpacity(0.05)],
                        ),
                      ),
                      child: Center(
                        child: Text(
                          (widget.enrollId != "null") ? "Submit" : "Proceed",
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

                            Future.delayed(
                              Duration(milliseconds: 30),
                              () {
                                Navigator.of(context)
                                    .pushReplacementNamed('/enrollStudent');
                              },
                            );
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
                                  padding: EdgeInsets.all(3.0),
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
                                  "Payments",
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
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 7,
                                child: (lastSelected == 11)
                                    ? IconPressedButton(
                                        iconPath: "assets/images/4-icon 1.png")
                                    : IconUnpressedButton(
                                        iconPath: 'assets/images/4-icon 1.png'),
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
    );
  }
}

class InitSlotForSchedule extends StatelessWidget {
  final String enrollId, enrollPhone;
  const InitSlotForSchedule({
    Key? key,
    required this.enrollId,
    required this.enrollPhone,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CdlSchool school = Provider.of<CdlSchoolProvider>(context).school;

    return Consumer<CdlSchoolProvider>(
      builder: (context, data, w) {
        return Slots(
          school: school,
          enrollId: enrollId,
          enrollPhone: enrollPhone,
        );
      },
    );
  }
}
