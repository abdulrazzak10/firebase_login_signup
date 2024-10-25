import 'package:flutter/material.dart';
import 'package:prayer_app/ui/login.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Start the timer to navigate to the login screen after 9 seconds
    Timer(Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Set background color to black
      body: Center(
        child: Container(
          width: double.infinity, // Make the container take full width
          height: double.infinity, // Make the container take full height
          child: Image.asset(
            'assets/gifsplash.gif',
            fit: BoxFit.cover, // Cover the entire screen
          ), 
        ),
      ),
    );
  }
}
