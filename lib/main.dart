import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutternotes/constants/routes.dart';
import 'package:flutternotes/services/auth/bloc/auth_bloc.dart';
import 'package:flutternotes/services/auth/bloc/auth_event.dart';
import 'package:flutternotes/services/auth/bloc/auth_state.dart';
import 'package:flutternotes/services/auth/firebase_auth_provider.dart';
import 'package:flutternotes/views/notes/edit_note_view.dart';
import 'package:flutternotes/views/notes/notes_view.dart';
import 'package:flutternotes/views/register_view.dart';
import 'package:flutternotes/views/verify_email_view.dart';

import 'views/login_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
        home: BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(FirebaseAuthProvider()),
          child: const HomePage(),
        ),
      )
  );
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        switch (state.runtimeType) {
          case AuthStateLoggedIn:
            return const NotesView();
          case AuthStateNeedsVerification:
            return const VerifyEmailView();
          case AuthStateLoggedOut:
            return const LoginView();
          default:
            return const Scaffold(
              body: CircularProgressIndicator(),
            );
        }
      },
    );
  }
}
