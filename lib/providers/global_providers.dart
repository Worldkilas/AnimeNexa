import 'package:anime_nexa/models/anime_nexa_user.dart';
import 'package:appwrite/appwrite.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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

@Riverpod(keepAlive: true)
Client appwriteClient(ref) {
  final client = Client()
    ..setEndpoint('https://cloud.appwrite.io/v1')
    ..setProject(dotenv.env['APPWRITE_PROJECT_ID'])
    ..setSelfSigned(status: true);

  return client;
}

@Riverpod(keepAlive: true)
Account appwriteAccount(ref) {
  final client = ref.watch(appwriteClientProvider);
  return Account(client);
}

@Riverpod(keepAlive: true)
Storage appwriteStorage(ref) {
  final client = ref.watch(appwriteClientProvider);
  return Storage(client);
}
