import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ourdoctor/global/global.dart';
import 'package:ourdoctor/global/local_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/pages/app_event.dart';

late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'ourdoctor', // id
  'High Importance Notifications',
  description: 'High Importance Notifications Description', // title
  importance: Importance.max,
);

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  initFcm();

  await showNotification(message.data);
}

// main.dart에서 실행
initFcm() async {
  await Firebase.initializeApp();

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final FirebaseMessaging messaging = FirebaseMessaging.instance;

  // 권한 및 채널 설정
  if (Platform.isIOS) {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus != AuthorizationStatus.authorized) {
      showToast("푸시 알림을 이용하기 위해서 알림권한을 허용해주세요.");
    }
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
  } else {
    await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);
  }

  // 토큰 얻기
  String token = (await messaging.getToken()) ?? "";
  print('token:' + token);
  // messaging.onTokenRefresh.listen((token) {
  //   // if (token == "") {
  //   //   token = token;
  //   //   LocalService.setToken(token);
  //   // }
  //   LocalService.setToken(token);
  //   print('token:' + token);
  // });
  LocalService.setToken(token);

  FirebaseMessaging.onMessage.listen(showFlutterNotification);

  // 백그라운드 리스너
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // 토픽설정
  // await FirebaseMessaging.instance.subscribeToTopic('udoctor');
}

void showFlutterNotification(RemoteMessage message) {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  if (notification != null && android != null && !kIsWeb) { // 웹이 아니면서 안드로이드이고, 알림이 있는경우
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          // TODO add a proper drawable resource to android, for now using
          //      one that already exists in example app.
          icon: '@mipmap/ic_launcher',
        ),
      ),
    );
  }
}

// main activity에서 설정
Future<void> setupFcmListener(void Function(Map<String, dynamic> data) onReceive, void Function(Map<String, dynamic> data) onClick) async {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    //RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    Map<String, dynamic> data = message.data;

    // If `onMessage` is triggered with a notification, construct our own
    // local notification to show to users using the created channel.
    eventBus.fire(ReceivePushEvent());
    await showNotification(data);
    onReceive(message.data);
  });

  // Get any messages which caused the application to open from
  // a terminated state.
  RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

  // If the message also contains a data property with a "type" of "chat",
  // navigate to a chat screen
  if (initialMessage != null) {
    onClick(initialMessage.data);
  }

  // Also handle any interaction when the app is in the background via a
  // Stream listener
  FirebaseMessaging.onMessageOpenedApp.listen((message) => {onClick(message.data)});

  initLocalNotification(onClick);
}

initLocalNotification(void Function(Map<String, dynamic> data) onClick) async {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

  /// Note: permissions aren't requested here just to demonstrate that can be
  /// done later
  final IOSInitializationSettings initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      onDidReceiveLocalNotification: (
        int id,
        String? title,
        String? body,
        String? payload,
      ) async {
        // didReceiveLocalNotificationSubject.add(
        //   ReceivedNotification(
        //     id: id,
        //     title: title,
        //     body: body,
        //     payload: payload,
        //   ),
        // );
      });
  const MacOSInitializationSettings initializationSettingsMacOS = MacOSInitializationSettings(
    requestAlertPermission: false,
    requestBadgePermission: false,
    requestSoundPermission: false,
  );
  final LinuxInitializationSettings initializationSettingsLinux = LinuxInitializationSettings(
    defaultActionName: 'Open notification',
    defaultIcon: AssetsLinuxIcon('assets/app_icon.png'),
  );
  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
    macOS: initializationSettingsMacOS,
    linux: initializationSettingsLinux,
  );

  // when click notification without launch app
  await flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: (String? payload) async {
    if (payload != null) {
      //debugPrint('notification payload: $payload');
      Map<String, dynamic> data = json.decode(payload);
      onClick(data);
    }
    // selectedNotificationPayload = payload;
    // selectNotificationSubject.add(payload);
  });

  // When launch app by click notification
  var details = await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  if (details != null && details.didNotificationLaunchApp) {
    print(details.payload);
    if (details.payload != null) {
      Map<String, dynamic> data = json.decode(details.payload!);
      onClick(data);
    }
  }
}

showNotification(Map<String, dynamic> data) async {
  if (Platform.isIOS) {
    return;
  }
  if (data.isEmpty){
    return;
  }
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(channel.id, channel.name,
          channelDescription: channel.description,
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker');
  const IOSNotificationDetails iOSPlatformChannelSpecifics =
      IOSNotificationDetails(presentSound: true);
  NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(0, data["title"], data["body"], platformChannelSpecifics, payload: json.encode(data));
}

hideNotification(bool isHide) async {
  if (Platform.isIOS) {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: isHide ? false : true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
  }
}

closeFcm() async {
  await FirebaseMessaging.instance.unsubscribeFromTopic('udoctor');
}
