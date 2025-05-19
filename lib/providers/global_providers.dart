import 'package:anime_nexa/models/anime_nexa_user.dart';
import 'package:appwrite/appwrite.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reown_appkit/modal/i_appkit_modal_impl.dart';
import 'package:reown_appkit/reown_appkit.dart';
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

final appContextProvider = StateProvider<BuildContext?>((ref) => null);

@Riverpod(keepAlive: true)
ReownAppKitModal reownAppKitModal(ref) {
  final context = ref.watch(appContextProvider);
  if (context == null) {
    throw Exception('BuildContext is not set');
  }
  debugPrint("🟩 Initializing ReownAppKitModal...");
  final appKitModal = ReownAppKitModal(
    context: context,
    projectId: dotenv.env['REOWN_PROJECT_ID'],
    metadata: PairingMetadata(
      name: 'AnimeNexa',
      description: 'The ultimate web3 hub for anime lovers',
      url: 'https://animenexa.com',
      icons: ['https://imgur.com/a/qkfFlnF'],
      redirect: Redirect(native: 'animenexa://wallet', linkMode: false),
    ),
  );
  // await appKitModal.init();
  // debugPrint("✅ ReownAppKitModal initialized.");

  return appKitModal;
}
