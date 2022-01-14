import 'package:cdl_prep/models/dataModels.dart';
import 'package:cdl_prep/screens/school_panel/driveTime.dart';
import 'package:cdl_prep/screens/school_panel/enroll.dart';
import 'package:cdl_prep/screens/school_panel/globalSearch.dart';
import 'package:cdl_prep/screens/school_panel/notifications.dart';
import 'package:cdl_prep/screens/school_panel/paymentStatus.dart';
import 'package:cdl_prep/screens/school_panel/preTrip.dart';
import 'package:cdl_prep/screens/school_panel/profile.dart';
import 'package:cdl_prep/screens/school_panel/road.dart';
import 'package:cdl_prep/screens/school_panel/schoolHome.dart';
import 'package:cdl_prep/screens/school_panel/signupSchool.dart';
import 'package:cdl_prep/screens/school_panel/skill.dart';
import 'package:cdl_prep/screens/school_panel/slots.dart';
import 'package:cdl_prep/screens/school_panel/studentDetails.dart';
import 'package:cdl_prep/screens/school_panel/testDate.dart';
import 'package:cdl_prep/screens/student_panel/beginExam.dart';
import 'package:cdl_prep/screens/student_panel/beginPractice.dart';
import 'package:cdl_prep/screens/login.dart';
import 'package:cdl_prep/screens/newPassword.dart';
import 'package:cdl_prep/screens/resetPassword.dart';
import 'package:cdl_prep/screens/student_panel/home.dart';
import 'package:cdl_prep/screens/student_panel/notifications.dart';
import 'package:cdl_prep/screens/student_panel/signupStudent.dart';
import 'package:flutter/material.dart';
import 'package:cdl_prep/colour_scheme.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    var arguments;
    if (settings.arguments != null)
      arguments = settings.arguments as ScreenArguments;

    switch (settings.name) {
      case '/studentDetail':
        return MaterialPageRoute(
            builder: (context) =>
                StudentDetails(currentStudent: arguments.content));

      case '/searchEnroll':
        return MaterialPageRoute(builder: (context) => SchoolSearch());

      case '/schoolNotification':
        return MaterialPageRoute(builder: (context) => SchoolNotification());

      case '/studentNotification':
        return MaterialPageRoute(builder: (context) => StudentNotification());

      case '/schoolDashboard':
        return MaterialPageRoute(builder: (context) => SchoolDashboard());

      case '/schoolProfile':
        return MaterialPageRoute(builder: (context) => SchoolProfile());

      case '/studentDashboard':
        return MaterialPageRoute(builder: (context) => Dashboard());

      case '/preTrip':
        return MaterialPageRoute(builder: (context) => PreTrip());

      case '/skill':
        return MaterialPageRoute(builder: (context) => SkillReady());

      case '/road':
        return MaterialPageRoute(builder: (context) => RoadReady());

      case '/slots':
        return MaterialPageRoute(builder: (context) => InitSlot());

      case '/driveTime':
        return MaterialPageRoute(builder: (context) => DriveTime());

      case '/testDate':
        return MaterialPageRoute(builder: (context) => TestDate());

      case '/payments':
        return MaterialPageRoute(builder: (context) => Payments());

      case '/schoolSignup':
        return MaterialPageRoute(builder: (context) => SchoolSignup());

      case '/studentSignup':
        return MaterialPageRoute(builder: (context) => StudentSignup());

      case '/enrollStudent':
        return MaterialPageRoute(builder: (context) => EnrollStudent());

      case '/handleLogin':
        return MaterialPageRoute(builder: (context) => LoginPage());

      case '/resetPassword':
        return MaterialPageRoute(builder: (context) => ResetPassword());

      case '/setNewPassword':
        return MaterialPageRoute(
            builder: (context) => NewPassword(phone: arguments.content));

      case '/beginExam':
        return MaterialPageRoute(builder: (context) => BeginExam());

      case '/beginPractice':
        return MaterialPageRoute(builder: (context) => BeginPractice());

      default:
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            backgroundColor: kPrimary,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Entered Wrong Route",
                    style: TextStyle(color: Colors.black),
                    textScaleFactor: 1.2,
                  ),
                  Text(
                    "Please go back",
                    style: TextStyle(color: Colors.blue[900]),
                  ),
                ],
              ),
            ),
          ),
        );
    }
  }
}
