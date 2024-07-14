import 'dart:convert';
import 'dart:io';

import 'package:client/core/constants/server_constant.dart';
import 'package:client/core/failure/failure.dart';
import 'package:client/features/home/models/song_model.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_repository.g.dart';

@Riverpod(keepAlive: true)
HomeRepository homeRepository(HomeRepositoryRef ref) {
  return HomeRepository();
}

class HomeRepository {
  Future<String> uploadSong({
    required File selectedAudio,
    required File selectedThumbnail,
    required String songName,
    required String artist,
    required String hexCode,
    required String token,
  }) async {
    try {
      final formData = FormData.fromMap({
        'song': await MultipartFile.fromFile(selectedAudio.path),
        'thumbnail': await MultipartFile.fromFile(selectedThumbnail.path),
        'artist': artist,
        'song_name': songName,
        'hex_code': hexCode,
      });

      final response = await Dio().post(
        '${ServerConstant.BASE_URL}/song/upload',
        data: formData,
        options: Options(headers: {
          'x-auth-token': token,
        }),
      );

      if (response.statusCode != HttpStatus.created) {
        throw AppFailure(response.data.toString());
      }

      return response.data.toString();
    } catch (e) {
      throw AppFailure(e.toString());
    }
  }

  Future<List<SongModel>> getAllSongs({
    required String token,
  }) async {
    try {
      final response = await Dio().get(
        '${ServerConstant.BASE_URL}/song/list',
        options: Options(headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        }),
      );

      if (response.statusCode != HttpStatus.ok) {
        throw AppFailure(response.data.toString());
      }

      List<SongModel> songs = (response.data as List)
          .map((songData) => SongModel.fromMap(songData as Map<String, dynamic>))
          .toList();

      return songs;
    } catch (e) {
      throw AppFailure(e.toString());
    }
  }

  Future<bool> favSong({
    required String token,
    required String songId,
  }) async {
    try {
      final response = await Dio().post(
        '${ServerConstant.BASE_URL}/song/favorite',
        options: Options(headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        }),
        data: jsonEncode({
          'song_id': songId,
        }),
      );

      if (response.statusCode != HttpStatus.ok) {
        throw AppFailure(response.data.toString());
      }

      return response.data['message'];
    } catch (e) {
      throw AppFailure(e.toString());
    }
  }

  Future<List<SongModel>> getFavSongs({
    required String token,
  }) async {
    try {
      final response = await Dio().get(
        '${ServerConstant.BASE_URL}/song/list/favorites',
        options: Options(headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        }),
      );

      if (response.statusCode != HttpStatus.ok) {
        throw AppFailure(response.data.toString());
      }

      List<SongModel> songs = (response.data as List)
          .map((songData) => SongModel.fromMap(songData['song'] as Map<String, dynamic>))
          .toList();

      return songs;
    } catch (e) {
      throw AppFailure(e.toString());
    }
  }
}
