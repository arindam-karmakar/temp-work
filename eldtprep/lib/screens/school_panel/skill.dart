import 'package:eldtprep/api/api.dart';
import 'package:eldtprep/api/userPrefs.dart';
import 'package:eldtprep/colour_scheme.dart';
import 'package:eldtprep/models/userModel.dart';
import 'package:eldtprep/screens/school_panel/schoolDrawer.dart';
import 'package:eldtprep/screens/school_panel/studentDetails.dart';
import 'package:eldtprep/widgets/dashboardExtras.dart';
import 'package:eldtprep/widgets/studentCard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SkillReady extends StatefulWidget {
  SkillReady({Key? key}) : super(key: key);

  @override
  _SkillReadyState createState() => _SkillReadyState();
}

class _SkillReadyState extends State<SkillReady> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int lastSelected = 0;
  int lastStudent = 0;

  @override
  Widget build(BuildContext context) {
    CdlSchool cdlSchool = Provider.of<CdlSchoolProvider>(context).school;
    Future<List<CdlStudent>> getStudent() =>
        WebApi().getSkill(cdlSchool.schoolId);

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
                                "Skill Ready",
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
                flex: 12,
                child: FutureBuilder<List<CdlStudent>>(
                  future: getStudent(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
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
                                ? PressedCard(
                                    name: snapshot.data[index].name,
                                    phone: snapshot.data[index].phone,
                                    image: snapshot.data[index].image,
                                  )
                                : UnpressedCard(
                                    name: snapshot.data[index].name,
                                    phone: snapshot.data[index].phone,
                                    image: snapshot.data[index].image,
                                  ),
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
