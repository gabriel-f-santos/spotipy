import 'package:client/features/auth/model/model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:client/features/auth/repositories/auth_remote_repository.dart';
part 'auth_view_model.g.dart';

@riverpod
class AuthViewModel extends _$AuthViewModel {
  final AuthRemoteRepository _authRemoteRepository = AuthRemoteRepository();

  @override
  AsyncValue<UserModel>? build() {
    return null;
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
      state = AsyncValue.error(e);
    }
  }
}
