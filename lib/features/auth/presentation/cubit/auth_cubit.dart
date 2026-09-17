import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serverpod_auth_email_flutter/serverpod_auth_email_flutter.dart';
import '../../../../core/network/api_client.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  late final EmailAuthController _authController;

  AuthCubit() : super(const AuthInitial()) {
    _authController = EmailAuthController(client.modules.auth);
  }

  void checkAuth() {
    if (sessionManager.isSignedIn) {
      final user = sessionManager.signedInUser;
      if (user != null) {
        emit(AuthAuthenticated(
          email: user.email ?? 'Unknown',
          displayName: user.userName ?? 'User',
        ));
      } else {
        emit(const AuthUnauthenticated());
      }
    } else {
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> signIn({required String email, required String password}) async {
    if (!_validateInput(email, password)) return;

    emit(const AuthLoading());
    try {
      final response = await _authController.signIn(email, password);
      if (response != null) {
        emit(AuthAuthenticated(
          email: response.email ?? email,
          displayName: response.userName ?? 'User',
        ));
      } else {
        emit(const AuthError('Invalid email or password'));
      }
    } catch (e) {
      emit(AuthError('Sign in failed: $e'));
    }
  }

  Future<void> signUp({required String email, required String password}) async {
    if (!_validateInput(email, password)) return;

    emit(const AuthLoading());
    try {
      final userName = email.split('@').first;
      final success = await _authController.createAccountRequest(userName, email, password);
      if (success) {
        emit(AuthEmailVerificationNeeded(email: email, password: password));
      } else {
        emit(const AuthError('Failed to request account creation'));
      }
    } catch (e) {
      emit(AuthError('Sign up failed: $e'));
    }
  }

  Future<void> verifySignUp(String code) async {
    if (state is! AuthEmailVerificationNeeded) return;
    
    final email = (state as AuthEmailVerificationNeeded).email;
    final password = (state as AuthEmailVerificationNeeded).password;
    
    emit(const AuthLoading());
    try {
      final response = await _authController.validateAccount(email, code);
      if (response != null) {
        // Validation succeeded, now we can log in
        await signIn(email: email, password: password);
      } else {
        emit(const AuthError('Invalid verification code'));
        // Revert back to verification state if failed
        emit(AuthEmailVerificationNeeded(email: email, password: password));
      }
    } catch (e) {
      emit(AuthError('Verification failed: $e'));
      emit(AuthEmailVerificationNeeded(email: email, password: password));
    }
  }

  Future<void> signOut() async {
    await sessionManager.signOutDevice();
    emit(const AuthUnauthenticated());
  }

  bool _validateInput(String email, String password) {
    if (email.isEmpty || password.isEmpty) {
      emit(const AuthError('Please fill in all fields'));
      return false;
    }
    if (!email.contains('@')) {
      emit(const AuthError('Please enter a valid email'));
      return false;
    }
    if (password.length < 6) {
      emit(const AuthError('Password must be at least 6 characters'));
      return false;
    }
    return true;
  }
}
