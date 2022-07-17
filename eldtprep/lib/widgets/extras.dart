import 'package:eldtprep/colour_scheme.dart';
import 'package:flutter/material.dart';

Widget homeWaiting() => Container(
      height: double.maxFinite,
      width: double.maxFinite,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [kBlueWhite, kPrimary, kPrimary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      /*child: Center(
        child: CircularProgressIndicator(color: kTheTexts),
      ),*/
    );
