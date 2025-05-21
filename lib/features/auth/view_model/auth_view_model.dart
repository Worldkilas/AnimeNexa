import 'package:anime_nexa/core/typedefs.dart';
import 'package:anime_nexa/features/auth/view_model/states/auth_state.dart';
import 'package:anime_nexa/providers/global_providers.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../models/anime_nexa_user.dart';
import '../repos/auth_repo.dart';
part 'auth_view_model.g.dart';

@riverpod
class AuthViewModel extends _$AuthViewModel {
  @override
  AuthState build() {
    _checkInitialSession();
    return AuthInitialState();
  }

  AnimeNexaUser? get user {
    if (state is Authenticated) {
      return (state as Authenticated).user!;
    }
    return null;
  }

  void _checkInitialSession() async {
    final firebaseUser = ref.read(firebaseAuthProvider).currentUser;
    if (firebaseUser == null) {
      state = Unauthenticated(error: null);
      return;
    }

    final doc = await ref
        .watch(firebaseFirestoreProvider)
        .collection('users')
        .doc(firebaseUser.uid)
        .get();

    if (!doc.exists) {
      state = Unauthenticated(error: 'User record missing');
      return;
    }

    final user = AnimeNexaUser.fromJson(doc.data()!);
    state = Authenticated(user: user);
  }

  FutureVoid signInWithEmailandPassword({
    required String email,
    required String password,
  }) async {
    state = Authenticating();
    final result =
        await ref.read(firebaseAuthRepoProvider).signInWithEmailAndPassword(
              email: email,
              password: password,
            );
    state = result.match(
      (l) => Unauthenticated(error: l),
      (r) => Authenticated(user: r),
    );
  }

  FutureVoid signUpWithEmailandPassword({
    required String email,
    required String password,
  }) async {
    state = Authenticating();
    final result = await ref
        .read(firebaseAuthRepoProvider)
        .signUpWithEmailAndPassword(email: email, password: password);

    state = result.match(
      (l) => Unauthenticated(error: l),
      (r) => Authenticated(user: r),
    );
  }

  FutureVoid signInWithGoogle() async {
    state = Authenticating();
    final result = await ref.read(firebaseAuthRepoProvider).sinInWithGoogle();
    state = result.match(
      (l) => Unauthenticated(error: l),
      (r) => Authenticated(user: r),
    );
  }

  FutureVoid signout() async {
    state = Authenticating();
    final result = await ref.read(firebaseAuthRepoProvider).signOut();
    state = result.match(
      (l) => Unauthenticated(error: l),
      (r) => Unauthenticated(error: null),
    );
  }

  // FutureVoid setUsernameandFullname({
  //   required String username,
  //   required String fullName,
  // }) async {
  //   state = const AsyncValue.loading();
  //   final result =
  //       await ref.read(firebaseAuthRepoProvider).setUsernameandFullname(
  //             username: username,
  //             fullname: fullName,
  //           );
  //   state = result.match(
  //     (l) => AsyncValue.error(l, StackTrace.current),
  //     (r) => AsyncValue.data(r),
  //   );
}
