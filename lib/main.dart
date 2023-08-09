import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/login/login.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
          fontFamily: GoogleFonts.nunitoSans().fontFamily,
          primarySwatch: Colors.indigo,
          appBarTheme: AppBarTheme(
            color: Colors.white,
            iconTheme: const IconThemeData(color: Colors.black),
            elevation: 0,
            
            titleTextStyle: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontFamily: GoogleFonts.nunitoSans().fontFamily,
            ),
          )),
      home: const LoginScreen(),
    );
  }
}
