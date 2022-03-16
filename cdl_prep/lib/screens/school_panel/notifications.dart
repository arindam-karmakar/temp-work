import 'package:cdl_prep/api/api.dart';
import 'package:cdl_prep/api/userPrefs.dart';
import 'package:cdl_prep/colour_scheme.dart';
import 'package:cdl_prep/models/dataModels.dart';
import 'package:cdl_prep/models/userModel.dart';
import 'package:cdl_prep/widgets/dashboardExtras.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SchoolNotification extends StatefulWidget {
  SchoolNotification({Key? key}) : super(key: key);

  @override
  _SchoolNotificationState createState() => _SchoolNotificationState();
}

class _SchoolNotificationState extends State<SchoolNotification> {
  int lastSelected = 0;
  var temp;

  @override
  Widget build(BuildContext context) {
    CdlSchool cdlSchool = Provider.of<CdlSchoolProvider>(context).school;

    Future<List<CdlNotification>> myNotifications() =>
        WebApi().getNotifications(cdlSchool.schoolId.toString());

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
                            child: BackButton(
                              color: Colors.blue[900],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Center(
                              child: Text(
                                "Notifications",
                                textScaleFactor: 1.5,
                                style: TextStyle(color: Colors.blue[900]),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(),
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
                child: FutureBuilder<List<CdlNotification>>(
                  future: myNotifications(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data.length == 0)
                        return Center(
                          child: Text(
                            "No new notifications!",
                            style: TextStyle(color: kTheTexts),
                          ),
                        );
                      else
                        return ListView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  textAlign: TextAlign.start,
                                  text: TextSpan(
                                    text: snapshot.data[index].remarks + "  ",
                                    style: TextStyle(
                                      color: kTheTexts,
                                      fontSize: 16.5,
                                      fontFamily: 'Amazon_Ember',
                                    ),
                                    children: [
                                      TextSpan(
                                        text: snapshot.data[index].status,
                                        style: TextStyle(
                                          color: (snapshot.data[index].status ==
                                                  'Accepted')
                                              ? kPaid
                                              : kPending,
                                          fontSize: 16.5,
                                          fontFamily: 'Amazon_Ember',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(
                                        text: "  the slot",
                                        style: TextStyle(
                                          color: kTheTexts,
                                          fontSize: 16.5,
                                          fontFamily: 'Amazon_Ember',
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.01),
                                Text(
                                  DateFormat('HH:mm dd-MM-yyyy', 'en_US')
                                      .format(snapshot.data[index].slot.from),
                                  textScaleFactor: 1.1,
                                  style: TextStyle(color: kTheTexts),
                                ),
                                SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.01),
                                Divider(
                                  color: kTheDivider.withOpacity(0.3),
                                  thickness: 2,
                                ),
                                SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.02),
                              ],
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
