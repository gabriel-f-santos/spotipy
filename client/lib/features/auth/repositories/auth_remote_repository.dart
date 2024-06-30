import 'dart:convert';
import 'dart:io';

import 'package:client/features/auth/model/model.dart';
import 'package:dio/dio.dart';

class AuthRemoteRepository {
  Future<UserModel> signup({
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
      if (response.statusCode != HttpStatus.created) {
        throw Exception(response.data);
      }

      return UserModel.fromJson(response.data);
    } catch (e) {
      print(e);
      throw 'An error occurred';
    }
  }

  Future<UserModel> login({
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
      if (response.statusCode != HttpStatus.ok) {
        throw 'An error occurred';
      }
      return UserModel.fromJson(response.data);
    } catch (e) {
      print(e);
      throw 'An error occurred';
    }
  }
}
