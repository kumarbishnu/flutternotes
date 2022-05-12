import 'package:flutter/material.dart';
import 'package:flutternotes/constants/routes.dart';
import 'package:flutternotes/services/auth/auth_service.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Your Email'),
      ),
      body: Column(
        children: [
          const Text('We\'ve sent you an email verification. Please open it to verify your account.'),
          const Text('If you haven\'t received a verification email yet, press the button below.'),
          ElevatedButton(
            onPressed: () async {
              await AuthService.firebase().sendVerificationEmail();
            },
            child: const Text('Resend email verification'),
          ),
          ElevatedButton(
            onPressed: () async {
              await AuthService.firebase().logout();
              Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
            },
            child: const Text('Restart'),
          )
        ],
      ),
    );
  }
}