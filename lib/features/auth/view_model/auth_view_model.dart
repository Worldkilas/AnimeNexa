import 'package:anime_nexa/core/typedefs.dart';
import 'package:anime_nexa/models/auth_state.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../repos/auth_repo.dart';
part 'auth_view_model.g.dart';

@riverpod
class AuthViewModel extends _$AuthViewModel {
  @override
  AuthState build() {
    // _checkInitialSession();
    return AuthInitialState();
  }

  // FutureVoid _checkInitialSession() async{
  //   //check if user is already logged in
  //   final firebaseUser = ref.watch(firebaseAuthProvider).currentUser;
  //   if (firebaseUser == null) return null;
  //   final firestore = ref.watch(firebaseFirestoreProvider);
  //   final doc = await firestore.collection('users').doc(firebaseUser.uid).get();
  //   state=Authenticated( doc.exists ? AnimeNexaUser.fromJson(doc.data()!));
  // }

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
      (r) => Authenticated(user: r),
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
