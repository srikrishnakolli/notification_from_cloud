import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'firebase_options.dart';

Future<void> _messageHandler(RemoteMessage message) async {
  print('Background message: ${message.notification?.body}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_messageHandler);
  runApp(MessagingApp());
}

class MessagingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeData lightTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: Color(0xFF8E97FD), // Soft lavender
        secondary: Color(0xFFC3FBD8), // Mint
        background: Color(0xFFF5F7FA),
        surface: Color(0xFFFFFFFF),
        onPrimary: Colors.white,
        onSurface: Color(0xFF222831),
      ),
      scaffoldBackgroundColor: Color(0xFFF5F7FA),
      appBarTheme: AppBarTheme(
        elevation: 0,
        color: Color(0xFF8E97FD),
        foregroundColor: Colors.white,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Firebase Messaging',
      theme: lightTheme,
      home: MyHomePage(title: '📬 Firebase Messaging Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late FirebaseMessaging messaging;
  String? notificationText = "📭 No notifications received yet.";

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
      });
      _showNotificationDialog(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      setState(() {
        notificationText = message.notification?.body ?? "No message body";
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
    );
  }
}
