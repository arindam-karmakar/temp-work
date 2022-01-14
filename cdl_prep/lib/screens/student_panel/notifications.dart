import 'package:cdl_prep/api/api.dart';
import 'package:cdl_prep/api/userPrefs.dart';
import 'package:cdl_prep/colour_scheme.dart';
import 'package:cdl_prep/models/dataModels.dart';
import 'package:cdl_prep/models/userModel.dart';
import 'package:cdl_prep/screens/website.dart';
import 'package:cdl_prep/widgets/dashboardExtras.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class StudentNotification extends StatefulWidget {
  StudentNotification({Key? key}) : super(key: key);

  @override
  _StudentNotificationState createState() => _StudentNotificationState();
}

class _StudentNotificationState extends State<StudentNotification> {
  int lastSelected = 0;
  WebApi webApi = new WebApi();

  @override
  Widget build(BuildContext context) {
    CdlUser cdlUser = Provider.of<CdlUserProvider>(context).user;

    Future<List<CdlNotification>> myNotifications() =>
        WebApi().getNotifications(cdlUser.userid.toString());

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
                              onPressed: () => Navigator.of(context).pop(),
                              icon: Icon(
                                Icons.home,
                                color: Colors.blue[900],
                              ),
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
                                (snapshot.data[index].status != "Pending")
                                    ? RichText(
                                        textAlign: TextAlign.start,
                                        text: TextSpan(
                                          text: "You  ",
                                          style: TextStyle(
                                            color: kTheTexts,
                                            fontSize: 16.5,
                                            fontFamily: 'Amazon_Ember',
                                          ),
                                          children: [
                                            TextSpan(
                                              text: snapshot.data[index].status,
                                              style: TextStyle(
                                                color: (snapshot.data[index]
                                                            .status ==
                                                        'Accepted')
                                                    ? kPaid
                                                    : kPending,
                                                fontSize: 16.5,
                                                fontFamily: 'Amazon_Ember',
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            TextSpan(
                                              text:
                                                  "  the slot by ${snapshot.data[index].remarks}",
                                              style: TextStyle(
                                                color: kTheTexts,
                                                fontSize: 16.5,
                                                fontFamily: 'Amazon_Ember',
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    : Text(
                                        "${snapshot.data[index].remarks} allotted you the slot",
                                        style: TextStyle(
                                          color: kTheTexts,
                                          fontSize: 16.5,
                                          fontFamily: 'Amazon_Ember',
                                        ),
                                      ),
                                SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.01),
                                (snapshot.data[index].status != "Pending")
                                    ? Text(
                                        DateFormat('HH:mm dd-MM-yyyy', 'en_US')
                                            .format(
                                                snapshot.data[index].slot.from),
                                        textScaleFactor: 1.1,
                                        style: TextStyle(color: kTheTexts),
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            child: Column(
                                              children: [
                                                Text(
                                                  DateFormat(
                                                          'dd-MM-yyyy', 'en_US')
                                                      .format(snapshot
                                                          .data[index]
                                                          .slot
                                                          .from),
                                                  textScaleFactor: 1.1,
                                                  style: TextStyle(
                                                      color: kTheTexts),
                                                ),
                                                SizedBox(height: 5.0),
                                                Text(
                                                  DateFormat('HH:mm', 'en_US')
                                                          .format(snapshot
                                                              .data[index]
                                                              .slot
                                                              .from) +
                                                      " to " +
                                                      DateFormat(
                                                              'HH:mm', 'en_US')
                                                          .format(snapshot
                                                              .data[index]
                                                              .slot
                                                              .to),
                                                  textScaleFactor: 1.1,
                                                  style: TextStyle(
                                                      color: kTheTexts),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Flexible(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                GestureDetector(
                                                  onTap: () async {
                                                    Overlay.of(context)!
                                                        .insert(overlayEntry);

                                                    await webApi
                                                        .setNotifications(
                                                      "Accepted",
                                                      snapshot.data[index].slot
                                                          .slotId
                                                          .toString(),
                                                      snapshot.data[index]
                                                          .enrolledBy
                                                          .toString(),
                                                      cdlUser.userid.toString(),
                                                      cdlUser.name,
                                                    );

                                                    String report = await webApi
                                                        .editNotifications(
                                                      "Accepted",
                                                      cdlUser.userid.toString(),
                                                      "${snapshot.data[index].remarks}",
                                                      snapshot.data[index].id
                                                          .toString(),
                                                    );

                                                    (report == "SUCCESS")
                                                        ? Fluttertoast
                                                            .showToast(
                                                            msg:
                                                                "You accepted the slot!",
                                                            gravity:
                                                                ToastGravity
                                                                    .BOTTOM,
                                                            backgroundColor:
                                                                kTheTexts,
                                                            textColor:
                                                                Colors.white,
                                                          )
                                                        : Fluttertoast
                                                            .showToast(
                                                            msg:
                                                                "Error occurred!",
                                                            gravity:
                                                                ToastGravity
                                                                    .BOTTOM,
                                                            backgroundColor:
                                                                kTheTexts,
                                                            textColor:
                                                                Colors.white,
                                                          );

                                                    overlayEntry.remove();

                                                    Navigator.of(context)
                                                        .pushReplacementNamed(
                                                            '/studentNotification');
                                                  },
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 7.0,
                                                            vertical: 5.0),
                                                    decoration: BoxDecoration(
                                                      color: kPaid,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                    child: Text(
                                                      "Accept",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.03),
                                                GestureDetector(
                                                  onTap: () async {
                                                    Overlay.of(context)!
                                                        .insert(overlayEntry);

                                                    await webApi
                                                        .setNotifications(
                                                      "Declined",
                                                      snapshot.data[index].slot
                                                          .slotId
                                                          .toString(),
                                                      snapshot.data[index]
                                                          .enrolledBy
                                                          .toString(),
                                                      cdlUser.userid.toString(),
                                                      cdlUser.name,
                                                    );

                                                    String report = await webApi
                                                        .editNotifications(
                                                      "Declined",
                                                      cdlUser.userid.toString(),
                                                      "${snapshot.data[index].remarks}",
                                                      snapshot.data[index].id
                                                          .toString(),
                                                    );

                                                    (report == "SUCCESS")
                                                        ? Fluttertoast
                                                            .showToast(
                                                            msg:
                                                                "You declined the slot!",
                                                            gravity:
                                                                ToastGravity
                                                                    .BOTTOM,
                                                            backgroundColor:
                                                                kTheTexts,
                                                            textColor:
                                                                Colors.white,
                                                          )
                                                        : Fluttertoast
                                                            .showToast(
                                                            msg:
                                                                "Error occurred!",
                                                            gravity:
                                                                ToastGravity
                                                                    .BOTTOM,
                                                            backgroundColor:
                                                                kTheTexts,
                                                            textColor:
                                                                Colors.white,
                                                          );

                                                    overlayEntry.remove();

                                                    Navigator.of(context)
                                                        .pushReplacementNamed(
                                                            '/studentNotification');
                                                  },
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 7.0,
                                                            vertical: 5.0),
                                                    decoration: BoxDecoration(
                                                      color: kPending,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                    child: Text(
                                                      "Decline",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
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
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              lastSelected = 5;
                            });
                            Future.delayed(
                              Duration(milliseconds: 30),
                              () => Navigator.of(context)
                                  .pushReplacementNamed('/beginExam'),
                            );
                          },
                          child: (lastSelected == 5)
                              ? IconPressedButton(
                                  iconPath: 'assets/images/5.png',
                                )
                              : IconUnpressedButton(
                                  iconPath: 'assets/images/5.png',
                                ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              lastSelected = 6;
                            });
                            Future.delayed(
                              Duration(milliseconds: 30),
                              () => Navigator.of(context)
                                  .pushReplacementNamed('/beginPractice'),
                            );
                          },
                          child: (lastSelected == 6)
                              ? IconPressedButton(
                                  iconPath: 'assets/images/9 1.png',
                                )
                              : IconUnpressedButton(
                                  iconPath: 'assets/images/9 1.png',
                                ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              lastSelected = 7;
                            });

                            OpenWebsite openWebsite = new OpenWebsite(
                                initialUrl: 'https://cdlprepapp.com/');

                            Future.delayed(
                              Duration(milliseconds: 30),
                              () async {
                                await openWebsite.open();
                              },
                            );
                          },
                          child: (lastSelected == 7)
                              ? IconPressedButton(
                                  iconPath: 'assets/images/6.png',
                                )
                              : IconUnpressedButton(
                                  iconPath: 'assets/images/6.png',
                                ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              lastSelected = 8;
                            });

                            OpenWebsite openWebsite = new OpenWebsite(
                                initialUrl: 'https://cdlprepapp.com/');

                            Future.delayed(
                              Duration(milliseconds: 30),
                              () async {
                                await openWebsite.open();
                              },
                            );
                          },
                          child: (lastSelected == 8)
                              ? IconPressedButton(
                                  iconPath: 'assets/images/7.png',
                                )
                              : IconUnpressedButton(
                                  iconPath: 'assets/images/7.png',
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
