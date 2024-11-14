import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:finance_manager/screens/login_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 5), () { // Set the duration to 5 seconds
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xFFFFFFFF), // Set the background color
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Finance Manager',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Image.asset(
                'assets/poto.png', // Use your photo asset
                width: 200, // Adjust width if needed
                height: 200, // Adjust height if needed
                fit: BoxFit.contain,
              ),
              SizedBox(height: 20),
              Text(
                '152022078', // NIM Anda
                style: TextStyle(fontSize: 18),
              ),
              Text(
                'Khayla Giri Fitriani', // Nama Anda
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 40),
              SpinKitFadingCircle(
                color: Colors.black,
                size: 50.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
