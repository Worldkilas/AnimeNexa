import 'package:anime_nexa/core/typedefs.dart';
import 'package:anime_nexa/models/anime_nexa_user.dart';
import 'package:fpdart/fpdart.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../providers/global_providers.dart';
import '../repos/auth_repo.dart';
part 'auth_view_model.g.dart';

@riverpod
class AuthViewModel extends _$AuthViewModel {
  @override
  FutureOr<AnimeNexaUser?> build() async {
    //check if user is already logged in
    final firebaseUser = ref.watch(firebaseAuthProvider).currentUser;
    if (firebaseUser == null) return null;
    final firestore = ref.watch(firebaseFirestoreProvider);
    final doc = await firestore.collection('users').doc(firebaseUser.uid).get();
    return doc.exists ? AnimeNexaUser.fromJson(doc.data()!) : null;
  }

  FutureVoid signInWithEmailandPassword({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    final result =
        await ref.read(firebaseAuthRepoProvider).signInWithEmailAndPassword(
              email: email,
              password: password,
            );
    state = result.match(
      (l) => AsyncValue.error(l, StackTrace.current),
      (r) => AsyncValue.data(r),
    );
  }

  FutureVoid signUpWithEmailandPassword({
    required String email,
    required password,
  }) async {
    state = const AsyncValue.loading();
    final result = await ref
        .read(firebaseAuthRepoProvider)
        .signUpWithEmailAndPassword(email: email, password: password);

    state = result.match(
      (l) => AsyncValue.error(l, StackTrace.current),
      (r) => AsyncValue.data(r),
    );
  }

  FutureVoid signInWithGoogle() async {
    state = const AsyncValue.loading();
    final result = await ref.read(firebaseAuthRepoProvider).sinInWithGoogle();
    state = result.match(
      (l) => AsyncValue.error(l, StackTrace.current),
      (r) => AsyncValue.data(r),
    );
  }

  FutureVoid signout() async {
    state = const AsyncValue.loading();
    final result = await ref.read(firebaseAuthRepoProvider).signOut();
    state = result.match(
      (l) => AsyncValue.error(l, StackTrace.current),
      (r) => const AsyncValue.data(null),
    );
  }

  FutureVoid setUsernameandFullname({
    required String username,
    required String fullName,
  }) async {
    state = const AsyncValue.loading();
    final result =
        await ref.read(firebaseAuthRepoProvider).setUsernameandFullname(
              username: username,
              fullname: fullName,
            );
    state = result.match(
      (l) => AsyncValue.error(l, StackTrace.current),
      (r) => AsyncValue.data(r),
    );
  }
}
