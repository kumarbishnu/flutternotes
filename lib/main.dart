import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutternotes/firebase_options.dart';
import 'package:flutternotes/views/notes_view.dart';
import 'package:flutternotes/views/register_view.dart';
import 'package:flutternotes/views/verify_email_view.dart';

import 'views/login_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );

  runApp(
      MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorSchemeSeed: Colors.green,
        ),
        routes: {
          '/login': (context) => const LoginView(),
          '/register': (context) => const RegisterView(),
          '/verify': (context) => const VerifyEmailView(),
          '/notes': (context) => const NotesView(),
        },
        home: const HomePage(),
      )
  );
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late final user;

  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser;
    user?.reload();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    if (user == null) {
      return const LoginView();
    } else if (!user.emailVerified) {
      return const VerifyEmailView();
    }

    // return const LoginView();
    return const NotesView();
  }
}


