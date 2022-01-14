import 'package:cdl_prep/api/api.dart';
import 'package:cdl_prep/api/userPrefs.dart';
import 'package:cdl_prep/models/dataModels.dart';
import 'package:cdl_prep/models/userModel.dart';
import 'package:cdl_prep/coreModules.dart';
import 'package:cdl_prep/routes.dart';
import 'package:cdl_prep/screens/login.dart';
import 'package:cdl_prep/screens/school_panel/schoolHome.dart';
import 'package:cdl_prep/screens/student_panel/home.dart';
import 'package:cdl_prep/services/notification_service.dart';
import 'package:cdl_prep/widgets/extras.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'dart:io';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // FirebaseMessaging.onBackgroundMessage(handleBackgroundEvents);

  // await Firebase.initializeApp();

  // if (Platform.isAndroid)
  //   await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);

  runApp(MyApp(startPoint: CDLApp()));
}

class CDLApp extends StatefulWidget {
  CDLApp({Key? key}) : super(key: key);

  @override
  _CDLAppState createState() => _CDLAppState();
}

class _CDLAppState extends State<CDLApp> {
  @override
  void initState() {
    super.initState();
    /* FirebaseMessaging.onMessage.listen((event) =>
        Fluttertoast.showToast(msg: event.notification?.body as String)); */
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    Future<String> savedLastUserType() => UserPreferences().getLastUserType();
    Future<dynamic> getCurrentUser() => UserPreferences().getUser();
    Future<dynamic> getCurrentSchool() => UserPreferences().getSchool();
    //CdlUserProvider cdlUserProvider = new CdlUserProvider();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CdlUserProvider()),
        ChangeNotifierProvider(create: (_) => CdlSchoolProvider()),
        ChangeNotifierProvider(create: (_) => LocationProvider()),
        ChangeNotifierProvider(create: (_) => GlobalSearchProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        onGenerateRoute: Routes.generateRoute,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Amazon_Ember',
        ),
        home: FutureBuilder<String>(
          future: savedLastUserType(),
          builder: (context, userType) {
            if (userType.hasData) {
              return FutureBuilder(
                future: (userType.data.toString() == "student")
                    ? getCurrentUser()
                    : getCurrentSchool(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.name == "null" ||
                        snapshot.data.name == "name") {
                      return LoginPage();
                    } else {
                      if (userType.data.toString() == "student") {
                        Provider.of<CdlUserProvider>(context, listen: false)
                            .setUser(snapshot.data);

                        return Dashboard();
                      } else {
                        Provider.of<CdlSchoolProvider>(context)
                            .setSchool(snapshot.data);

                        return SchoolDashboard();
                      }
                    }
                  } else {
                    if (snapshot.connectionState == ConnectionState.done)
                      return LoginPage();
                    else
                      return homeWaiting();
                  }
                },
              );
            } else
              return homeWaiting();
          },
        ),
      ),
    );
  }
}
