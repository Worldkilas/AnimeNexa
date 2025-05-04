import 'package:anime_nexa/features/auth/repos/auth_repo.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/typedefs.dart';
part 'set_username_vm.g.dart';

@riverpod
class SetUsernameVm extends _$SetUsernameVm {
  @override
  FutureOr build() {
    // SetUsernameVm.new;
    return null;
  }

  FutureVoid submitUsernameandName({
    required String username,
    required String fullName,
  }) async {
    final authRepo = ref.read(firebaseAuthRepoProvider);
    state = AsyncValue.loading();
    final result = await authRepo.setUsernameandFullname(
      username: username,
      fullname: fullName,
    );
    state = result.match(
      (l) => AsyncValue.error(l, StackTrace.current),
      (r) => AsyncValue.data(null),
    );
  }
}
