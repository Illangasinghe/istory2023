import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Add code here to initialize the data or do any other tasks required
    // before navigating to the next screen.

    // For example, you could wait for a certain amount of time before
    // navigating to the next screen:
    Future.delayed(Duration(seconds: 3), () {
      // Navigate to the next screen
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Add your logo or any other splash screen assets here
            Image.asset("assets/images/logo.png"),
            SizedBox(height: 20),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
