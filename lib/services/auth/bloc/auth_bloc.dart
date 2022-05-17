import 'package:bloc/bloc.dart';
import 'package:flutternotes/services/auth/auth_provider.dart';
import 'package:flutternotes/services/auth/bloc/auth_event.dart';
import 'package:flutternotes/services/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider) : super(const AuthStateUninitialized(isLoading: true)) {

    on<AuthEventInitialize>((event, emit) async {
      await provider.initialize();
      final user = provider.currentUser;
      if (user == null) {
        emit(const AuthStateLoggedOut(exception: null, isLoading: false));
      } else if (!user.isEmailVerified) {
        emit(const AuthStateNeedsVerification(isLoading: false));
      } else {
        emit(AuthStateLoggedIn(user: user, isLoading: false));
      }
    });

    on<AuthEventShouldRegister>((event, emit) {
      emit(const AuthStateRegistering(exception: null, isLoading: false));
    });

    on<AuthEventRegister>((event, emit) async {
      try {
        await provider.register(email: event.email, password: event.password);
        await provider.sendVerificationEmail();
        emit(const AuthStateNeedsVerification(isLoading: false));
      } on Exception catch (e) {
        emit(AuthStateRegistering(exception: e, isLoading: false));
      }
    });

    on<AuthEventSendEmailVerification>((event, emit) async {
      await provider.sendVerificationEmail();
      emit(state);
    });

    on<AuthEventLogin>((event, emit) async {
      emit(const AuthStateLoggedOut(exception: null, isLoading: true));
      try {
        final user =
            await provider.login(email: event.email, password: event.password);
        emit(const AuthStateLoggedOut(exception: null, isLoading: false));
        if (!user.isEmailVerified) {
          emit(const AuthStateNeedsVerification(isLoading: false));
        } else {
          emit(AuthStateLoggedIn(user: user, isLoading: false));
        }
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(exception: e, isLoading: false));
      }
    });

    on<AuthEventLogout>((event, emit) async {
      try {
        await provider.logout();
        emit(const AuthStateLoggedOut(exception: null, isLoading: false, loadingText: 'Please wait while we log you in'));
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(exception: e, isLoading: false));
      }
    });

  }
}
