import 'package:flutter/material.dart';
import 'package:finance_manager/screens/splash_screen.dart'; // Import SplashScreen dengan nama paket yang baru

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,  // Hide debug banner
      title: 'Finance Manager',  // Update app title
      theme: ThemeData(
        primarySwatch: Colors.blue,  // Your app's theme
      ),
      home: SplashScreen(),  // Set SplashScreen as the home screen
    );
  }
}
