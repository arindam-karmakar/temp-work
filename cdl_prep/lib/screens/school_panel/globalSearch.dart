import 'package:cdl_prep/api/api.dart';
import 'package:cdl_prep/api/userPrefs.dart';
import 'package:cdl_prep/colour_scheme.dart';
import 'package:cdl_prep/models/dataModels.dart';
import 'package:cdl_prep/models/userModel.dart';
import 'package:cdl_prep/screens/school_panel/studentDetails.dart';
import 'package:cdl_prep/widgets/studentCard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SchoolSearch extends StatefulWidget {
  SchoolSearch({Key? key}) : super(key: key);

  @override
  _SchoolSearchState createState() => _SchoolSearchState();
}

class _SchoolSearchState extends State<SchoolSearch> {
  TextEditingController globalSearchController = TextEditingController();

  List<CdlStudent> listOfEnroll = [];
  int lastStudent = 0;

  bool connectionActive = false;

  GlobalSearchProvider globalSearchProvider = new GlobalSearchProvider();

  @override
  Widget build(BuildContext context) {
    CdlSchool cdlSchool = Provider.of<CdlSchoolProvider>(context).school;

    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Center(
                          child: BackButton(color: kTheTexts),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 3.0,
                            bottom: 3.0,
                            left: 3.0,
                            right: 20.0,
                          ),
                          child: Center(
                            child: TextFormField(
                              controller: globalSearchController,
                              autofocus: true,
                              maxLines: 1,
                              cursorColor: kTheTexts,
                              cursorWidth: 2.0,
                              cursorRadius: Radius.circular(50.0),
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(
                                    color: kTheTexts,
                                    width: 1.5,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(
                                    color: kTheTexts,
                                    width: 1.5,
                                  ),
                                ),
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: kTheTexts,
                                ),
                                hintText: "   Search enrolments",
                              ),
                              style: TextStyle(color: kTheTexts),
                              onChanged: (input) async {
                                setState(() {
                                  listOfEnroll.clear();
                                  connectionActive = true;
                                });

                                if (globalSearchController.text
                                    .contains(RegExp(r'[0-9]{10}')))
                                  listOfEnroll = await globalSearchProvider
                                      .fetchNumberData(
                                    globalSearchController.text,
                                    cdlSchool.schoolId.toString(),
                                  );
                                else if (globalSearchController.text.contains(
                                    RegExp(r'pre', caseSensitive: false)))
                                  listOfEnroll = await globalSearchProvider
                                      .getPreTripReady(cdlSchool.schoolId);
                                else if (globalSearchController.text.contains(
                                    RegExp(r'skill', caseSensitive: false)))
                                  listOfEnroll = await globalSearchProvider
                                      .getSkillReady(cdlSchool.schoolId);
                                else if (globalSearchController.text.contains(
                                    RegExp(r'road', caseSensitive: false)))
                                  listOfEnroll = await globalSearchProvider
                                      .getRoadReady(cdlSchool.schoolId);
                                else
                                  listOfEnroll =
                                      await globalSearchProvider.fetchNameData(
                                    globalSearchController.text,
                                    cdlSchool.schoolId.toString(),
                                  );

                                setState(() {
                                  connectionActive = false;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 17,
                child: Consumer<GlobalSearchProvider>(
                  builder: (context, data, newWidget) {
                    if (listOfEnroll.isNotEmpty)
                      return ListView.builder(
                        padding: EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal: 15.0,
                        ),
                        itemCount: listOfEnroll.length,
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
                                        currentStudent: listOfEnroll[index],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            child: (lastStudent == index + 1)
                                ? PressedCard(
                                    name: listOfEnroll[index].name,
                                    phone: listOfEnroll[index].phone,
                                    image: listOfEnroll[index].image,
                                  )
                                : UnpressedCard(
                                    name: listOfEnroll[index].name,
                                    phone: listOfEnroll[index].phone,
                                    image: listOfEnroll[index].image,
                                  ),
                          );
                        },
                      );
                    else
                      return Center(
                        child: (connectionActive)
                            ? Container(
                                height: 40.0,
                                width: 40.0,
                                child:
                                    CircularProgressIndicator(color: kTheTexts),
                              )
                            : Text(
                                "Enrolments will appear here ...",
                                textScaleFactor: 1.2,
                                style: TextStyle(color: kTheTexts),
                              ),
                      );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
