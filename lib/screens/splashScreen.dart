import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// Import all screens
import 'package:istory/screens.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

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
    Future.delayed(const Duration(milliseconds: 1400), () {
      // Navigate to the next screen
      checkLoginStatus();
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
            Image.asset("assets/images/splash.gif"),
            const SizedBox(height: 20),
            const CircularProgressIndicator(),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  checkLoginStatus() async {
    if (FirebaseAuth.instance.currentUser == null) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
      // Navigator.pushNamed(context, '/login');
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        ModalRoute.withName('/'),
      );
      // Navigator.pushNamed(context, '/');
    }
  }
}
