import 'package:flutter/material.dart';
import 'package:flutternotes/constants/routes.dart';
import 'package:flutternotes/services/auth/auth_service.dart';
import 'package:flutternotes/views/notes/edit_note_view.dart';
import 'package:flutternotes/views/notes/notes_view.dart';
import 'package:flutternotes/views/register_view.dart';
import 'package:flutternotes/views/verify_email_view.dart';

import 'views/login_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AuthService.firebase().initialize();

  runApp(
      MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorSchemeSeed: Colors.green,
        ),
        routes: {
          AppRoutes.login: (context) => const LoginView(),
          AppRoutes.register: (context) => const RegisterView(),
          AppRoutes.verify: (context) => const VerifyEmailView(),
          AppRoutes.notes: (context) => const NotesView(),
          AppRoutes.editNote: (context) => const EditNoteView(),
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
    user = AuthService.firebase().currentUser;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    if (user == null) {
      return const LoginView();
    } else if (!user.isEmailVerified) {
      return const VerifyEmailView();
    }

    // return const LoginView();
    return const NotesView();
  }
}


