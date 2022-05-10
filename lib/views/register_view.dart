import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password
      );
      print('User Credential: $userCredential');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('Weak password');
      } else if (e.code == 'email-already-in-use') {
        print('Email already in use');
      } else if (e.code == 'invalid-email') {
        print('Invalid email');
      }
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
            onPressed: () => {Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false)},
            child: const Text('Already registered? Login here.'),
          ),
        ],
      ),
    );
  }
}
