import 'package:dio/dio.dart';

/// Data access layer for authentication.
///
/// Uses the fake auth endpoints of the Platzi Fake Store API:
///   POST https://api.escuelajs.co/api/v1/auth/login
///   POST https://api.escuelajs.co/api/v1/users/
/// See `lib/features/auth/notes.txt` for the request/response shape.
class AuthRepository {
  final Dio dio;

  const AuthRepository({required this.dio});

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await dio.post<Map<String, dynamic>>(
      '/api/v1/auth/login',
      data: {'email': email, 'password': password},
    );
    return response.data ?? {};
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    await dio.post<Map<String, dynamic>>(
      '/api/v1/users/',
      data: {
        'name': name,
        'email': email,
        'password': password,
        'avatar': 'https://i.pravatar.cc/300',
      },
    );
  }
}