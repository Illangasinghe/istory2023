import 'package:flutter/material.dart';
import 'package:istory/models/user.dart';
import 'package:istory/services/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_database/firebase_database.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  late User _user;
  UserModel? _userModel;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser!;
    _loadUserDetails();
  }

  void _loadUserDetails() async {
    final databaseReference = FirebaseDatabase.instance.ref();
    final databaseEvent = await databaseReference
        .child('users')
        .orderByChild('email')
        .equalTo(_user.email)
        .once();
    if (databaseEvent.snapshot.value != null) {
      final UserModel userModel =
          UserModel.fromSnapshot(databaseEvent.snapshot.children.first);
      setState(() {
        _userModel = userModel;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Center(
        child: _userModel == null
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(_userModel!.img),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _userModel!.pseudonym,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _userModel!.bio,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _userModel!.email,
                    style: const TextStyle(fontSize: 20),
                  ),
                  Text(
                    _userModel!.name,
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildRatingCircle(),
                      _buildLevelCircle(),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _signOut,
                    child: const Text('Sign Out'),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildRatingCircle() {
    return Container(
      width: 100,
      height: 100,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.green,
      ),
      child: Center(
        child: Text(
          _userModel!.rating.toStringAsFixed(1),
          style: const TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildLevelCircle() {
    return Container(
      width: 100,
      height: 100,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.deepPurple,
      ),
      child: Center(
        child: Text(
          _userModel!.level.toString(),
          style: const TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
    );
  }

  Future<void> _signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    Navigator.pushReplacementNamed(context, '/splash');
  }
}
