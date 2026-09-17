import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthInitial());

  Future<void> signIn({required String email, required String password}) async {
    if (email.isEmpty || password.isEmpty) {
      emit(const AuthError('Please fill in all fields'));
      return;
    }
    if (!email.contains('@')) {
      emit(const AuthError('Please enter a valid email'));
      return;
    }
    if (password.length < 6) {
      emit(const AuthError('Password must be at least 6 characters'));
      return;
    }

    emit(const AuthLoading());
    // Simulated network delay for mock auth
    await Future.delayed(const Duration(milliseconds: 1200));

    // Mock auth — any valid email/password combo succeeds
    final name = email.split('@').first;
    final displayName = name[0].toUpperCase() + name.substring(1);
    emit(AuthAuthenticated(email: email, displayName: displayName));
  }

  void signOut() {
    emit(const AuthUnauthenticated());
  }
}
