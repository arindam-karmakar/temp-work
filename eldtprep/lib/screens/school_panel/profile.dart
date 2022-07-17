import 'package:eldtprep/api/api.dart';
import 'package:eldtprep/api/userPrefs.dart';
import 'package:eldtprep/colour_scheme.dart';
import 'package:eldtprep/models/userModel.dart';
import 'package:eldtprep/coreModules.dart';
import 'package:eldtprep/screens/school_panel/editProfile.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SchoolProfile extends StatefulWidget {
  SchoolProfile({Key? key}) : super(key: key);

  @override
  _SchoolProfileState createState() => _SchoolProfileState();
}

class _SchoolProfileState extends State<SchoolProfile> {
  bool _edit = false;

  ImagePicker imagePicker = new ImagePicker();
  var _image;
  String imageName = "";

  @override
  Widget build(BuildContext context) {
    //CdlSchool _cdlSchool = Provider.of<CdlSchoolProvider>(context).school;
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);

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
      body: Consumer<CdlSchoolProvider>(
        builder: (context, data, wid) {
          CdlSchool _cdlSchool = data.school;

          return Container(
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
                    flex: 2,
                    child: Container(
                      height: double.maxFinite,
                      width: double.maxFinite,
                      color: Colors.transparent,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Spacer(),
                          Center(
                            child: Text(
                              "Profile",
                              textScaleFactor: 1.5,
                              style: TextStyle(color: Colors.blue[900]),
                            ),
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
                    flex: 3,
                    child: Stack(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          child: (_cdlSchool.image ==
                                  "public/img/defaultuser.png")
                              ? Image.asset(
                                  'assets/images/profileSample.png',
                                  width:
                                      MediaQuery.of(context).size.width * 0.35,
                                )
                              : Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  height:
                                      MediaQuery.of(context).size.width * 0.35,
                                  clipBehavior: Clip.antiAlias,
                                  decoration:
                                      BoxDecoration(shape: BoxShape.rectangle),
                                  child: Image.network(
                                    'https://cdlprepapp.com/${_cdlSchool.image}',
                                    errorBuilder: (context, a, b) {
                                      return Image.asset(
                                        'assets/images/profileSample.png',
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.35,
                                      );
                                    },
                                    loadingBuilder: (context, w, e) {
                                      if (e == null)
                                        return Container(
                                          width: double.maxFinite,
                                          clipBehavior: Clip.antiAlias,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle),
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
                        ),
                        (_edit)
                            ? Center(
                                child: GestureDetector(
                                  onTap: () async {
                                    var temp = await imagePicker.pickImage(
                                      source: ImageSource.gallery,
                                    );

                                    setState(() {
                                      _image = temp;
                                      imageName = temp!.name;
                                      _edit = false;
                                    });

                                    if (_image != null) {
                                      Overlay.of(context)!.insert(overlayEntry);

                                      Map<String, String> report =
                                          await authProvider.profilePic(
                                              _cdlSchool.schoolId.toString(),
                                              _image.path);

                                      overlayEntry.remove();

                                      if (report['responseMessage'] ==
                                          "SUCCESS") {
                                        Fluttertoast.showToast(
                                          msg: "Profile Pic updated!",
                                          gravity: ToastGravity.BOTTOM,
                                          backgroundColor: kTheTexts,
                                          textColor: Colors.white,
                                        );
                                        MyApp.restartApp(context);
                                      } else
                                        Fluttertoast.showToast(
                                          msg: "Update failed!",
                                          gravity: ToastGravity.BOTTOM,
                                          backgroundColor: kTheTexts,
                                          textColor: Colors.white,
                                        );
                                    } else
                                      Fluttertoast.showToast(
                                        msg: "Please select an image",
                                        gravity: ToastGravity.BOTTOM,
                                        backgroundColor: kTheTexts,
                                        textColor: Colors.white,
                                      );
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: MediaQuery.of(context).size.width *
                                        0.35,
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.3),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.photo_size_select_actual_outlined,
                                      color: Colors.white,
                                      size: 30.0,
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: EdgeInsets.only(right: 15.0, bottom: 15.0),
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  _edit = true;
                                });
                              },
                              icon: ImageIcon(
                                AssetImage('assets/images/editProfile.png'),
                                color: kTheTexts,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 8,
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 15.0),
                      child: (_edit)
                          ? EditProfile(school: _cdlSchool)
                          : ViewProfile(cdlSchool: _cdlSchool),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class ViewProfile extends StatefulWidget {
  final CdlSchool cdlSchool;
  ViewProfile({
    Key? key,
    required this.cdlSchool,
  }) : super(key: key);

  @override
  _ViewProfileState createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  @override
  Widget build(BuildContext context) {
    CdlSchool _cdlSchool = widget.cdlSchool;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(),
        Text(
          "School Name:  ${_cdlSchool.name}",
          textScaleFactor: 1.3,
          textAlign: TextAlign.left,
          style: TextStyle(color: kTheTexts),
        ),
        Divider(
          color: kTheDivider.withOpacity(0.3),
          thickness: 2,
          height: MediaQuery.of(context).size.height * 0.04,
        ),
        Text(
          "Phone:  ${_cdlSchool.phone}",
          textScaleFactor: 1.3,
          textAlign: TextAlign.left,
          style: TextStyle(color: kTheTexts),
        ),
        Divider(
          color: kTheDivider.withOpacity(0.3),
          thickness: 2,
          height: MediaQuery.of(context).size.height * 0.04,
        ),
        Text(
          "Full Address:  ${_cdlSchool.address.replaceAll(RegExp(r'%2C'), ',')}",
          textScaleFactor: 1.3,
          textAlign: TextAlign.left,
          style: TextStyle(color: kTheTexts),
        ),
        Divider(
          color: kTheDivider.withOpacity(0.3),
          thickness: 2,
          height: MediaQuery.of(context).size.height * 0.04,
        ),
        Text(
          "City:  ${_cdlSchool.city}",
          textScaleFactor: 1.3,
          textAlign: TextAlign.left,
          style: TextStyle(color: kTheTexts),
        ),
        Divider(
          color: kTheDivider.withOpacity(0.3),
          thickness: 2,
          height: MediaQuery.of(context).size.height * 0.04,
        ),
        Text(
          "State:  ${_cdlSchool.state}",
          textScaleFactor: 1.3,
          textAlign: TextAlign.left,
          style: TextStyle(color: kTheTexts),
        ),
        Divider(
          color: kTheDivider.withOpacity(0.3),
          thickness: 2,
          height: MediaQuery.of(context).size.height * 0.04,
        ),
        Text(
          "Country:  ${_cdlSchool.country}",
          textScaleFactor: 1.3,
          textAlign: TextAlign.left,
          style: TextStyle(color: kTheTexts),
        ),
        Divider(
          color: kTheDivider.withOpacity(0.3),
          thickness: 2,
          height: MediaQuery.of(context).size.height * 0.04,
        ),
        Text(
          "Slot time:  ${_cdlSchool.slotTime} mins",
          textScaleFactor: 1.3,
          textAlign: TextAlign.left,
          style: TextStyle(color: kTheTexts),
        ),
        Divider(
          color: kTheDivider.withOpacity(0.3),
          thickness: 2,
          height: MediaQuery.of(context).size.height * 0.04,
        ),
        Text(
          "Driving Time from:  ${_cdlSchool.schoolTimeFrom.replaceAll(RegExp(r'%3A'), ' : ')}",
          textScaleFactor: 1.3,
          textAlign: TextAlign.left,
          style: TextStyle(color: kTheTexts),
        ),
        Divider(
          color: kTheDivider.withOpacity(0.3),
          thickness: 2,
          height: MediaQuery.of(context).size.height * 0.04,
        ),
        Text(
          "Driving Time to:  ${_cdlSchool.schoolTimeTo.replaceAll(RegExp(r'%3A'), ' : ')}",
          textScaleFactor: 1.3,
          textAlign: TextAlign.left,
          style: TextStyle(color: kTheTexts),
        ),
        Divider(
          color: kTheDivider.withOpacity(0.3),
          thickness: 2,
          height: MediaQuery.of(context).size.height * 0.04,
        ),
      ],
    );
  }
}
