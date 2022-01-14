import 'package:cdl_prep/api/api.dart';
import 'package:cdl_prep/colour_scheme.dart';
import 'package:cdl_prep/screens/student_panel/practice.dart';
import 'package:cdl_prep/screens/website.dart';
import 'package:cdl_prep/widgets/dashboardExtras.dart';
import 'package:dropdown_below/dropdown_below.dart';
import 'package:flutter/material.dart';

class BeginPractice extends StatefulWidget {
  BeginPractice({Key? key}) : super(key: key);

  @override
  _BeginPracticeState createState() => _BeginPracticeState();
}

class _BeginPracticeState extends State<BeginPractice> {
  WebApi webApi = new WebApi();
  Future<dynamic> getCat() => WebApi().getCategories();

  var lastSelected = 0;

  var selectedCategory;
  int cat = 0;

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<int>> buildItems(AsyncSnapshot snapshot) {
      List<DropdownMenuItem<int>> items = [];

      for (var i = 0; i < snapshot.data.length; i++)
        items.add(
          DropdownMenuItem<int>(
            value: snapshot.data[i].categoryId,
            child: Text(snapshot.data[i].name),
          ),
        );
      return items;
    }

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
                flex: 2,
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
                                "Begin Practice",
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
                flex: 9,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 15.0),
                  child: Column(
                    children: [
                      Row(),
                      FutureBuilder(
                        future: getCat(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData)
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                DropdownBelow<int?>(
                                  boxHeight: 40,
                                  boxWidth:
                                      MediaQuery.of(context).size.width * 0.85,
                                  itemWidth:
                                      MediaQuery.of(context).size.width * 0.55,
                                  hint: Text("Choose Category"),
                                  boxTextstyle: TextStyle(
                                    color: kTheTexts,
                                    fontFamily: 'Amazon_Ember',
                                  ),
                                  itemTextstyle: TextStyle(
                                    color: kTheTexts,
                                    fontFamily: 'Amazon_Ember',
                                  ),
                                  icon: Icon(
                                    Icons.arrow_drop_down_rounded,
                                    color: kTheTexts,
                                    size: 28.0,
                                  ),
                                  items: buildItems(snapshot),
                                  value: selectedCategory,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedCategory = value;
                                      cat = value as int;
                                    });
                                  },
                                ),
                                Divider(
                                  color: kTheTexts,
                                  thickness: 1.1,
                                  indent: 20.0,
                                  endIndent: 20.0,
                                ),
                              ],
                            );
                          else
                            return ConstrainedBox(
                              constraints: BoxConstraints(
                                maxHeight: 40,
                                maxWidth: 40,
                              ),
                              child:
                                  CircularProgressIndicator(color: kTheTexts),
                            );
                        },
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.12),
                      (1 <= cat && cat <= 8)
                          ? GestureDetector(
                              onTap: () =>
                                  Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      PracticeScreen(initialCategory: cat),
                                ),
                              ),
                              child: Container(
                                height: 50.0,
                                width: 150.0,
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
                                    "Start",
                                    textScaleFactor: 1.2,
                                    style: TextStyle(
                                      color: kTheTexts,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  height: double.maxFinite,
                  width: double.maxFinite,
                  color: Colors.transparent,
                  padding: EdgeInsets.all(15.0),
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
                              () {},
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
