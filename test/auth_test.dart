import 'package:flutternotes/services/auth/auth_exceptions.dart';
import 'package:flutternotes/services/auth/auth_provider.dart';
import 'package:flutternotes/services/auth/auth_user.dart';
import 'package:test/test.dart';

void main() {
  group('Mock Authentication', () {
    final provider = MockAuthProvider();

    test('Should not be initialized to begin with', () {
      expect(provider.isInitialized, false);
    });

    test('Cannot logout if not initialized', () {
      expect(provider.logout(), throwsA(const TypeMatcher<NotInitializedException>()));
    });

    test('Should be able to be initialized', () async {
      await provider.initialize();
      expect(provider.isInitialized, true);
    });

    test('User should be null after initialization', () {
      expect(provider.currentUser, null);
    });

    test('Should be able to initialize in less than 2 seconds', () async {
      await provider.initialize();
      expect(provider.isInitialized, true);
    }, timeout: const Timeout(Duration(seconds: 2)));

    test('Create user should delegate to login function', () async {
      final badEmailUser = provider.register(email: 'john@user.com', password: 'somepassword');
      expect(badEmailUser, throwsA(const TypeMatcher<UserNotFoundAuthException>()));

      final badPassword = provider.register(email: 'some@user.com', password: 'johndoe');
      expect(badPassword, throwsA(const TypeMatcher<WrongPasswordAuthException>()));

      final user = await provider.register(email: 'some@user.com', password: 'somepassword');
      expect(provider.currentUser, user);
      expect(user.isEmailVerified, false);
    }, timeout: const Timeout(Duration(seconds: 2)));
    
    test('Logged in user should be able to get verified', () {
      provider.sendVerificationEmail();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVerified, true);
    });

    test('Should be able to logout and login again', () async {
      await provider.logout();
      await provider.login(email: 'some@user.com', password: 'somepassword');
      expect(provider.currentUser, isNotNull);
    });

  });
}

class NotInitializedException implements Exception {}

class MockAuthProvider implements AuthProvider {

  AuthUser? _user;
  var _isInitialized = false;
  bool get isInitialized => _isInitialized;

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  Future<AuthUser> register({required String email, required String password}) async {
    if (!isInitialized) throw NotInitializedException();
    await Future.delayed(const Duration(seconds: 1));
    return login(email: email, password: password);
  }

  @override
  Future<AuthUser> login({required String email, required String password}) async {
    if (!isInitialized) throw NotInitializedException();
    if (email == 'john@user.com') throw UserNotFoundAuthException();
    if (password == 'johndoe') throw WrongPasswordAuthException();
    const user = AuthUser(id: 'id_1', email: 'john@user.com', isEmailVerified: false);
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> sendVerificationEmail() async {
    if (!isInitialized) throw NotInitializedException();
    final user = _user;
    if (user == null) throw UserNotLoggedInAuthException();
    const newUser = AuthUser(id: 'id_1', email: 'john@user.com', isEmailVerified: true);
    _user = newUser;
  }

  @override
  Future<void> logout() async {
    if (!isInitialized) throw NotInitializedException();
    if (_user == null) throw UserNotLoggedInAuthException();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

}