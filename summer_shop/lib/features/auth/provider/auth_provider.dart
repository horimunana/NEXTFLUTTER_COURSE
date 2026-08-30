import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:summer_shop/core/api/dio_provider.dart';
import 'package:summer_shop/core/provider/shared_preferences_provider.dart';
import 'package:summer_shop/features/auth/repositories/auth_repositories.dart';

/// Authentication state.
class AuthState {
  final bool isLoading;
  final String? token;
  final String? email;
  final String? error;

  const AuthState({
    this.isLoading = false,
    this.token,
    this.email,
    this.error,
  });

  bool get isAuthenticated => token != null && token!.isNotEmpty;

  AuthState copyWith({
    bool? isLoading,
    String? token,
    String? email,
    String? error,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      token: token ?? this.token,
      email: email ?? this.email,
      error: error ?? this.error,
    );
  }
}

class AuthController extends Notifier<AuthState> {
  static const _tokenKey = 'auth_token';
  static const _emailKey = 'auth_email';

  @override
  AuthState build() {
    final prefs = ref.read(sharedPreferencesProvider);
    return AuthState(
      token: prefs.getString(_tokenKey),
      email: prefs.getString(_emailKey),
    );
  }

  AuthRepository get _repository =>
      AuthRepository(dio: ref.read(dioProvider));

  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = AuthState(isLoading: true);
    try {
      final data = await _repository.login(email, password);
      final token = data['access_token'] as String? ?? '';
      final prefs = ref.read(sharedPreferencesProvider);
      await prefs.setString(_tokenKey, token);
      await prefs.setString(_emailKey, email);

      state = AuthState(token: token, email: email);
    } catch (e) {
      state = AuthState(error: 'Login failed. Please try again.');
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    state = AuthState(isLoading: true);
    try {
      await _repository.register(
        name: name,
        email: email,
        password: password,
      );
      state = AuthState(email: email);
    } catch (e) {
      state = AuthState(error: 'Registration failed. Email may already exist.');
    }
  }

  Future<void> logout() async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.remove(_tokenKey);
    await prefs.remove(_emailKey);
    state = const AuthState();
  }
}

/// Authentication controller/provider.
final authProvider =
    NotifierProvider<AuthController, AuthState>(AuthController.new);