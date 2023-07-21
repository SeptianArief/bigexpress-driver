part of 'pages.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({Key? key}) : super(key: key);

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  late FirebaseMessaging messaging;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();

  Future onSelectNotification(String? payload) async {
    if (payload != null) {
      print('Payload Notification: $payload');
    }
  }

  Future onDidRecieveLocalNotification(
      int? id, String? title, String? body, String? payload) async {
    // display a dialog with the notification details, tap ok to go to another page

    showDialog(
      context: context,
      builder: (BuildContext context) => new CupertinoAlertDialog(
        title: new Text(title!),
        content: new Text(body!),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: new Text('Ok'),
            onPressed: () async {
              Navigator.pop(context);
              await Fluttertoast.showToast(
                  msg: "Notification Clicked",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Colors.black54,
                  textColor: Colors.white,
                  fontSize: 16.0);
            },
          ),
        ],
      ),
    );
  }

  Future displayNotification(Map<String, dynamic> message) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id', 'your channel name',
        playSound: true,
        groupKey: 'type_a',
        color: Theme.of(context).primaryColor,
        enableVibration: true,
        importance: Importance.max,
        priority: Priority.high);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    if (Platform.isAndroid) {
      // fToast.showToast(
      //   child: SuccessToast.notificationToast(context,
      //       title: message['title'], description: message['body']),
      //   gravity: ToastGravity.TOP,
      //   toastDuration: Duration(seconds: 3),
      // );
      await flutterLocalNotificationsPlugin.show(
        0,
        message['title'],
        message['body'],
        platformChannelSpecifics,
        payload: 'hello',
      );
    } else if (Platform.isIOS) {
      await flutterLocalNotificationsPlugin.show(
        0,
        message['aps']['alert']['title'],
        message['aps']['alert']['body'],
        platformChannelSpecifics,
        payload: 'hello',
      );
    }
  }

  startNavigation() {
    Timer(const Duration(seconds: 1), () async {
      Position myPosition = await Geolocator.getCurrentPosition();

      AuthService.checkRegion(
              lat: myPosition.latitude.toString(),
              lon: myPosition.longitude.toString(),
              id: '')
          .then((valueAPI) {
        if (valueAPI.status == RequestStatus.success_request) {
          if (valueAPI.data) {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => LocationRequestPage()));
          } else {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => AppLockedPage()));
          }
        } else {
          showSnackbar(context,
              title: 'Gagal Melakukan Pengecekan Lokasi',
              customColor: Colors.orange);
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (_) => FailedCheckLocationPage()));
        }
      });
    });
  }

  @override
  void initState() {
    BlocProvider.of<MasterCubit>(context).fetchMasterAmount();
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@drawable/notif_icon');

    var initializationSettingsIOS = new IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidRecieveLocalNotification);

    var initializationSettings = new InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);

    messaging = FirebaseMessaging.instance;
    messaging.getToken().then((value) {
      print(value);
    });

    FirebaseMessaging.onBackgroundMessage((message) async {
      // if (message.data['notification_type'] == 'chat') {
      //   _selectedPage.value = 2;
      //   ChatService.openChatRoom(context);
      // }

      return null;
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      final player = AudioPlayer();

      player.setAsset('assets/sound/notification_order.mp3');
      player.play();

      displayNotification({
        'title': event.notification!.title,
        'body': event.notification!.body
      });
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {});

    startNavigation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 70.0.w,
        height: 70.0.w,
        child: Image.asset('assets/images/Logo.png'),
      ),
    );
  }
}
