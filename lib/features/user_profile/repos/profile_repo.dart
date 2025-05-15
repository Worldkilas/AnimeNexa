import 'package:anime_nexa/core/typedefs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import '../../../models/anime_nexa_user.dart';
import '../../../providers/global_providers.dart'; // Assuming your global firebaseAuthProvider and firebaseFirestoreProvider are defined here.

class ProfileRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;

  ProfileRepository({required this.firestore, required this.firebaseAuth});

  // Update only username, displayName, and bio
  FutureEither<AnimeNexaUser> updateProfile({
    required String username,
    required String fullname,
    String? bio,
  }) async {
    try {
      final user = firebaseAuth.currentUser;
      if (user == null) return left('User not authenticated');
      final userRef = firestore.collection('users').doc(user.uid);
      //check if username is taken
      final usernameTaken = await firestore
          .collection('users')
          .where('username', isEqualTo: username)
          .get();

      if (usernameTaken.docs.isNotEmpty) {
        return left('Username already taken');
      }
      await userRef.update({
        'username': username,
        'fullname': fullname,
        'bio': bio,
      });
      final userDoc = await userRef.get();
      return right(AnimeNexaUser.fromJson(userDoc.data()!));
    } catch (e) {
      return left('Failed to set username: ${e.toString()}');
    }
  }

  FutureEither<AnimeNexaUser> getProfile() async {
    final currentUser = firebaseAuth.currentUser;
    if (currentUser == null) {
      return left("User is not authenticated");
    }
    try {
      final doc =
          await firestore.collection('users').doc(currentUser.uid).get();
      return right(AnimeNexaUser.fromJson(doc.data()!));
    } catch (e) {
      return left("Failed to fetch profile: $e");
    }
  }
}

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  final auth = ref.watch(firebaseAuthProvider);
  return ProfileRepository(
    firestore: firestore,
    firebaseAuth: auth,
  );
});
