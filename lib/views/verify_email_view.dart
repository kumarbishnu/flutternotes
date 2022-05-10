import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  
  void sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    await user?.sendEmailVerification();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Your Email'),
      ),
      body: Column(
        children: [
          const Text('Please verify your email address:'),
          ElevatedButton(
            onPressed: sendEmailVerification,
            child: const Text('Send email verification'),
          )
        ],
      ),
    );
  }
}