import 'dart:io';

import 'package:client/core/constants/server_constant.dart';
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
        '${ServerConstant.BASE_URL}/auth/signup',
        data: data,
      );

      print(response.data);

      if (response.statusCode != HttpStatus.created) {
        throw Exception(response.data);
      }

      return UserModel.fromMap(response.data as Map<String, dynamic>);
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
        '${ServerConstant.BASE_URL}/auth/login',
        data: data,
      );
      if (response.statusCode != HttpStatus.ok) {
        throw 'An error occurred';
      }

      final _user = response.data['user'] as Map<String, dynamic>;

      UserModel user = UserModel.fromMap(_user);
      print('User: $user');
      return user;
    } catch (e) {
      print(e);
      throw 'An error occurred';
    }
  }
}
