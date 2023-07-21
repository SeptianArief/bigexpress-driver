import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:bigexpress_driver/cubits/cubits.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:bigexpress_driver/models/models.dart';
import 'package:bigexpress_driver/pages/pages.dart';
import 'package:bigexpress_driver/services/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
// import 'package:workmanager/workmanager.dart';

final androidConfig = FlutterBackgroundAndroidConfig(
  notificationTitle: "flutter_background example app",
  notificationText:
      "Background notification for keeping the example app running in the background",
  notificationImportance: AndroidNotificationImportance.Default,

  notificationIcon: AndroidResource(
      name: 'background_icon',
      defType: 'drawable'), // Default is ic_launcher from folder mipmap
);

Future<void> _messageHandler(RemoteMessage message) async {
  final player = AudioPlayer();

  player.setAsset('assets/sound/notification_order.mp3');
  player.play();
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

// void callbackDispatcher() {
//   Workmanager().executeTask((task, inputData) async {
//     final storage = new FlutterSecureStorage();
//     String? value = await storage.read(key: 'id_driver');

//     if (value != null) {
//       Position myPosition = await Geolocator.getCurrentPosition();
//       AuthService.updateLocation(
//           lat: myPosition.latitude.toString(),
//           lon: myPosition.longitude.toString(),
//           id: value);
//     }
//     return Future.value(true);
//   });
// }

void backgroundServiceCustom() async {
  // final storage = new FlutterSecureStorage();
  // String? value = await storage.read(key: 'id_driver');

  // print('valud : ' + value.toString());

  // if (value != null) {
  //   Position myPosition = await Geolocator.getCurrentPosition();

  //   print('custom background alamar');
  //   AuthService.updateLocation(
  //       lat: myPosition.latitude.toString(),
  //       lon: myPosition.longitude.toString(),
  //       id: value);
  // }
}

void main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  // await initializeService();
  await Firebase.initializeApp();
  await AndroidAlarmManager.initialize();

  FirebaseMessaging.onBackgroundMessage(_messageHandler);

  //background service
  // Workmanager().initialize(
  //     callbackDispatcher, // The top level function, aka callbackDispatcher
  //     isInDebugMode:
  //         true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
  //     );
  // Workmanager().registerPeriodicTask("task-identifier", "simpleTask");

  runApp(MultiBlocProvider(providers: [
    BlocProvider<UserCubit>(
      create: (context) => UserCubit(),
    ),
    BlocProvider<MasterCubit>(
      create: (context) => MasterCubit(),
    ),
    BlocProvider<TopupCubit>(
      create: (context) => TopupCubit(),
    ),
  ], child: const MyApp()));
  final int helloAlarmID = 0;
  await AndroidAlarmManager.periodic(
      const Duration(minutes: 1), helloAlarmID, backgroundServiceCustom);
}

// Future<void> initializeService() async {
//   final service = FlutterBackgroundService();
//   await service.configure(
//     androidConfiguration: AndroidConfiguration(
//       // this will executed when app is in foreground or background in separated isolate
//       onStart: onStart,

//       // auto start service
//       autoStart: true,
//       isForegroundMode: false,
//     ),
//     iosConfiguration: IosConfiguration(
//       // auto start service
//       autoStart: true,

//       // this will executed when app is in foreground in separated isolate
//       onForeground: onStart,

//       // you have to enable background fetch capability on xcode project
//       onBackground: onIosBackground,
//     ),
//   );
//   service.startService();
// }

bool onIosBackground(ServiceInstance service) {
  WidgetsFlutterBinding.ensureInitialized();
  print('FLUTTER BACKGROUND FETCH');

  return true;
}

// void onStart(ServiceInstance service) async {
//   print('hallloooo');

//   // SharedPreferences preferences = await SharedPreferences.getInstance();
//   // await preferences.setString("hello", "world");

//   // if (service is AndroidServiceInstance) {
//   //   service.on('setAsForeground').listen((event) {
//   //     service.setAsForegroundService();
//   //   });

//   //   service.on('setAsBackground').listen((event) {
//   //     service.setAsBackgroundService();
//   //   });
//   // }

//   service.on('stopService').listen((event) {
//     service.stopSelf();
//   });

//   // bring to foreground
//   Timer.periodic(const Duration(seconds: 120), (timer) async {
//     // SharedPreferences prefs = await SharedPreferences.getInstance();
//     final storage = new FlutterSecureStorage();
//     String? value = await storage.read(key: 'id_driver');

//     if (value != null) {
//       Position myPosition = await Geolocator.getCurrentPosition();
//       print('skuy masuk');
//       AuthService.updateLocation(
//           lat: myPosition.latitude.toString(),
//           lon: myPosition.longitude.toString(),
//           id: value);
//     }

//     /// you can see this log in logcat
//     print('FLUTTER BACKGROUND SERVICE: ${DateTime.now()}');

//     service.invoke(
//       'update',
//       {
//         "current_date": DateTime.now().toIso8601String(),
//         "device": '',
//       },
//     );
//   });
// }

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

void configLoading() {
  EasyLoading.instance
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.white
    ..backgroundColor = Colors.blue
    ..indicatorColor = Colors.blue
    ..textColor = Colors.white
    ..maskType = EasyLoadingMaskType.black
    ..userInteractions = true
    ..dismissOnTap = false;
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    _createNotificationChannel();
    configLoading();

    FlutterBackground.initialize(
      androidConfig: androidConfig,
    ).then((value) {
      Timer.periodic(Duration(seconds: 60), (timer) async {
        final storage = new FlutterSecureStorage();
        String? value = await storage.read(key: 'id_driver');

        print('valud : ' + value.toString());

        if (value != null) {
          // print('skuy');
          // BackgroundLocation.getLocationUpdates((location) {
          //   print(location);
          // });
          Position myPosition = await Geolocator.getCurrentPosition();
          print(myPosition.latitude);
          print(myPosition.longitude);

          print('custom background alamar 2');
          AuthService.updateLocation(
              lat: myPosition.latitude.toString(),
              lon: myPosition.longitude.toString(),
              id: value);
        }
      });
    });
    super.initState();
  }

  Future<void> _createNotificationChannel() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        new FlutterLocalNotificationsPlugin();

    var androidNotificationChannel = AndroidNotificationChannel(
      '050622', // channel ID
      'Bigexpress', // channel name

      importance: Importance.high,
    );
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidNotificationChannel);
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
          title: 'Big Express Driver',
          theme: ThemeData(
            primaryColor: Color(0xFF164690),
            primarySwatch: Colors.blue,
          ),
          builder: EasyLoading.init(),
          home: SplashScreenPage());
    });
  }
}
