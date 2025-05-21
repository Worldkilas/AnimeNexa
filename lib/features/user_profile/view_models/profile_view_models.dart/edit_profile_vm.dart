import 'package:anime_nexa/core/typedefs.dart';
import 'package:anime_nexa/features/user_profile/repos/profile_repo.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'edit_profile_vm.g.dart';

@riverpod
class EditProfileVm extends _$EditProfileVm {
  @override
  FutureOr<void> build() {
    // No initial data required here.
  }

  FutureVoid submitProfile({
    required String username,
    required String fullName,
    String? bio,
  }) async {
    state = const AsyncValue.loading();
    final result = await ref.read(profileRepositoryProvider).updateProfile(
          username: username,
          fullname: fullName,
          bio: bio ?? "",
        );
    state = result.match(
      (l) => AsyncValue.error(l, StackTrace.current),
      (r) => const AsyncValue.data(null),
    );
  }
}
