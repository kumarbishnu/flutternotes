import 'package:bloc/bloc.dart';
import 'package:flutternotes/services/auth/auth_provider.dart';
import 'package:flutternotes/services/auth/bloc/auth_event.dart';
import 'package:flutternotes/services/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider) : super(const AuthStateLoading()) {
    on<AuthEventInitialize>((event, emit) async {
      await provider.initialize();
      final user = provider.currentUser;
      if (user == null) {
        emit(const AuthStateLoggedOut());
      } else if (!user.isEmailVerified) {
        emit(const AuthStateNeedsVerification());
      } else {
        emit(AuthStateLoggedIn(user));
      }
    });

    on<AuthEventLogin>((event, emit) async {
      emit(const AuthStateLoading());
      try {
        final user =
            await provider.login(email: event.email, password: event.password);
        emit(AuthStateLoggedIn(user));
      } on Exception catch (e) {
        emit(AuthStateLoginFailure(e));
      }
    });

    on<AuthEventLogout>((event, emit) async {
      emit(const AuthStateLoading());
      try {
        await provider.logout();
        emit(const AuthStateLoggedOut());
      } on Exception catch (e) {
        emit(AuthStateLogoutFailure(e));
      }
    });
  }
}
