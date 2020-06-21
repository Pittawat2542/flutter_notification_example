import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

AndroidNotificationDetails androidPlatformChannelSpecifics;
IOSNotificationDetails iOSPlatformChannelSpecifics;
NotificationDetails platformChannelSpecifics;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initializeNotification();

  runApp(MyApp());
}

void initializeNotification() async {
  var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
  var initializationSettingsIOS = IOSInitializationSettings(
      onDidReceiveLocalNotification:
          (int id, String title, String body, String payload) async {
    print(id);
  });
  var initializationSettings = InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (payload) {
    print('Tapped!');
    return;
  });

  androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your channel id', 'your channel name', 'your channel description',
      importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
  iOSPlatformChannelSpecifics = IOSNotificationDetails();
  platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification Example'),
      ),
      body: Center(
        child: MaterialButton(
          color: Theme.of(context).primaryColor,
          child: Text('Press me!'),
          onPressed: () async {
            await flutterLocalNotificationsPlugin.show(
                0, 'This is title', 'This is body', platformChannelSpecifics,
                payload: 'This is extra payload');
          },
        ),
      ),
    );
  }
}
