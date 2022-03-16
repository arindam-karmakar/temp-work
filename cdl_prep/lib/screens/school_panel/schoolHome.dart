import 'package:cdl_prep/api/api.dart';
import 'package:cdl_prep/api/userPrefs.dart';
import 'package:cdl_prep/colour_scheme.dart';
import 'package:cdl_prep/models/userModel.dart';
import 'package:cdl_prep/screens/school_panel/schoolDrawer.dart';
import 'package:cdl_prep/services/notification_service.dart';
import 'package:cdl_prep/widgets/dashboardExtras.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class SchoolDashboard extends StatefulWidget {
  SchoolDashboard({Key? key}) : super(key: key);

  @override
  _SchoolDashboardState createState() => _SchoolDashboardState();
}

class _SchoolDashboardState extends State<SchoolDashboard> {
  Future<void> viewNotification() async {
    RemoteMessage? msg = await FirebaseMessaging.instance.getInitialMessage();

    if (msg != null) handleMessage(msg);

    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  }

  void handleMessage(RemoteMessage message) {
    Navigator.of(context).pushNamed('/schoolNotification');
  }

  @override
  void initState() {
    super.initState();
    viewNotification();
  }

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int lastSelected = 0;

  WebApi webApi = new WebApi();
  bool readForThisSession = false;

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);

    return Consumer<CdlSchoolProvider>(
      builder: (context, schoolData, newWidget) {
        return Scaffold(
          /*floatingActionButton: FloatingActionButton(
            onPressed: () async {
              const AndroidNotificationChannel channel =
                  AndroidNotificationChannel(
                'high_importance_channel', // id
                'High Importance Notifications', // title
                description:
                    'This channel is used for important notifications.', // description
                importance: Importance.max,
                playSound: true,
                enableVibration: true,
              );

              final FlutterLocalNotificationsPlugin
                  flutterLocalNotificationsPlugin =
                  FlutterLocalNotificationsPlugin();

              await flutterLocalNotificationsPlugin
                  .resolvePlatformSpecificImplementation<
                      AndroidFlutterLocalNotificationsPlugin>()
                  ?.createNotificationChannel(channel);

              flutterLocalNotificationsPlugin.show(
                68716501,
                "test",
                "notification.body",
                NotificationDetails(
                  android: AndroidNotificationDetails(
                    channel.id,
                    channel.name,
                    channelDescription: channel.description,
                    enableVibration: true,
                    playSound: true,
                    importance: channel.importance,
                    priority: Priority.max,
                    visibility: NotificationVisibility.public,
                    // other properties...
                  ),
                  iOS: IOSNotificationDetails(),
                ),
                payload: "",
              );
            },
          ),*/
          resizeToAvoidBottomInset: false,
          key: _scaffoldKey,
          drawer: getDrawer(1),
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
                          // Spacer(),
                          Expanded(
                            flex: 6,
                            child: Center(
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: IconButton(
                                      onPressed: () => _scaffoldKey
                                          .currentState!
                                          .openDrawer(),
                                      icon: ImageIcon(
                                        AssetImage(
                                            'assets/images/drawerVector.png'),
                                        size: 18.0,
                                        color: Colors.blue[900],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Center(
                                      child: Text(
                                        "Dashboard",
                                        textScaleFactor: 1.5,
                                        style:
                                            TextStyle(color: Colors.blue[900]),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Flexible(
                                          child: IconButton(
                                            onPressed: () =>
                                                Navigator.of(context)
                                                    .pushNamed('/searchEnroll'),
                                            icon: Icon(Icons.search),
                                            color: Colors.blue[900],
                                          ),
                                        ),
                                        Flexible(
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).pushNamed(
                                                  '/schoolNotification');
                                              setState(() {
                                                readForThisSession = true;
                                              });

                                              Future.delayed(
                                                Duration(seconds: 2),
                                                () async {
                                                  final listOfNotif =
                                                      await webApi
                                                          .getNotifications(
                                                              schoolData.school
                                                                  .schoolId
                                                                  .toString());

                                                  if (listOfNotif.isNotEmpty)
                                                    await webApi
                                                        .markNotif(listOfNotif);
                                                },
                                              );
                                            },
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                Icon(
                                                  Icons.notifications,
                                                  color: Colors.blue[900],
                                                ),
                                                (!readForThisSession)
                                                    ? FutureBuilder(
                                                        future: webApi
                                                            .getNotifCount(
                                                                schoolData
                                                                    .school
                                                                    .schoolId
                                                                    .toString()),
                                                        builder: (context,
                                                            snapshot) {
                                                          if (snapshot
                                                                  .hasData &&
                                                              snapshot.data !=
                                                                  0)
                                                            return Container(
                                                              height: 17.0,
                                                              width: 17.0,
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      bottom:
                                                                          18.0,
                                                                      left:
                                                                          14.0),
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(3.0),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: kPending,
                                                                shape: BoxShape
                                                                    .circle,
                                                              ),
                                                              child: FittedBox(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: Text(
                                                                  snapshot.data
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              ),
                                                            );
                                                          else
                                                            return Container();
                                                        },
                                                      )
                                                    : Container(),
                                              ],
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
                          // Spacer(),
                          Expanded(
                            flex: 2,
                            child: Center(
                              child: Divider(
                                color: kTheDivider.withOpacity(0.3),
                                thickness: 2.0,
                                indent: 20.0,
                                endIndent: 20.0,
                              ),
                            ),
                          ),
                          // Spacer(),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 12,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: SingleChildScrollView(
                        child: Wrap(
                          spacing: 15.0,
                          runSpacing: 15.0,
                          crossAxisAlignment: WrapCrossAlignment.start,
                          alignment: WrapAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  lastSelected = 1;
                                });

                                Future.delayed(
                                  Duration(milliseconds: 30),
                                  () {
                                    Navigator.of(context)
                                        .pushNamed('/enrollStudent');
                                  },
                                );
                              },
                              child: Container(
                                constraints: BoxConstraints(
                                  maxHeight: 200,
                                  maxWidth: 150,
                                ),
                                child: (lastSelected == 1)
                                    ? PressedButton(
                                        icon: Image.asset(
                                            'assets/images/11 1.png'),
                                        text: "Enroll Students",
                                      )
                                    : UnpressedButton(
                                        icon: Image.asset(
                                            'assets/images/11 1.png'),
                                        text: "Enroll Students",
                                      ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                setState(() {
                                  lastSelected = 2;
                                });

                                Future.delayed(
                                  Duration(milliseconds: 30),
                                  () {
                                    Navigator.of(context)
                                        .pushNamed('/payments');
                                  },
                                );
                              },
                              child: Container(
                                constraints: BoxConstraints(
                                  maxHeight: 200,
                                  maxWidth: 150,
                                ),
                                child: (lastSelected == 2)
                                    ? PressedButton(
                                        icon: Image.asset(
                                            'assets/images/10 2.png'),
                                        text: "Payment Status",
                                      )
                                    : UnpressedButton(
                                        icon: Image.asset(
                                            'assets/images/10 2.png'),
                                        text: "Payment Status",
                                      ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  lastSelected = 3;
                                });

                                Future.delayed(
                                  Duration(milliseconds: 30),
                                  () {
                                    Navigator.of(context).pushNamed('/preTrip');
                                  },
                                );
                              },
                              child: Container(
                                constraints: BoxConstraints(
                                  maxHeight: 200,
                                  maxWidth: 150,
                                ),
                                child: (lastSelected == 3)
                                    ? PressedButton(
                                        icon: Image.asset(
                                            'assets/images/16 1.png'),
                                        text: "Pre-Trip Ready",
                                      )
                                    : UnpressedButton(
                                        icon: Image.asset(
                                            'assets/images/16 1.png'),
                                        text: "Pre-Trip Ready",
                                      ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  lastSelected = 4;
                                });

                                Future.delayed(
                                  Duration(milliseconds: 30),
                                  () {
                                    Navigator.of(context).pushNamed('/skill');
                                  },
                                );
                              },
                              child: Container(
                                constraints: BoxConstraints(
                                  maxHeight: 200,
                                  maxWidth: 150,
                                ),
                                child: (lastSelected == 4)
                                    ? PressedButton(
                                        icon: Image.asset(
                                            'assets/images/17 2.png'),
                                        text: "Skill Ready",
                                      )
                                    : UnpressedButton(
                                        icon: Image.asset(
                                            'assets/images/17 2.png'),
                                        text: "Skill Ready",
                                      ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  lastSelected = 5;
                                });

                                Future.delayed(
                                  Duration(milliseconds: 30),
                                  () {
                                    Navigator.of(context).pushNamed('/road');
                                  },
                                );
                              },
                              child: Container(
                                constraints: BoxConstraints(
                                  maxHeight: 200,
                                  maxWidth: 150,
                                ),
                                child: (lastSelected == 5)
                                    ? PressedButton(
                                        icon: Image.asset(
                                            'assets/images/15 1.png'),
                                        text: "Road Ready",
                                      )
                                    : UnpressedButton(
                                        icon: Image.asset(
                                            'assets/images/15 1.png'),
                                        text: "Road Ready",
                                      ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  lastSelected = 6;
                                });

                                Future.delayed(
                                  Duration(milliseconds: 30),
                                  () {
                                    Navigator.of(context).pushNamed('/slots');
                                  },
                                );
                              },
                              child: Container(
                                constraints: BoxConstraints(
                                  maxHeight: 200,
                                  maxWidth: 150,
                                ),
                                child: (lastSelected == 6)
                                    ? PressedButton(
                                        icon: Image.asset(
                                            'assets/images/14 1.png'),
                                        text: "Slots",
                                      )
                                    : UnpressedButton(
                                        icon: Image.asset(
                                            'assets/images/14 1.png'),
                                        text: "Slots",
                                      ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  lastSelected = 7;
                                });

                                Future.delayed(
                                  Duration(milliseconds: 30),
                                  () {
                                    Navigator.of(context)
                                        .pushNamed('/driveTime');
                                  },
                                );
                              },
                              child: Container(
                                constraints: BoxConstraints(
                                  maxHeight: 200,
                                  maxWidth: 150,
                                ),
                                child: (lastSelected == 7)
                                    ? PressedButton(
                                        icon: Image.asset(
                                            'assets/images/4 1.png'),
                                        text: "Drive Time",
                                      )
                                    : UnpressedButton(
                                        icon: Image.asset(
                                            'assets/images/4 1.png'),
                                        text: "Drive Time",
                                      ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  lastSelected = 8;
                                });

                                Future.delayed(
                                  Duration(milliseconds: 30),
                                  () {
                                    Navigator.of(context)
                                        .pushNamed('/testDate');
                                  },
                                );
                              },
                              child: Container(
                                constraints: BoxConstraints(
                                  maxHeight: 200,
                                  maxWidth: 150,
                                ),
                                child: (lastSelected == 8)
                                    ? PressedButton(
                                        icon: Image.asset(
                                          'assets/images/4-icon 1.png',
                                        ),
                                        text: "Test Date",
                                      )
                                    : UnpressedButton(
                                        icon: Image.asset(
                                          'assets/images/4-icon 1.png',
                                        ),
                                        text: "Test Date",
                                      ),
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

                                Future.delayed(
                                  Duration(milliseconds: 30),
                                  () {
                                    Navigator.of(context)
                                        .pushNamed('/enrollStudent');
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
                                        .pushNamed('/payments');
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
                                              iconPath:
                                                  "assets/images/10 2.png")
                                          : IconUnpressedButton(
                                              iconPath:
                                                  'assets/images/10 2.png'),
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
                                    Navigator.of(context).pushNamed('/slots');
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
                                        .pushNamed('/driveTime');
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
      },
    );
  }
}
