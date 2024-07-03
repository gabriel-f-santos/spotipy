import 'dart:io';

import 'package:client/core/constants/server_constant.dart';
import 'package:client/features/auth/model/model.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_remote_repository.g.dart';

@Riverpod(keepAlive: true)
AuthRemoteRepository authRemoteRepository(AuthRemoteRepositoryRef ref) {
  return AuthRemoteRepository();
}

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

  Future<UserModel> signin({
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

      print(response.data);

      UserModel user =
          UserModel.fromMap(response.data['user'] as Map<String, dynamic>)
              .copyWith(
        token: response.data['token'],
      );

      print('User: $user');

      return user;
    } catch (e) {
      print(e);
      throw 'An error occurred';
    }
  }

  Future<UserModel?> getCurrentUserData(String token) async {
    try {
      final response = await Dio().get(
          '${ServerConstant.BASE_URL}/auth/',
          options: Options(headers: {
            'Content-Type': 'application/json',
            'x-auth-token': token,
          }),
      );

      if (response.statusCode != HttpStatus.ok) {
        throw Exception(response.data);
      }

      final resBodyMap = response.data as Map<String, dynamic>;

      return UserModel.fromMap(resBodyMap).copyWith(
          token: token,
        );
    } catch (e) {
      print(e);
      throw 'An error occurred';
    }
  }

}
