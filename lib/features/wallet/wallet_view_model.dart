import 'dart:typed_data';

import 'package:anime_nexa/core/configs.dart';
import 'package:anime_nexa/core/typedefs.dart';
import 'package:anime_nexa/models/wallet_client_state.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:solana/solana.dart';
import 'package:solana_mobile_client/solana_mobile_client.dart';
part 'wallet_view_model.g.dart';

@riverpod
class WalletViewModel extends _$WalletViewModel {
  late SolanaClient _solanaClient;
  @override
  WalletClientState build() {
    _initializeClient();
    return WalletClientState();
  }

  _initializeClient() {
    final rpcUrl = testnetRpcUrl;
    final websocketUrl = testnetWsUrl;
    _solanaClient = SolanaClient(
      rpcUrl: Uri.parse(rpcUrl),
      websocketUrl: Uri.parse(websocketUrl),
    );
  }



  // queries the android to find if there is a solana wallet installed
  FutureBool isWalletAvailable() => LocalAssociationScenario.isAvailable();

  FutureVoid requestCapabilities() async {
    final session = await LocalAssociationScenario.create();
    session.startActivityForResult(null).ignore();
    final client = await session.start();
    final capabilities = await client.getCapabilities();
    await session.close();
    state = state.copyWith(capabilities: capabilities);
  }

  // Used to authorize a wallet for signing txs
  FutureVoid authorizeWallet() async {
    final session = await LocalAssociationScenario.create();
    session.startActivityForResult(null).ignore();
    final client = await session.start();
    await _doAuthorize(client);
    await session.close();
  }

  //used for keeping session alive
  FutureVoid reauthorize() async {
    final authToken = state.authorizationResult?.authToken;
    if (authToken == null) return;

    final session = await LocalAssociationScenario.create();
    session.startActivityForResult(null).ignore();
    final client = await session.start();
    await _doReauthorize(client);
    await session.close();
  }

  FutureBool _doAuthorize(MobileWalletAdapterClient client) async {
    final result = await client.authorize(
      identityUri: Uri.parse('https://animenexa.com'),
      iconUri: Uri.parse('https://imgur.com/lzAshur'),
      identityName: 'Animenexa_ANX',
      cluster: testnetCluster,
    );
    state = state.copyWith(authorizationResult: result);

    return result != null;
  }

  FutureBool _doReauthorize(MobileWalletAdapterClient client) async {
    final authToken = state.authorizationResult?.authToken;
    if (authToken == null) return false;

    final result = await client.reauthorize(
      identityUri: Uri.parse('https://animenexa.com'),
      iconUri: Uri.parse('https://imgur.com/lzAshur'),
      identityName: 'Animenexa_ANX',
      authToken: authToken,
    );

    state = state.copyWith(authorizationResult: result);

    return result != null;
  }

  

}
