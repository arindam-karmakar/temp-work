import 'package:eldtprep/api/api.dart';
import 'package:eldtprep/api/userPrefs.dart';
import 'package:eldtprep/colour_scheme.dart';
import 'package:eldtprep/models/userModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

Widget getDrawer(int currentPage) =>
    Consumer<CdlSchoolProvider>(builder: (context, data, wid1) {
      CdlSchool school = Provider.of<CdlSchoolProvider>(context).school;

      int lastSelected = 0;

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
                        flex: 1,
                        child: Center(
                          child: Text(
                            "Logout",
                            textScaleFactor: 1.4,
                            style: TextStyle(
                              color: kTheTexts,
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
                              color: kTheTexts,
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
                                        color: kTheTexts,
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
                                  Navigator.of(context)
                                      .pushReplacementNamed('/handleLogin');

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
                                    gradient: LinearGradient(
                                      colors: [
                                        kOrangeOne,
                                        kOrangeTwo.withOpacity(0.05)
                                      ],
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Yes",
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
            );
          },
        );
      }

      return Drawer(
        child: Container(
          //width: double.maxFinite,
          color: kTheDrawer,
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01),
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          padding: EdgeInsets.zero,
                          icon: Icon(
                            Icons.close,
                            size: 20.0,
                            color: kTheTexts,
                          ),
                        ),
                      ),
                      (school.image == "public/img/defaultuser.png")
                          ? Image.asset(
                              'assets/images/profileSample.png',
                              width: MediaQuery.of(context).size.width * 0.35,
                            )
                          : Container(
                              width: MediaQuery.of(context).size.width * 0.5,
                              height: MediaQuery.of(context).size.width * 0.35,
                              padding: EdgeInsets.symmetric(horizontal: 30.0),
                              clipBehavior: Clip.antiAlias,
                              decoration:
                                  BoxDecoration(shape: BoxShape.rectangle),
                              child: Image.network(
                                'https://cdlprepapp.com/${school.image}',
                                errorBuilder: (context, a, b) {
                                  return Image.asset(
                                    'assets/images/profileSample.png',
                                    width: MediaQuery.of(context).size.width *
                                        0.35,
                                  );
                                },
                                loadingBuilder: (context, w, e) {
                                  if (e == null)
                                    return Container(
                                      width: double.maxFinite,
                                      clipBehavior: Clip.antiAlias,
                                      decoration:
                                          BoxDecoration(shape: BoxShape.circle),
                                      child: FittedBox(
                                        fit: BoxFit.cover,
                                        child: w,
                                      ),
                                    );
                                  else
                                    return Center(
                                      child: CircularProgressIndicator(
                                          color: kTheTexts),
                                    );
                                },
                                headers: {
                                  'Accept': '*/*',
                                  'Connection': 'keep-alive',
                                },
                              ),
                            ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.035),
                      Text(
                        //"School Name",
                        school.name,
                        textScaleFactor: 1.4,
                        style: TextStyle(color: kTheTexts),
                      ),
                      Divider(
                        color: kTheDivider.withOpacity(0.3),
                        thickness: 2,
                        indent: 15.0,
                        endIndent: 15.0,
                        height: 24.0,
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05),
                      ListTile(
                        onTap: () {
                          for (var i = 0; i < currentPage; i++) {
                            Navigator.of(context).pop();
                          }
                        },
                        leading: Icon(
                          Icons.home_rounded,
                          color: kTheTexts,
                        ),
                        title: Text(
                          "Home",
                          textScaleFactor: 1.2,
                          style: TextStyle(color: kTheTexts),
                        ),
                      ),
                      Divider(
                        color: kTheDivider.withOpacity(0.3),
                        thickness: 2,
                        indent: 15.0,
                        endIndent: 15.0,
                      ),
                      ListTile(
                        onTap: () =>
                            Navigator.of(context).pushNamed('/schoolProfile'),
                        leading: Icon(
                          Icons.account_circle_outlined,
                          color: kTheTexts,
                        ),
                        title: Text(
                          "Profile",
                          textScaleFactor: 1.2,
                          style: TextStyle(color: kTheTexts),
                        ),
                      ),
                      Divider(
                        color: kTheDivider.withOpacity(0.3),
                        thickness: 2,
                        indent: 15.0,
                        endIndent: 15.0,
                      ),
                      ListTile(
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pushNamed('/resetPassword');
                        },
                        leading: Icon(
                          Icons.vpn_key_outlined,
                          color: kTheTexts,
                        ),
                        title: Text(
                          "Change Password",
                          textScaleFactor: 1.2,
                          style: TextStyle(color: kTheTexts),
                        ),
                      ),
                      Divider(
                        color: kTheDivider.withOpacity(0.3),
                        thickness: 2,
                        indent: 15.0,
                        endIndent: 15.0,
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: ListTile(
                    onTap: () {
                      for (var i = 0; i < currentPage; i++) {
                        Navigator.of(context).pop();
                      }
                      confirmLogout();
                    },
                    leading: Icon(
                      Icons.logout,
                      color: kTheTexts,
                    ),
                    title: Text(
                      "Logout",
                      textScaleFactor: 1.2,
                      style: TextStyle(color: kTheTexts),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
