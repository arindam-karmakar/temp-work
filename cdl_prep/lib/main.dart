import 'package:cdl_prep/api/api.dart';
import 'package:cdl_prep/api/userPrefs.dart';
import 'package:cdl_prep/colour_scheme.dart';
import 'package:cdl_prep/logic/resume_practice_logic.dart';
import 'package:cdl_prep/models/dataModels.dart';
import 'package:cdl_prep/models/userModel.dart';
import 'package:cdl_prep/coreModules.dart';
import 'package:cdl_prep/routes.dart';
import 'package:cdl_prep/screens/login.dart';
import 'package:cdl_prep/screens/school_panel/schoolHome.dart';
import 'package:cdl_prep/screens/student_panel/home.dart';
import 'package:cdl_prep/services/notification_service.dart';
import 'package:cdl_prep/widgets/extras.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:is_first_run/is_first_run.dart';
import 'package:provider/provider.dart';
import 'dart:io';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(handleBackgroundEvents);

  if (Platform.isAndroid)
    await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);

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
    getNotificationPermissions();
    initNotif();
    enableForegroundNotif();
  }

  void onDidReceiveLocalNotification(
      int? id, String? title, String? body, String? payload) async {}
  void onSelectNotification(String? data) async {}

  void initNotif() {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
            onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  Future<void> getNotificationPermissions() async {
    if (await IsFirstRun.isFirstRun()) {
      FirebaseMessaging messaging = FirebaseMessaging.instance;

      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      debugPrint('User granted permission: ${settings.authorizationStatus}');
    }
  }

  Future<void> enableForegroundNotif() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    FirebaseMessaging.onMessage.listen((message) {
      Fluttertoast.showToast(msg: "received ${message.notification?.body}");
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              icon: android.smallIcon,
              enableVibration: true,
              playSound: true,
              importance: channel.importance,
              priority: Priority.max,
              visibility: NotificationVisibility.public,
            ),
            iOS: IOSNotificationDetails(),
          ),
          payload: "",
        );
      }
    });
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
        ChangeNotifierProvider(create: (_) => ResumePracticeProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        onGenerateRoute: Routes.generateRoute,
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            titleSpacing: 5.0,
          ),
          canvasColor: Colors.white,
          fontFamily: 'Amazon_Ember',
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
              .copyWith(secondary: kTheTexts),
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

                        return FutureBuilder<Map<String, dynamic>>(
                          future: Progress().getLast(),
                          builder: (context, lastData) {
                            if (lastData.hasData) {
                              return FutureBuilder<List>(
                                future: Progress().getAll(),
                                builder: (BuildContext context,
                                    AsyncSnapshot getAllData) {
                                  if (getAllData.hasData) {
                                    return FutureBuilder<List>(
                                      future:
                                          Progress().getAllQuestionsAttempted(),
                                      builder:
                                          (context, categoryWiseQuestionsDone) {
                                        if (categoryWiseQuestionsDone.hasData) {
                                          return SetDashboard(
                                            lastCategory:
                                                (lastData.data!['status'] ==
                                                        'ok')
                                                    ? lastData.data!['data']
                                                    : "null",
                                            allLast: getAllData.data,
                                            allCategoryWiseQuestionsDone:
                                                categoryWiseQuestionsDone.data!,
                                          );
                                        } else {
                                          return homeWaiting();
                                        }
                                      },
                                    );
                                  } else
                                    return homeWaiting();
                                },
                              );
                            } else
                              return homeWaiting();
                          },
                        );
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
