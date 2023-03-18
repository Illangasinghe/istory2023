import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:istory/screens/home/home_screen.dart';
import 'package:istory/screens/user/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //Variables
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  String email = '';
  String password = '';
  String error = '';

  //Sign in with Email & Password
  Future signInWithEmailAndPassword1(BuildContext context) async {
    try {
      var user = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (user != null) {
        if (!mounted) return;
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const HomeScreen()));
      }
    } catch (e) {
      setState(() {
        error = e.toString();
      });
    }
  }

  //Sign in with Email & Password
  Future signInWithEmailAndPassword(BuildContext context) async {
    try {
      // Attempt to sign in the user with email and password
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      // If the user is not null, they are signed in
      if (userCredential != null) {
        if (!mounted) return;
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const HomeScreen()));
      }
      // If the user is null, attempt to sign them up with email and password
      else {
        userCredential = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        // If the sign up was successful, navigate to the home screen
        if (userCredential != null) {
          writeUserToRealtimeDB();
          if (!mounted) return;
          // Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const HomeScreen()));
        }
      }
    } catch (e) {
      setState(() {
        error = e.toString();
      });
    }
  }

  //Sign in with Google
  Future signInWithGoogle(BuildContext context) async {
    try {
// Sign in with Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      if (googleAuth != null) {
        // Authenticate with Firebase
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        final User? user = (await _auth.signInWithCredential(credential)).user;

        // Check if user is new or existing
        final User? currentUser = _auth.currentUser;
        if (user?.uid != currentUser?.uid) {
          await _auth.signOut();
          writeUserToRealtimeDB();
          if (!mounted) return;
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const HomeScreen()));
        }
      } else {
        error = "Google user is null";
      }
    } catch (e) {
      setState(() {
        error = e.toString();
      });
    }
  }

  writeUserToRealtimeDB() {
    User? user = _auth.currentUser;
    if (user != null) {
      //save user details in Realtime database
      // User is signed in.
      // Store the user data in a Realtime database.
      final databaseReference = FirebaseDatabase.instance.ref();
      databaseReference.child("users").child(user.uid).set({
        "email": user.email,
        "displayName": user.displayName,
        "photoUrl": user.photoURL,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              onChanged: (val) {
                setState(() => email = val);
              },
              decoration: const InputDecoration(
                hintText: 'Email',
              ),
            ),
            const SizedBox(height: 20.0),
            TextField(
              onChanged: (val) {
                setState(() => password = val);
              },
              obscureText: true,
              decoration: const InputDecoration(
                hintText: 'Password',
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () async {
                await signInWithEmailAndPassword(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                textStyle: const TextStyle(color: Colors.white),
              ),
              child: const Text(
                'Login',
                style: TextStyle(color: Colors.white),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await signInWithGoogle(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                textStyle: const TextStyle(color: Colors.white),
              ),
              child: const Text(
                'Sign in with Google',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 12.0),
            Text(
              error,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 14.0,
              ),
            ),
            const SizedBox(height: 12.0),
            TextButton(
              onPressed: () async {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SignUpScreen()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                textStyle: const TextStyle(color: Colors.green),
              ),
              child: const Text(
                'Sign up with email',
                style: TextStyle(color: Colors.black45),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
