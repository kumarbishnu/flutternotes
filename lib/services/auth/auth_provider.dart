import 'package:flutternotes/services/auth/auth_user.dart';

abstract class AuthProvider {
  AuthUser? get currentUser;

  Future<void> initialize();
  Future<AuthUser> register({required String email, required String password});
  Future<AuthUser> login({required String email, required String password});
  Future<void> sendVerificationEmail();
  Future<void> logout();
  Future<void> sendPasswordReset({required String toEmail});
}