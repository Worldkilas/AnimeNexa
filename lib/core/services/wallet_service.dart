// import 'package:anime_nexa/core/typedefs.dart';
// import 'package:flutter/material.dart';
// import 'package:reown_appkit/modal/i_appkit_modal_impl.dart';
// import 'package:reown_appkit/reown_appkit.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';

// import '../../providers/global_providers.dart';
// import 'deep_link_handler.dart';
// part 'wallet_service.g.dart';

// class WalletService {
//   final ReownAppKitModal _appKitModal;

//   WalletService(this._appKitModal) {
//     initialize();
//   }

//   FutureVoid initialize() async {
//     await _appKitModal.init();

//     DeepLinkHandler.init(_appKitModal);
//     DeepLinkHandler.checkInitialLink();
//   }

//   FutureVoid connect() async {
//     try {
//       debugPrint("🟦 connect() called. isInitialized: ");
//       await initialize();
//       await _appKitModal.openModalView();
//     } on ReownAppKitModalException catch (e) {
//       debugPrint("🔴 Reown Exception during connect: ${e.message}");
//       rethrow;
//     } catch (e) {
//       debugPrint("🔴 Unknown error: $e");
//       rethrow;
//     }
//   }

//   String? get publicKey => _appKitModal.session?.getAddress('solana');

//   Future<void> disconnect() => _appKitModal.disconnect();
// }

// @riverpod
// WalletService walletService(ref) {
//   final appKitModal = ref.watch(reownAppKitModalProvider);
//   appKitModal.init();

//   return WalletService(appKitModal);
// }
