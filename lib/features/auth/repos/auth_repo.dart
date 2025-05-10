import 'package:anime_nexa/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/typedefs.dart';
import '../../../models/anime_nexa_user.dart';
import '../../../providers/global_providers.dart';
part 'auth_repo.g.dart';

@Riverpod(keepAlive: true)
FirebaseAuthRepo firebaseAuthRepo(ref) {
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  final firebaseFirestore = ref.watch(firebaseFirestoreProvider);
  return FirebaseAuthRepo(
    firebaseAuth: firebaseAuth,
    firebaseFirestore: firebaseFirestore,
  );
}

abstract class AuthRepository {
  FutureEither signInWithEmailAndPassword({
    required String email,
    required String password,
  });
  FutureEither signUpWithEmailAndPassword({
    required String email,
    required String password,
  });
  FutureEither signOut();
  FutureEither resetPassword(String email);
  FutureEither sinInWithGoogle();
}

class FirebaseAuthRepo implements AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firebaseFirestore;

  FirebaseAuthRepo({
    required FirebaseAuth firebaseAuth,
    required FirebaseFirestore firebaseFirestore,
  })  : _firebaseAuth = firebaseAuth,
        _firebaseFirestore = firebaseFirestore;

  @override
  FutureEither resetPassword(String email) {
    // TODO: implement resetPassword
    throw UnimplementedError();
  }

  @override
  FutureEither<AnimeNexaUser> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;
      if (user == null) return left('Unexpected error');
      final userDoc =
          await _firebaseFirestore.collection('users').doc(user.uid).get();
      return right(AnimeNexaUser.fromJson(userDoc.data()!));
    } on FirebaseAuthException catch (e, _) {
      final error = switch (e.code) {
        'user-not-found' => 'User not found',
        'wrong-password' => 'Wrong password',
        'invalid-email' => 'Invalid email',
        'network-request-failed' => 'Check your internet connection',
        _ => e.message ?? 'Unknown error',
      };
      return left(error);
    }
  }

  @override
  FutureEither signOut() async {
    try {
      await _firebaseAuth.signOut();
      return right(null);
    } catch (e) {
      return left('Failed to sign out: ${e.toString()}');
    }
  }

  @override
  FutureEither<AnimeNexaUser> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;
      if (user == null) return left('Failed to create user');

      final animeNexaUser = AnimeNexaUser.fromFirebaseUser(user);
      await _firebaseFirestore
          .collection('users')
          .doc(user.uid)
          .set(animeNexaUser.toJson());
      return right(animeNexaUser);
    } on FirebaseAuthException catch (e, _) {
      final error = switch (e.code) {
        'email-already-in-use' => 'Email already in use',
        'invalid-email' => 'Invalid email',
        'network-request-failed' => 'Check your internet connection',
        'weak-password' => 'Weak password',
        _ => e.message ?? 'Unknown error',
      };
      return left(error);
    }
  }

  @override
  FutureEither<AnimeNexaUser> sinInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId: DefaultFirebaseOptions.android.androidClientId,
      );
      final GoogleSignInAccount? gooogleUser = await googleSignIn.signIn();
      if (gooogleUser == null) return left('Google sign in cancelled');
      final GoogleSignInAuthentication googleAuth =
          await gooogleUser.authentication;
      final googleCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCredential =
          await _firebaseAuth.signInWithCredential(googleCredential);
      final user = userCredential.user;
      //get the user from firestore
      final userDoc =
          await _firebaseFirestore.collection('users').doc(user!.uid).get();

      //create the user in firestore if he doesn't exist
      if (!userDoc.exists) {
        final animeNexaUser = AnimeNexaUser.fromFirebaseUser(user);
        await _firebaseFirestore
            .collection('users')
            .doc(user.uid)
            .set(animeNexaUser.toJson());
        return right(AnimeNexaUser.fromFirebaseUser(user));
      }
      return right(
        AnimeNexaUser.fromJson(userDoc.data()!),
      );
    } on FirebaseAuthException catch (e, _) {
      final error = switch (e.code) {
        'account-exists-with-different-credential' =>
          'Account exists with different credential',
        'network-request-failed' => 'Check your internet connection',
        _ => e.message ?? 'Unknown error',
      };
      return left(error);
    }
  }

  FutureEither<AnimeNexaUser> setUsernameandFullname({
    required String username,
    required String fullname,
  }) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) return left('User not authenticated');
      final userRef = _firebaseFirestore.collection('users').doc(user.uid);
      //check if username is taken
      final usernameTaken = await _firebaseFirestore
          .collection('users')
          .where('username', isEqualTo: username)
          .get();

      if (usernameTaken.docs.isNotEmpty) {
        return left('Username already taken');
      }
      await userRef.update({
        'username': username,
        'fullname': fullname,
      });
      final userDoc = await userRef.get();
      return right(AnimeNexaUser.fromJson(userDoc.data()!));
    } catch (e) {
      return left('Failed to set username: ${e.toString()}');
    }
  }
}
