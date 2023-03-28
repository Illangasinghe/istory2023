import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:istory/models/story.dart';
// Import all screens
import 'package:istory/screens.dart';
import 'package:istory/constants/colors.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
// final FirebaseDatabase _database = FirebaseDatabase.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'istory',
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/': (context) => const HomeScreen(),
        // '/chats': (context) => const ChatsTab(),
        // '/catalog': (context) => const CatalogTab(),
        // '/profile': (context) => const ProfileTab(),
        '/story': (context) => ReadStoryScreen(
            story: ModalRoute.of(context)?.settings.arguments as StoryModel),
        // '/chats/message': (context) => const MessageScreen(),
        // '/chats/message/feedback': (context) => const FeedbackScreen(),
        '/category': (context) => CategoryScreen(
              categoryHashtag:
                  ModalRoute.of(context)?.settings.arguments as String,
            ),
        // '/catalog/category/message': (context) => const MessageScreen(),
        // '/catalog/category/message/feedback': (context) => const FeedbackScreen(),
        // '/chats/story-info': (context) => const StoryInfoScreen(),
        // '/catalog/category/story-info': (context) => const StoryInfoScreen(),
        '/create-story': (context) => CreateStoryScreen(),
        '/create-story/write-story': (context) => WriteStoryScreen(
            story: ModalRoute.of(context)?.settings.arguments as StoryModel),
      },
      theme: ThemeData(
        fontFamily: 'Yaldevi',
        primarySwatch: poshPurple,
      ),
    );
  }
}

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     Future.delayed(const Duration(seconds: 1), () {
//       checkLoginStatus();
//     });
//   }

//   checkLoginStatus() async {
//     FirebaseAuth _auth = FirebaseAuth.instance;
//     User? _user = _auth.currentUser;
//     if (_user == null) {
//       Navigator.pushReplacement(context,
//           MaterialPageRoute(builder: (context) => const LoginScreen()));
//       // Navigator.pushNamed(context, '/login');
//     } else {
//       Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(builder: (context) => const HomeScreen()),
//         ModalRoute.withName('/'),
//       );
//       // Navigator.pushNamed(context, '/');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         color: Colors.white,
//         child: Center(
//           child: Image.asset("assets/images/splash_icon.png"),
//         ),
//       ),
//     );
//   }
// }
