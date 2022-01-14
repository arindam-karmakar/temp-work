import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/* Future<void> handleBackgroundEvents(RemoteMessage? message) async {
  //await Firebase.initializeApp();

  debugPrint('Handling a background process!');

  if (message != null) debugPrint(message.data.toString());
} */




/*final CDLNotificationService notificationService =
      new CDLNotificationService();*/
  /*late NotificationSettings settings;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  configureNotification() async {
    FirebaseMessaging msgInstance = FirebaseMessaging.instance;

    NotificationSettings notificationSettings =
        await msgInstance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    await msgInstance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      'This channel is used for important notifications.',
      importance: Importance.max,
      enableVibration: true,
      playSound: true,
      showBadge: true,
      enableLights: true,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    setState(() {
      settings = notificationSettings;
    });
  }*/









  /*FirebaseMessaging.onMessage.listen((event) async {
      /*
      AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails(
        'high_importance_channel',
        'High Importance Notifications',
        'This channel is used for important notifications.',
        importance: Importance.max,
        priority: Priority.max,
        enableVibration: true,
        playSound: true,
        enableLights: true,
        showWhen: true,
        channelShowBadge: true,
      );

      IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      MacOSNotificationDetails macOSNotificationDetails =
          MacOSNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
        iOS: iosNotificationDetails,
        macOS: macOSNotificationDetails,
      );

      FlutterLocalNotificationsPlugin().show(
        DateTime.now().millisecondsSinceEpoch ~/ 1000,
        event.notification!.title,
        event.notification!.body,
        notificationDetails,
      );*/
      Fluttertoast.showToast(msg: event.notification!.body as String);
    });
    //configureNotification();*/
