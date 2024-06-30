import 'package:dio/dio.dart';

class AuthRemoteRepository {
  Future<void> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final Map<String, dynamic> data = {
        'name': name,
        'email': email,
        'password': password,
      };
      final response = await Dio().post(
        'http://10.0.2.2:8000/auth/signup',
        data: data,
      );
      print(response.data);
    } catch (e) {
      print(e);
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    final Map<String, dynamic> data = {
      'email': email,
      'password': password,
    };
    try {
      final response = await Dio().post(
        'http://10.0.2.2:8000/auth/login',
        data: data,
      );
      print(response.data);
    } catch (e) {
      print(e);
    }
  }
}
