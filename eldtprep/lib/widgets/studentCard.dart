import 'package:eldtprep/api/api.dart';
import 'package:eldtprep/colour_scheme.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<http.Response> profile(String input) => WebApi().getProfilePic(input);

class AboutCard extends StatelessWidget {
  final String title, content;

  const AboutCard({
    Key? key,
    required this.title,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 7.5,
        right: 7.5,
        bottom: 15,
        top: 7.5,
      ),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/Frame 20.png'),
        ),
      ),
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                title,
                textScaleFactor: 1.1,
                textAlign: TextAlign.center,
                style: TextStyle(color: kTheTexts),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                content,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UnpressedCard extends StatelessWidget {
  final String name, phone, image;

  UnpressedCard({
    Key? key,
    required this.name,
    required this.phone,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: MediaQuery.of(context).size.width * 0.23,
      margin: EdgeInsets.symmetric(vertical: 5.0),
      padding: EdgeInsets.only(bottom: 10.0),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/Rectangle 18.png'),
          fit: BoxFit.contain,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Container(
              margin: EdgeInsets.only(left: 7.0, top: 7.0),
              padding: EdgeInsets.only(
                bottom: 15.0,
                left: 7.0,
                right: 7.0,
                top: 7.0,
              ),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/Rectangle 28.png'),
                  fit: BoxFit.contain,
                ),
              ),
              child: Image.network(
                'https://cdlprepapp.com/$image',
                loadingBuilder: (context, w, e) {
                  if (e == null)
                    return Container(
                      height: double.maxFinite,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(shape: BoxShape.circle),
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: w,
                      ),
                    );
                  else
                    return Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FittedBox(
                        child: CircularProgressIndicator(color: kTheTexts),
                      ),
                    );
                },
                headers: {
                  'Accept': '*/*',
                  'Connection': 'keep-alive',
                },
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Padding(
              padding: EdgeInsets.only(left: 5.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Text(
                      name,
                      textScaleFactor: 1.1,
                      style: TextStyle(color: kTheTexts),
                    ),
                  ),
                  Flexible(
                    child: Text(
                      phone,
                      textScaleFactor: 1.1,
                      style: TextStyle(color: kTheTexts),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Icon(
              Icons.arrow_forward_ios_rounded,
              size: 18.0,
            ),
          ),
        ],
      ),
    );
  }
}

class PressedCard extends StatelessWidget {
  final String name, phone, image;

  PressedCard({
    Key? key,
    required this.name,
    required this.phone,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: MediaQuery.of(context).size.width * 0.23,
      margin: EdgeInsets.symmetric(vertical: 5.0),
      padding: EdgeInsets.only(top: 8.0),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/Rectangle 18 (1).png'),
          fit: BoxFit.contain,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Container(
              margin: EdgeInsets.only(left: 7.0, top: 7.0),
              padding: EdgeInsets.only(
                bottom: 15.0,
                left: 7.0,
                right: 7.0,
                top: 7.0,
              ),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/Rectangle 28.png'),
                  fit: BoxFit.contain,
                ),
              ),
              child: Image.network(
                'https://cdlprepapp.com/$image',
                loadingBuilder: (context, w, e) {
                  if (e == null)
                    return Container(
                      height: double.maxFinite,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(shape: BoxShape.circle),
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: w,
                      ),
                    );
                  else
                    return Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FittedBox(
                        child: CircularProgressIndicator(color: kTheTexts),
                      ),
                    );
                },
                headers: {
                  'Accept': '*/*',
                  'Connection': 'keep-alive',
                },
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Padding(
              padding: EdgeInsets.only(left: 5.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Text(
                      name,
                      textScaleFactor: 1.1,
                      style: TextStyle(color: kTheTexts),
                    ),
                  ),
                  Flexible(
                    child: Text(
                      phone,
                      textScaleFactor: 1.1,
                      style: TextStyle(color: kTheTexts),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Icon(
              Icons.arrow_forward_ios_rounded,
              size: 18.0,
            ),
          ),
        ],
      ),
    );
  }
}

class UnpressedCardWithText extends StatelessWidget {
  final String name, phone, image;
  final Text inText;

  UnpressedCardWithText({
    Key? key,
    required this.name,
    required this.phone,
    required this.image,
    required this.inText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: MediaQuery.of(context).size.width * 0.23,
      margin: EdgeInsets.symmetric(vertical: 5.0),
      padding: EdgeInsets.only(bottom: 10.0),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/Rectangle 18.png'),
          fit: BoxFit.contain,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Container(
              margin: EdgeInsets.only(left: 7.0, top: 7.0),
              padding: EdgeInsets.only(
                bottom: 15.0,
                left: 7.0,
                right: 7.0,
                top: 7.0,
              ),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/Rectangle 28.png'),
                  fit: BoxFit.contain,
                ),
              ),
              child: Image.network(
                'https://cdlprepapp.com/$image',
                loadingBuilder: (context, w, e) {
                  if (e == null)
                    return Container(
                      height: double.maxFinite,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(shape: BoxShape.circle),
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: w,
                      ),
                    );
                  else
                    return Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FittedBox(
                        child: CircularProgressIndicator(color: kTheTexts),
                      ),
                    );
                },
                headers: {
                  'Accept': '*/*',
                  'Connection': 'keep-alive',
                },
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: EdgeInsets.only(left: 5.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Text(
                      name,
                      textScaleFactor: 1.1,
                      style: TextStyle(color: kTheTexts),
                    ),
                  ),
                  Flexible(
                    child: Text(
                      phone,
                      textScaleFactor: 1.1,
                      style: TextStyle(color: kTheTexts),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 15.0),
                child: inText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PressedCardWithText extends StatelessWidget {
  final String name, phone, image;
  final Text inText;

  PressedCardWithText({
    Key? key,
    required this.name,
    required this.phone,
    required this.image,
    required this.inText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: MediaQuery.of(context).size.width * 0.23,
      margin: EdgeInsets.symmetric(vertical: 5.0),
      padding: EdgeInsets.only(top: 8.0),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/Rectangle 18 (1).png'),
          fit: BoxFit.contain,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Container(
              margin: EdgeInsets.only(left: 7.0, top: 7.0),
              padding: EdgeInsets.only(
                bottom: 15.0,
                left: 7.0,
                right: 7.0,
                top: 7.0,
              ),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/Rectangle 28.png'),
                  fit: BoxFit.contain,
                ),
              ),
              child: Image.network(
                'https://cdlprepapp.com/$image',
                loadingBuilder: (context, w, e) {
                  if (e == null)
                    return Container(
                      height: double.maxFinite,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(shape: BoxShape.circle),
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: w,
                      ),
                    );
                  else
                    return Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FittedBox(
                        child: CircularProgressIndicator(color: kTheTexts),
                      ),
                    );
                },
                headers: {
                  'Accept': '*/*',
                  'Connection': 'keep-alive',
                },
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: EdgeInsets.only(left: 5.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Text(
                      name,
                      textScaleFactor: 1.1,
                      style: TextStyle(color: kTheTexts),
                    ),
                  ),
                  Flexible(
                    child: Text(
                      phone,
                      textScaleFactor: 1.1,
                      style: TextStyle(color: kTheTexts),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 15.0),
                child: inText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
