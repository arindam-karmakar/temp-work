import 'package:cdl_prep/api/api.dart';
import 'package:cdl_prep/api/userPrefs.dart';
import 'package:cdl_prep/colour_scheme.dart';
import 'package:cdl_prep/models/dataModels.dart';
import 'package:cdl_prep/models/userModel.dart';
import 'package:cdl_prep/screens/resetPassword.dart';
import 'package:cdl_prep/screens/website.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class StudentProfile extends StatefulWidget {
  StudentProfile({Key? key}) : super(key: key);

  @override
  State<StudentProfile> createState() => _StudentProfileState();
}

class _StudentProfileState extends State<StudentProfile> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController _userNameController = TextEditingController();

  OpenWebsite openWebsite =
      new OpenWebsite(initialUrl: 'https://cdlprepapp.com/');

  var lastSelected;
  int? selectedState;
  bool onEditMode = false;

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    UserPreferences userPreferences = UserPreferences();

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

    if (_userNameController.text.isEmpty) {
      _userNameController.text =
          Provider.of<CdlUserProvider>(context, listen: false).user.name;
    }

    if (selectedState == null) {
      selectedState = Provider.of<CdlUserProvider>(context, listen: false)
          .user
          .cdlState
          .stateid;
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
                      onTap: () {},
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
                    "Profile",
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
              child: GestureDetector(
                onTap: () =>
                    Navigator.of(context).pushNamed('/studentNotification'),
                child: Icon(
                  Icons.notifications_outlined,
                  color: Colors.blue[900],
                ),
              ),
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
      body: Center(
        child: onEditMode
            ? Container(
                decoration: BoxDecoration(
                  color: Colors.blue.shade900,
                  borderRadius: BorderRadius.circular(25.0),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
                margin: EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextFormField(
                        controller: _userNameController,
                        cursorColor: Colors.white,
                        cursorRadius: Radius.circular(30.0),
                        maxLines: 1,
                        maxLength: 50,
                        obscureText: false,
                        keyboardType: TextInputType.name,
                        style: TextStyle(color: Colors.white),
                        enableInteractiveSelection: true,
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          labelText: "Name *",
                          labelStyle: TextStyle(color: Colors.white),
                          counterText: "",
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Column(
                        children: [
                          FutureBuilder<List<CdlState>>(
                            future: WebApi().getStates(),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.hasData)
                                return DropdownButton<int>(
                                  itemHeight: 50,
                                  isExpanded: true,
                                  underline: Container(),
                                  dropdownColor: Colors.blue.shade900,
                                  hint: Text(
                                    "Choose State *",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Amazon_Ember',
                                    ),
                                  ),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Amazon_Ember',
                                  ),
                                  icon: Icon(
                                    Icons.arrow_drop_down_rounded,
                                    color: Colors.white,
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
                                    child: CircularProgressIndicator(
                                        color: Colors.white),
                                  ),
                                );
                            },
                          ),
                          Divider(
                            color: Colors.white,
                            thickness: 1,
                          ),
                        ],
                      ),
                      SizedBox(height: 30.0),
                      GestureDetector(
                        onTap: () async {
                          var currentUser = Provider.of<CdlUserProvider>(
                                  context,
                                  listen: false)
                              .user;

                          if (selectedState == null ||
                              _userNameController.text.isEmpty) {
                            Fluttertoast.showToast(
                                msg: "Please fill all the details");
                          } else {
                            Overlay.of(context)!.insert(overlayEntry);

                            var resp = await authProvider.updateStudent(
                              currentUser.userid.toString(),
                              _userNameController.text,
                              currentUser.phone,
                              selectedState.toString(),
                            );

                            overlayEntry.remove();

                            if (resp['status']) {
                              Provider.of<CdlUserProvider>(context,
                                      listen: false)
                                  .setUser(resp['student']);

                              Fluttertoast.showToast(
                                  msg: "Profile updated successfully");

                              setState(() {
                                onEditMode = false;
                              });
                            } else {
                              Fluttertoast.showToast(msg: 'Try Again!');
                            }
                          }
                        },
                        child: Container(
                          height: 50.0,
                          width: 150.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            color: Colors.white,
                          ),
                          child: Center(
                            child: Text(
                              "Update",
                              textScaleFactor: 1.2,
                              style: TextStyle(
                                color: kTheTexts,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            onEditMode = true;
                          });
                        },
                        icon: ImageIcon(
                          AssetImage('assets/images/Group 14.png'),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blue.shade900,
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 50.0),
                    margin: EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          Provider.of<CdlUserProvider>(context, listen: false)
                              .user
                              .name,
                          textScaleFactor: 1.1,
                          style: TextStyle(color: Colors.white),
                        ),
                        Divider(
                          color: Colors.white,
                        ),
                        SizedBox(height: 15.0),
                        Text(
                          Provider.of<CdlUserProvider>(context, listen: false)
                              .user
                              .phone,
                          textScaleFactor: 1.1,
                          style: TextStyle(color: Colors.white),
                        ),
                        Divider(
                          color: Colors.white,
                        ),
                        SizedBox(height: 15.0),
                        Text(
                          Provider.of<CdlUserProvider>(context, listen: false)
                              .user
                              .cdlState
                              .state,
                          textScaleFactor: 1.1,
                          style: TextStyle(color: Colors.white),
                        ),
                        Divider(
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
