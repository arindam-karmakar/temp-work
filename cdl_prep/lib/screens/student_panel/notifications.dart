import 'package:cdl_prep/api/api.dart';
import 'package:cdl_prep/api/userPrefs.dart';
import 'package:cdl_prep/colour_scheme.dart';
import 'package:cdl_prep/models/dataModels.dart';
import 'package:cdl_prep/models/userModel.dart';
import 'package:cdl_prep/screens/resetPassword.dart';
import 'package:cdl_prep/screens/student_panel/student_profile.dart';
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
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int lastSelected = 0;
  WebApi webApi = new WebApi();

  OpenWebsite openWebsite =
      new OpenWebsite(initialUrl: 'https://cdlprepapp.com/');

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

    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    UserPreferences userPreferences = UserPreferences();

    confirmLogout() {
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
                  color: Colors.blue.shade900,
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
                      flex: 1,
                      child: Center(
                        child: Text(
                          "Logout",
                          textScaleFactor: 1.4,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Center(
                        child: Text(
                          "Do you really want to logout from the app?",
                          textAlign: TextAlign.center,
                          textScaleFactor: 1.2,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Flexible(
                            child: GestureDetector(
                              onTap: () => Navigator.of(context).pop(),
                              child: Container(
                                height: 50.0,
                                width: 100.0,
                                color: Colors.transparent,
                                child: Center(
                                  child: Text(
                                    "No",
                                    textScaleFactor: 1.2,
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            child: GestureDetector(
                              onTap: () async {
                                await authProvider.logout();
                                CdlUser logoutUser =
                                    await userPreferences.getUser();

                                Provider.of<CdlUserProvider>(context,
                                        listen: false)
                                    .setUser(logoutUser);

                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                                Navigator.of(context)
                                    .pushReplacementNamed('/handleLogin');

                                setState(() {
                                  lastSelected = 0;
                                });

                                Fluttertoast.showToast(
                                  msg: "Successfully logged out!",
                                  gravity: ToastGravity.BOTTOM,
                                  backgroundColor: kTheTexts,
                                  textColor: Colors.white,
                                );
                              },
                              child: Container(
                                height: 50.0,
                                width: 100.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50.0),
                                  color: Colors.white,
                                ),
                                child: Center(
                                  child: Text(
                                    "Yes",
                                    textScaleFactor: 1.2,
                                    style: TextStyle(
                                      color: Colors.blue.shade900,
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
          );
        },
      );
    }

    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        backgroundColor: Colors.blue.shade900,
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 3,
                child: ListView(
                  children: [
                    SizedBox(
                      height: 150.0,
                      child: DrawerHeader(
                        padding: EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(
                              'assets/images/logo.png',
                              height: 45.0,
                            ),
                            IconButton(
                              onPressed: () => Navigator.of(context).pop(),
                              icon: Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.home),
                      title: Text(
                        "Dashboard",
                        textScaleFactor: 1.3,
                      ),
                      iconColor: Colors.white,
                      textColor: Colors.white,
                      dense: true,
                      horizontalTitleGap: 8.0,
                      style: ListTileStyle.drawer,
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                    ),
                    Divider(
                      color: Colors.white,
                      thickness: 1.0,
                      height: 8.0,
                    ),
                    ListTile(
                      leading: Icon(Icons.key),
                      title: Text(
                        "Change Password",
                        textScaleFactor: 1.3,
                      ),
                      iconColor: Colors.white,
                      textColor: Colors.white,
                      dense: true,
                      horizontalTitleGap: 8.0,
                      style: ListTileStyle.drawer,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ResetPassword(),
                        ),
                      ),
                    ),
                    Divider(
                      color: Colors.white,
                      thickness: 1.0,
                      height: 8.0,
                    ),
                    ListTile(
                      leading: Icon(Icons.person),
                      title: Text(
                        "Profile",
                        textScaleFactor: 1.3,
                      ),
                      iconColor: Colors.white,
                      textColor: Colors.white,
                      dense: true,
                      horizontalTitleGap: 8.0,
                      style: ListTileStyle.drawer,
                      onTap: () {
                        Navigator.of(context).pop();

                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => StudentProfile()));
                      },
                    ),
                    Divider(
                      color: Colors.white,
                      thickness: 1.0,
                      height: 8.0,
                    ),
                  ],
                ),
              ),
              Flexible(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Divider(
                      color: Colors.white,
                      thickness: 1.0,
                      height: 8.0,
                    ),
                    ListTile(
                      leading: ImageIcon(
                        AssetImage(
                          'assets/images/logoutVector.png',
                        ),
                        size: 20.0,
                      ),
                      title: Text(
                        "Logout",
                        textScaleFactor: 1.3,
                      ),
                      iconColor: Colors.white,
                      textColor: Colors.white,
                      dense: true,
                      horizontalTitleGap: 8.0,
                      style: ListTileStyle.drawer,
                      onTap: () {
                        Navigator.of(context).pop();

                        confirmLogout();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => _scaffoldKey.currentState!.openDrawer(),
          icon: ImageIcon(
            AssetImage('assets/images/drawerVector2.png'),
            color: Colors.blue[900],
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
              child: Image.asset(
                'assets/images/logo.png',
                height: 25.0,
                width: 25.0,
              ),
            ),
            Flexible(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Notifications",
                    textScaleFactor: 1.1,
                    style: TextStyle(color: Colors.blue[900]),
                  ),
                  Divider(
                    height: 8.0,
                    color: Colors.blue[900],
                    thickness: 1.0,
                    indent: 15.0,
                    endIndent: 15.0,
                  ),
                ],
              ),
            ),
            Flexible(
              child: Container(),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => confirmLogout(),
            icon: ImageIcon(
              AssetImage('assets/images/logoutVector.png'),
              size: 20.0,
              color: Colors.red,
            ),
          )
        ],
      ),
      body: FutureBuilder<List<CdlNotification>>(
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
                          height: MediaQuery.of(context).size.height * 0.01),
                      (snapshot.data[index].status != "Pending")
                          ? Text(
                              DateFormat('HH:mm dd-MM-yyyy', 'en_US')
                                  .format(snapshot.data[index].slot.from),
                              textScaleFactor: 1.1,
                              style: TextStyle(color: kTheTexts),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Column(
                                    children: [
                                      Text(
                                        DateFormat('dd-MM-yyyy', 'en_US')
                                            .format(
                                                snapshot.data[index].slot.from),
                                        textScaleFactor: 1.1,
                                        style: TextStyle(color: kTheTexts),
                                      ),
                                      SizedBox(height: 5.0),
                                      Text(
                                        DateFormat('HH:mm', 'en_US').format(
                                                snapshot
                                                    .data[index].slot.from) +
                                            " to " +
                                            DateFormat('HH:mm', 'en_US').format(
                                                snapshot.data[index].slot.to),
                                        textScaleFactor: 1.1,
                                        style: TextStyle(color: kTheTexts),
                                      ),
                                    ],
                                  ),
                                ),
                                Flexible(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          Overlay.of(context)!
                                              .insert(overlayEntry);

                                          await webApi.setNotifications(
                                            "Accepted",
                                            snapshot.data[index].slot.slotId
                                                .toString(),
                                            snapshot.data[index].enrolledBy
                                                .toString(),
                                            cdlUser.userid.toString(),
                                            cdlUser.name,
                                          );

                                          String report =
                                              await webApi.editNotifications(
                                            "Accepted",
                                            cdlUser.userid.toString(),
                                            "${snapshot.data[index].remarks}",
                                            snapshot.data[index].id.toString(),
                                          );

                                          (report == "SUCCESS")
                                              ? Fluttertoast.showToast(
                                                  msg: "You accepted the slot!",
                                                  gravity: ToastGravity.BOTTOM,
                                                  backgroundColor: kTheTexts,
                                                  textColor: Colors.white,
                                                )
                                              : Fluttertoast.showToast(
                                                  msg: "Error occurred!",
                                                  gravity: ToastGravity.BOTTOM,
                                                  backgroundColor: kTheTexts,
                                                  textColor: Colors.white,
                                                );

                                          overlayEntry.remove();

                                          Navigator.of(context)
                                              .pushReplacementNamed(
                                                  '/studentNotification');
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 7.0, vertical: 5.0),
                                          decoration: BoxDecoration(
                                            color: kPaid,
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          child: Text(
                                            "Accept",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.03),
                                      GestureDetector(
                                        onTap: () async {
                                          Overlay.of(context)!
                                              .insert(overlayEntry);

                                          await webApi.setNotifications(
                                            "Declined",
                                            snapshot.data[index].slot.slotId
                                                .toString(),
                                            snapshot.data[index].enrolledBy
                                                .toString(),
                                            cdlUser.userid.toString(),
                                            cdlUser.name,
                                          );

                                          String report =
                                              await webApi.editNotifications(
                                            "Declined",
                                            cdlUser.userid.toString(),
                                            "${snapshot.data[index].remarks}",
                                            snapshot.data[index].id.toString(),
                                          );

                                          (report == "SUCCESS")
                                              ? Fluttertoast.showToast(
                                                  msg: "You declined the slot!",
                                                  gravity: ToastGravity.BOTTOM,
                                                  backgroundColor: kTheTexts,
                                                  textColor: Colors.white,
                                                )
                                              : Fluttertoast.showToast(
                                                  msg: "Error occurred!",
                                                  gravity: ToastGravity.BOTTOM,
                                                  backgroundColor: kTheTexts,
                                                  textColor: Colors.white,
                                                );

                                          overlayEntry.remove();

                                          Navigator.of(context)
                                              .pushReplacementNamed(
                                                  '/studentNotification');
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 7.0, vertical: 5.0),
                                          decoration: BoxDecoration(
                                            color: kPending,
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          child: Text(
                                            "Decline",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01),
                      Divider(
                        color: kTheDivider.withOpacity(0.3),
                        thickness: 2,
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
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
      bottomNavigationBar: Container(
        height: 80.0,
        child: Column(
          children: [
            Divider(
              color: Colors.grey,
              thickness: 1.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        lastSelected = 5;
                      });
                      Future.delayed(
                        Duration(milliseconds: 30),
                        () {
                          Navigator.of(context).pushNamed('/beginExam');
                        },
                      );
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: ImageIcon(
                            AssetImage('assets/images/5.png'),
                            size: 32.0,
                            color: (lastSelected == 5)
                                ? Colors.blue.shade900
                                : Colors.grey,
                          ),
                        ),
                        Flexible(
                          child: Text(
                            "CDL Prep Test",
                            style: TextStyle(
                              color: (lastSelected == 5)
                                  ? Colors.blue.shade900
                                  : Colors.grey,
                            ),
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
                        lastSelected = 6;
                      });
                      Future.delayed(
                        Duration(milliseconds: 30),
                        () {
                          Navigator.of(context).pushNamed('/beginPractice');
                        },
                      );
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: ImageIcon(
                            AssetImage('assets/images/9 1.png'),
                            size: 38.0,
                            color: (lastSelected == 6)
                                ? Colors.blue.shade900
                                : Colors.grey,
                          ),
                        ),
                        Flexible(
                          child: Text(
                            "CDL Practice",
                            style: TextStyle(
                              color: (lastSelected == 6)
                                  ? Colors.blue.shade900
                                  : Colors.grey,
                            ),
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
                        lastSelected = 7;
                      });

                      Future.delayed(
                        Duration(milliseconds: 30),
                        () async {
                          await openWebsite.open();
                        },
                      );
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: ImageIcon(
                            AssetImage('assets/images/6.png'),
                            size: 32.0,
                            color: (lastSelected == 7)
                                ? Colors.blue.shade900
                                : Colors.grey,
                          ),
                        ),
                        Flexible(
                          child: Text(
                            "Visit Website",
                            style: TextStyle(
                              color: (lastSelected == 7)
                                  ? Colors.blue.shade900
                                  : Colors.grey,
                            ),
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
                        lastSelected = 8;
                      });

                      Future.delayed(
                        Duration(milliseconds: 30),
                        () async {
                          await openWebsite.open();
                        },
                      );
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: ImageIcon(
                            AssetImage('assets/images/7.png'),
                            size: 32.0,
                            color: (lastSelected == 8)
                                ? Colors.blue.shade900
                                : Colors.grey,
                          ),
                        ),
                        Flexible(
                          child: Text(
                            "News",
                            style: TextStyle(
                              color: (lastSelected == 8)
                                  ? Colors.blue.shade900
                                  : Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
