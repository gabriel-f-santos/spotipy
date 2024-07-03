import 'package:client/core/failure/failure.dart';
import 'package:client/core/providers/current_user_notifier.dart';
import 'package:client/features/auth/model/model.dart';
import 'package:client/features/auth/repositories/auth_local_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:client/features/auth/repositories/auth_remote_repository.dart';
part 'auth_view_model.g.dart';

@riverpod
class AuthViewModel extends _$AuthViewModel {
  late AuthRemoteRepository _authRemoteRepository;
  late AuthLocalRepository _authLocalRepository;
  late CurrentUserNotifier _currentUserNotifier;

  @override
  AsyncValue<UserModel>? build() {
    _authRemoteRepository = ref.watch(authRemoteRepositoryProvider);
    _authLocalRepository = ref.watch(authLocalRepositoryProvider);
    _currentUserNotifier = ref.watch(currentUserNotifierProvider.notifier);
    return null;
  }

  Future<void> initSharedPreferences() async {
    await _authLocalRepository.init();
  }

  Future<void> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      state = const AsyncValue.loading();
      final user = await _authRemoteRepository.signup(
        name: name,
        email: email,
        password: password,
      );
      state = AsyncValue.data(user);
    } catch (e) {
      state = AsyncValue.error(
          AppFailure(e.toString()).message, StackTrace.current);
    }
  }

  Future<void> signin({
    required String email,
    required String password,
  }) async {
    try {
      state = const AsyncValue.loading();
      final user = await _authRemoteRepository.signin(
        email: email,
        password: password,
      );
      _loginSuccess(user);
    } catch (e) {
      state = AsyncValue.error(
          AppFailure(e.toString()).message, StackTrace.current);
    }
  }

  AsyncValue<UserModel>? _loginSuccess(UserModel user) {
    print('User to save token: $user');
    _authLocalRepository.setToken(user.token);
    _currentUserNotifier.addUser(user);
    return state = AsyncValue.data(user);
  }

  // Future<UserModel?> getUser() async {
  //   state = const AsyncValue.loading();
  //   final token = await _authLocalRepository.getToken();
  //   if (token == null) {
  //     return null;
  //   }
  //   final user = await _authRemoteRepository.getUser(token);
  //   _currentUserNotifier.addUser(user);
  //   return null;
  // }

  Future<UserModel?> getData() async {
    state = const AsyncValue.loading();
    final token = _authLocalRepository.getToken();

    if (token != null) {
      try {
        final user = await _authRemoteRepository.getCurrentUserData(token as String);
        state = _getDataSuccess(user!);
      } catch (e) {
        state = AsyncValue.error(
            AppFailure(e.toString()).message, StackTrace.current);
      }

      return state?.value;
    }

    return null;
  }

  AsyncValue<UserModel> _getDataSuccess(UserModel user) {
    _currentUserNotifier.addUser(user);
    return state = AsyncValue.data(user);
  }

}
