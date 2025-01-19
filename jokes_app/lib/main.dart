import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jokes_app/screens/categorized_jokes.dart';
import 'package:jokes_app/screens/random_joke.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:jokes_app/services/notifications_service.dart';
import 'package:timezone/timezone.dart' as tz;
import 'screens/home_screen.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  // WidgetsFlutterBinding.ensureInitialized();

  // // Initialize Firebase first.
  // await Firebase.initializeApp();

  // // Set up Firebase background message handler.
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // // Initialize and configure notifications.
  // final NotificationService _notificationService = NotificationService();
  // await _notificationService
  //     .initialize(); // If your initialize method awaits Firebase.initializeApp, consider removing duplicate Firebase.initializeApp from main.
  // await _notificationService.scheduleDailyNotification();
  // await _notificationService.showNotification(
  //   id: 0,
  //   title: 'Welcome',
  //   body: 'Welcome to the Jokes app!',
  // );

  runApp(const MyApp());
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  if (kDebugMode) {
    print('Handling a background message: ${message.messageId}');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jokes App',
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/random': (context) => const RandomJokeScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/jokes') {
          final args = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => JokesByTypeScreen(type: args),
          );
        }
        return null;
      },
    );
  }
}

Future<void> scheduleDailyNotification() async {
  await flutterLocalNotificationsPlugin.zonedSchedule(
    0,
    'Joke of the Day',
    'Check out today’s hilarious joke!',
    _nextInstanceOfTime(10, 0),
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'daily_channel_id',
        'Daily Notifications',
        channelDescription: 'Daily reminder for Joke of the Day',
        importance: Importance.max,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
      ),
    ),
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    matchDateTimeComponents: DateTimeComponents.time,
  );
}

tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
  final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
  tz.TZDateTime scheduledTime =
      tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);

  if (scheduledTime.isBefore(now)) {
    scheduledTime = scheduledTime.add(const Duration(days: 1));
  }
  return scheduledTime;
}
