import 'package:cdl_prep/api/api.dart';
import 'package:cdl_prep/colour_scheme.dart';
import 'package:cdl_prep/models/dataModels.dart';
import 'package:cdl_prep/models/userModel.dart';
import 'package:cdl_prep/screens/school_panel/editEnroll.dart';
import 'package:cdl_prep/screens/school_panel/schoolDrawer.dart';
import 'package:cdl_prep/screens/school_panel/slots.dart';
import 'package:cdl_prep/widgets/dashboardExtras.dart';
import 'package:cdl_prep/widgets/studentCard.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class StudentDetails extends StatefulWidget {
  final CdlStudent currentStudent;
  StudentDetails({
    Key? key,
    required this.currentStudent,
  }) : super(key: key);

  @override
  _StudentDetailsState createState() => _StudentDetailsState();
}

class _StudentDetailsState extends State<StudentDetails> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int lastSelected = 0;

  late final List data;

  @override
  void initState() {
    super.initState();
    data = [
      {
        'title': "Name & Number",
        'content':
            widget.currentStudent.name + " " + widget.currentStudent.phone,
      },
      {
        'title': "Test Schedule",
        'content': widget.currentStudent.testSchedule,
      },
      {
        'title': "City & State",
        'content': widget.currentStudent.cityState,
      },
      {
        'title': "CDL State",
        'content': widget.currentStudent.cdlState.state,
      },
      {
        'title': "Pre-Trip Ready",
        'content': widget.currentStudent.preTripReady,
      },
      {
        'title': "Skill Ready",
        'content': widget.currentStudent.skillReady,
      },
      {
        'title': "Road Ready",
        'content': widget.currentStudent.roadReady,
      },
      {
        'title': "Payment Status",
        'content': widget.currentStudent.paymentStatus,
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    Future<List<CdlSlot>> enrollSchedules() =>
        WebApi().getSlot(widget.currentStudent.enrollId.toString());

    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      drawer: getDrawer(3),
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
                                "Details",
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
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: EdgeInsets.only(
                            right: 30.0,
                            top: 5.0,
                            bottom: 5.0,
                          ),
                          child: GestureDetector(
                            /*onTap: () => Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => EditEnrollment(),
                              ),
                            ),*/
                            onTap: () => Fluttertoast.showToast(
                              msg: "Coming soon!",
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: kTheTexts,
                              textColor: Colors.white,
                            ),
                            child: Text(
                              "Edit",
                              textScaleFactor: 1.1,
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 12,
                child: Container(
                  height: double.maxFinite,
                  width: double.maxFinite,
                  color: Colors.transparent,
                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 15,
                        child: GridView.count(
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          crossAxisCount: 2,
                          childAspectRatio: 4 / 3,
                          children: <Widget>[
                            for (var i = 0; i < 8; i++)
                              AboutCard(
                                title: data[i]['title'],
                                content: data[i]['content'],
                              ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 7,
                        child: Column(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.only(top: 10.0),
                                  child: Text(
                                    "Previous Schedules",
                                    textScaleFactor: 1.2,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: kTheTexts),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: FutureBuilder<List<CdlSlot>>(
                                future: enrollSchedules(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    if (snapshot.data!.length == 0)
                                      return Center(
                                        child: Text(
                                          "No data",
                                          style: TextStyle(
                                              color: Colors.grey[600]),
                                        ),
                                      );
                                    else
                                      return ListView.builder(
                                        itemCount: snapshot.data!.length,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: EdgeInsets.all(2.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Flexible(
                                                  child: Text(
                                                    DateFormat('yyyy-MM-dd')
                                                        .format(snapshot
                                                            .data![index].from),
                                                    textScaleFactor: 1.1,
                                                    style: TextStyle(
                                                        color:
                                                            Colors.grey[600]),
                                                  ),
                                                ),
                                                Flexible(
                                                  child: Text(
                                                    DateFormat('HH:mm').format(
                                                            snapshot
                                                                .data![index]
                                                                .from) +
                                                        " - " +
                                                        DateFormat('HH:mm')
                                                            .format(snapshot
                                                                .data![index]
                                                                .to),
                                                    textScaleFactor: 1.1,
                                                    style: TextStyle(
                                                        color:
                                                            Colors.grey[600]),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                  } else
                                    return Center(
                                      child: CircularProgressIndicator(
                                        color: kTheTexts,
                                      ),
                                    );
                                },
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: GestureDetector(
                                onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => InitSlotForSchedule(
                                      enrollId: widget.currentStudent.enrollId
                                          .toString(),
                                      enrollPhone: widget.currentStudent.phone,
                                    ),
                                  ),
                                ),
                                child: Container(
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
                                      "Drive Time Test",
                                      textScaleFactor: 1.2,
                                      style: TextStyle(
                                        color: kTheTexts,
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

                            Navigator.of(context).pop();
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

                            Navigator.of(context).pop();
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

                            Navigator.of(context).pop();
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

                            Navigator.of(context).pop();
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
