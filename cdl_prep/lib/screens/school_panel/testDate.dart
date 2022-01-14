import 'package:cdl_prep/api/api.dart';
import 'package:cdl_prep/api/userPrefs.dart';
import 'package:cdl_prep/colour_scheme.dart';
import 'package:cdl_prep/models/dataModels.dart';
import 'package:cdl_prep/models/userModel.dart';
import 'package:cdl_prep/screens/school_panel/schoolDrawer.dart';
import 'package:cdl_prep/screens/school_panel/studentDetails.dart';
import 'package:cdl_prep/widgets/dashboardExtras.dart';
import 'package:cdl_prep/widgets/studentCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TestDate extends StatefulWidget {
  TestDate({Key? key}) : super(key: key);

  @override
  _TestDateState createState() => _TestDateState();
}

class _TestDateState extends State<TestDate> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int lastSelected = 0;
  int lastStudent = 0;

  DateTime initialDateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    CdlSchool cdlSchool = Provider.of<CdlSchoolProvider>(context).school;

    Future<List<CdlStudent>> getStudents() =>
        WebApi().getTestDate(cdlSchool.schoolId, initialDateTime);

    return Scaffold(
      key: _scaffoldKey,
      drawer: getDrawer(2),
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
                                "Test Date",
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
                              initialDateTime: initialDateTime,
                              onConfirm: (dateTime, ind) {
                                setState(() {
                                  initialDateTime = dateTime;
                                  lastStudent = 0;
                                });

                                Fluttertoast.showToast(
                                  msg: "Refreshing, please wait ...",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.BOTTOM,
                                  backgroundColor: kTheTexts,
                                  textColor: Colors.white,
                                );
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
                                    .format(initialDateTime),
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
                flex: 10,
                child: FutureBuilder<List<CdlStudent>>(
                  future: getStudents(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData)
                      return ListView.builder(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 15.0),
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
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
                                      builder: (context) => StudentDetails(
                                        currentStudent: snapshot.data[index],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            child: (lastStudent == index + 1)
                                ? PressedCardWithText(
                                    name: snapshot.data[index].name,
                                    phone: snapshot.data[index].phone,
                                    image: snapshot.data[index].image,
                                    inText: Text(
                                      snapshot.data[index].testSchedule
                                          .split(" ")[1],
                                      style: TextStyle(
                                        color: kPending,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )
                                : UnpressedCardWithText(
                                    name: snapshot.data[index].name,
                                    phone: snapshot.data[index].phone,
                                    image: snapshot.data[index].image,
                                    inText: Text(
                                      snapshot.data[index].testSchedule
                                          .split(" ")[1],
                                      style: TextStyle(
                                        color: kPending,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                          );
                        },
                      );
                    else
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
