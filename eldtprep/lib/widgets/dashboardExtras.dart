import 'package:eldtprep/colour_scheme.dart';
import 'package:flutter/material.dart';

class PressedButton extends StatelessWidget {
  final String text;
  final Widget icon;
  const PressedButton({
    Key? key,
    required this.icon,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 40.0),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/Rectangle 5.png'),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 10.0),
          Flexible(
            child: Center(
              child: Container(
                height: MediaQuery.of(context).size.width * 0.15,
                width: MediaQuery.of(context).size.width * 0.15,
                child: icon,
              ),
            ),
          ),
          Flexible(
            child: Center(
              child: Text(
                text,
                style: TextStyle(color: Colors.blue[900]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class IconPressedButton extends StatelessWidget {
  final String iconPath;
  const IconPressedButton({
    Key? key,
    required this.iconPath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(6.0),
      padding: EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/Rectangle 6.png'),
        ),
      ),
      child: Image.asset(
        iconPath,
        color: kTheButton,
      ),
    );
  }
}

class UnpressedButton extends StatelessWidget {
  final String text;
  final Widget icon;
  const UnpressedButton({
    Key? key,
    required this.icon,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/Rectangle 5 (1).png'),
        ),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 35.0),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/Rectangle 1.png'),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 10.0),
            Flexible(
              child: Center(
                child: Container(
                  height: MediaQuery.of(context).size.width * 0.15,
                  width: MediaQuery.of(context).size.width * 0.15,
                  child: icon,
                ),
              ),
            ),
            Flexible(
              child: Center(
                child: Text(
                  text,
                  style: TextStyle(color: Colors.blue[900]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class IconUnpressedButton extends StatelessWidget {
  final String iconPath;
  const IconUnpressedButton({
    Key? key,
    required this.iconPath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(6.0),
      padding: EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/Group 4.png'),
        ),
      ),
      child: Image.asset(
        iconPath,
        color: kTheButton,
      ),
    );
  }
}
