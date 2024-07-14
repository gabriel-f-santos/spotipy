import 'dart:io';
import 'dart:ui';

import 'package:client/core/failure/failure.dart';
import 'package:client/core/providers/current_user_notifier.dart';
import 'package:client/core/utils.dart';
import 'package:client/features/home/models/fav_song_model.dart';
import 'package:client/features/home/models/song_model.dart';
import 'package:client/features/home/repositories/home_local_repository.dart';
import 'package:client/features/home/repositories/home_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_viewmodel.g.dart';

@riverpod
Future<List<SongModel>> getAllSongs(GetAllSongsRef ref) async {
  final token =
      ref.watch(currentUserNotifierProvider.select((user) => user!.token));

  if (token == null) {
    throw 'User not logged in';
  }
  try {
    final res = await ref.watch(homeRepositoryProvider).getAllSongs(
          token: token,
        );
    return res;
  } catch (e) {
    throw e;
  }
}

@riverpod
Future<List<SongModel>> getFavSongs(GetFavSongsRef ref) async {
  final token =
      ref.watch(currentUserNotifierProvider.select((user) => user!.token));

  if (token == null) {
    throw 'User not logged in';
  }

  try {
    final res = await ref.watch(homeRepositoryProvider).getFavSongs(
          token: token,
        );
    return res;
  } catch (e) {
    throw e;
  }
}

@riverpod
class HomeViewModel extends _$HomeViewModel {
  late HomeRepository _homeRepository;
  late HomeLocalRepository _homeLocalRepository;

  @override
  AsyncValue? build() {
    _homeRepository = ref.watch(homeRepositoryProvider);
    _homeLocalRepository = ref.watch(homeLocalRepositoryProvider);
    return null;
  }

Future<void> uploadSong({
  required File selectedAudio,
  required File selectedThumbnail,
  required String songName,
  required String artist,
  required Color selectedColor,
}) async {
  state = const AsyncValue.loading();
  
  final token = ref.read(currentUserNotifierProvider)?.token;

  if (token == null) {
    state = AsyncValue.error('User not logged in', StackTrace.current);
    return;
  }

  try {
    final result = await _homeRepository.uploadSong(
      selectedAudio: selectedAudio,
      selectedThumbnail: selectedThumbnail,
      songName: songName,
      artist: artist,
      hexCode: rgbToHex(selectedColor),
      token: token,
    );
    state = AsyncValue.data(result);
  } catch (e) {
    state = AsyncValue.error(
        AppFailure(e.toString()).message, StackTrace.current);
  }
}


  List<SongModel> getRecentlyPlayedSongs() {
    return _homeLocalRepository.loadSongs();
  }

Future<void> favSong({required String songId}) async {
  state = const AsyncValue.loading();

  final token = ref.read(currentUserNotifierProvider)?.token;

  if (token == null) {
    state = AsyncValue.error('User not logged in', StackTrace.current);
    return;
  }

  try {
    final result = await _homeRepository.favSong(
      songId: songId,
      token: token,
    );
    _favSongSuccess(result, songId);
    state = AsyncValue.data(result);
  } catch (e) {
    state = AsyncValue.error(
        AppFailure(e.toString()).message, StackTrace.current);
  }
}

  AsyncValue _favSongSuccess(bool isFavorited, String songId) {
    final userNotifier = ref.read(currentUserNotifierProvider.notifier);
    if (isFavorited) {
      userNotifier.addUser(
        ref.read(currentUserNotifierProvider)!.copyWith(
          favorites: [
            ...ref.read(currentUserNotifierProvider)!.favorites,
            FavSongModel(
              id: '',
              song_id: songId,
              user_id: '',
            ),
          ],
        ),
      );
    } else {
      userNotifier.addUser(
        ref.read(currentUserNotifierProvider)!.copyWith(
              favorites: ref
                  .read(currentUserNotifierProvider)!
                  .favorites
                  .where(
                    (fav) => fav.song_id != songId,
                  )
                  .toList(),
            ),
      );
    }
    ref.invalidate(getFavSongsProvider);
    return state = AsyncValue.data(isFavorited);
  }
}
