import 'package:anime_nexa/core/typedefs.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/services/wallet_service.dart';
part 'wallet_view_model.g.dart';

@riverpod
class WalletViewModel extends _$WalletViewModel {
  late WalletService _walletService;

  @override
  AsyncValue<String?> build() {
    _walletService = ref.watch(walletServiceProvider);
    initialize();
    return AsyncValue.data(null);
  }

  FutureVoid initialize() async {
    state = const AsyncValue.loading();
    try {
      await _walletService.initialize();
      state = const AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  FutureVoid connect() async {
    state = const AsyncValue.loading();
    try {
      await _walletService.initialize();
      await _walletService.connect();
      final publicKey = _walletService.publicKey;
      state = AsyncValue.data(publicKey);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  String? get publicKey => _walletService.publicKey;

  FutureVoid disconnect() async {
    await _walletService.disconnect();
    state = const AsyncValue.data(null);
  }
}
