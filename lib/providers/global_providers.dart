import 'package:anime_nexa/models/anime_nexa_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'global_providers.g.dart';

@Riverpod(keepAlive: true)
FirebaseFirestore firebaseFirestore(ref) => FirebaseFirestore.instance;

@Riverpod(keepAlive: true)
FirebaseAuth firebaseAuth(ref) => FirebaseAuth.instance;

@Riverpod(keepAlive: true)
Stream<AnimeNexaUser> authStateChanges(ref) {
  final auth = ref.watch(firebaseAuthProvider);
  return auth
      .authStateChanges()
      .map(AnimeNexaUser.fromFirebaseUser(auth.currentUser));
}
