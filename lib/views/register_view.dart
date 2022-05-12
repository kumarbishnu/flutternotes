import 'package:flutter/material.dart';
import 'package:flutternotes/constants/routes.dart';
import 'package:flutternotes/services/auth/auth_exceptions.dart';
import 'package:flutternotes/services/auth/auth_service.dart';

import '../utilities/error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {

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

  void _register() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    try {
      await AuthService.firebase().register(
          email: email,
          password: password
      );
      AuthService.firebase().sendVerificationEmail();
      Navigator.pushNamed(context, AppRoutes.verify);
    } on WeakPasswordAuthException {
      await showErrorDialog(context, 'Weak password');
    } on EmailAlreadyInUseAuthException {
      await showErrorDialog(context, 'Email already in use');
    } on InvalidEmailAuthException {
      await showErrorDialog(context, 'Invalid email address');
    } on GenericAuthException {
      await showErrorDialog(context, 'Registration error');
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
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
            onPressed: _register,
            child: const Text('Register'),
          ),
          TextButton(
            onPressed: () => {Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false)},
            child: const Text('Already registered? Login here.'),
          ),
        ],
      ),
    );
  }
}
