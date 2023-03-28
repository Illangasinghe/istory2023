import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:istory/constants/colors.dart';
import 'package:istory/screens/home/home_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:istory/models/user.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  late String email;
  late String password;
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Email',
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Email can\'t be empty' : null,
                onChanged: (value) {
                  setState(() => email = value);
                },
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Password',
                ),
                validator: (value) => value!.length < 6
                    ? 'Password must be at least 6 characters'
                    : null,
                obscureText: true,
                onChanged: (value) {
                  setState(() => password = value);
                },
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      var result = await _auth.createUserWithEmailAndPassword(
                          email: email, password: password);
                      if (!mounted) return;
                      if (result != null) {
                        var currentUser = _auth.currentUser;
                        if (currentUser != null) {
                          // Save new user to database (this is optional saving to reuse data easily.)
                          final databaseRef = FirebaseDatabase.instance.ref();
                          final userModel = UserModel(
                            id: currentUser.uid,
                            email: currentUser.email!,
                            pseudonym: email.split('@')[0],
                            name: email.split('@')[0],
                            rating: 0,
                            level: 0,
                            img:
                                'https://firebasestorage.googleapis.com/v0/b/istory-bc418.appspot.com/o/default_images%2Fno_user_image.png?alt=media&token=141016a4-5994-48ce-9e0f-7e1041fa9b71',
                            bio: 'New starter',
                          );
                          await databaseRef
                              .child('users')
                              .child(currentUser.uid)
                              .set(userModel.toMap());
                        }
                        // Navigator.pushReplacementNamed(context, '/');
                        if (!mounted) return;
                        // Navigator.pushReplacement(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => const HomeScreen()));
                        Navigator.pushReplacementNamed(context, '/');
                      }
                    } catch (e) {
                      setState(
                          () => error = e.toString().split("]").last.trim());
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: poshPurple,
                  textStyle: const TextStyle(color: Colors.white),
                ),
                child: const Text(
                  'Sign up',
                  style: TextStyle(
                    color: Colors.white,
                  ),
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
            ],
          ),
        ),
      ),
    );
  }
}
