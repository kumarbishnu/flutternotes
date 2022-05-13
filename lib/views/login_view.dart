import 'package:flutter/material.dart';
import 'package:flutternotes/constants/routes.dart';
import 'package:flutternotes/services/auth/auth_exceptions.dart';
import 'package:flutternotes/services/auth/auth_service.dart';

import '../utilities/dialogs/error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    try {
      await AuthService.firebase().login(
          email: email,
          password: password
      );
      final user = AuthService.firebase().currentUser;
      if (user?.isEmailVerified ?? false) {
        Navigator.pushNamedAndRemoveUntil(context, AppRoutes.notes, (route) => false);
      } else {
        Navigator.pushNamedAndRemoveUntil(context, AppRoutes.verify, (route) => false);
      }
    } on UserNotFoundAuthException {
      await showErrorDialog(context, 'User not found.');
    } on WrongPasswordAuthException {
      await showErrorDialog(context, 'Wrong credentials.');
    } on GenericAuthException {
      await showErrorDialog(context, 'Authentication Error.');
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _emailController,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: 'Enter your email here.'
            ),
          ),
          TextField(
            controller: _passwordController,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(
              hintText: 'Enter your password here.',
            ),
          ),
          ElevatedButton(
            onPressed: _login,
            child: const Text('Login'),
          ),
          TextButton(
            onPressed: () => {Navigator.pushNamedAndRemoveUntil(context, AppRoutes.register, (route) => false)},
            child: const Text('Not registered yet? Register here.'),
          ),
        ],
      ),
    );
  }
}
