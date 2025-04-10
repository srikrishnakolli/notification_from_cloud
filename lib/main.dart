import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'firebase_options.dart';
import 'screens/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MessagingApp());
}

class MessagingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeData lightTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: Color(0xFF8E97FD),
        secondary: Color(0xFFC3FBD8),
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
