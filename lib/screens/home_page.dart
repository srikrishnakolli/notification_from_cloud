import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'notification_history.dart';

class MyHomePage extends StatefulWidget {
  final String title;
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late FirebaseMessaging messaging;
  String? notificationText = "📭 No notifications received yet.";
  List<String> notificationHistory = [];
  List<bool> readStatus = [];

  @override
  void initState() {
    super.initState();
    messaging = FirebaseMessaging.instance;
    messaging.requestPermission();

    messaging.getToken().then((token) {
      print("FCM Token: $token");
    });

    messaging.subscribeToTopic("messaging");

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      setState(() {
        notificationText = message.notification?.body ?? "No message body";
        notificationHistory.add(notificationText!);
        readStatus.add(false);
      });
      _showNotificationDialog(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      setState(() {
        notificationText = message.notification?.body ?? "No message body";
        notificationHistory.add(notificationText!);
        readStatus.add(false);
      });
      _showNotificationDialog(message);
    });
  }

  void _showNotificationDialog(RemoteMessage message) {
    String notificationType = message.data['type'] ?? 'regular';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text(
            notificationType == 'important' ? "🔔 Important Notification" : "📢 Notification",
            style: TextStyle(
              color: Color(0xFF8E97FD),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(message.notification?.body ?? "No message body"),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Color(0xFF8E97FD),
              ),
              child: Text("OK"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color cardColor = Theme.of(context).colorScheme.secondary;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Card(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          color: cardColor.withOpacity(0.3),
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text(
              notificationText ?? '',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NotificationHistoryPage(
                history: notificationHistory,
                readStatus: readStatus,
                onMarkAllRead: () {
                  setState(() {
                    for (int i = 0; i < readStatus.length; i++) {
                      readStatus[i] = true;
                    }
                  });
                },
              ),
            ),
          );
        },
        label: Text('📜 History'),
        icon: Icon(Icons.history),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
