import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:solana/solana.dart';
import 'package:solana_mobile_client/solana_mobile_client.dart';
part 'wallet_client_state.freezed.dart';

@freezed
class WalletClientState with _$WalletClientState {
  const factory WalletClientState({
    GetCapabilitiesResult? capabilities,
    AuthorizationResult? authorizationResult,
    @Default(false) bool isRequestingAirdrop,
  }) = _WalletClientState;

  const WalletClientState._();

  bool get isAuthorized => authorizationResult != null;
  bool get canRequestAirdrop => isAuthorized && !isRequestingAirdrop;

  Ed25519HDPublicKey? get publicKey {
    final publicKey = authorizationResult?.publicKey;
    if (publicKey == null) return null;
    return Ed25519HDPublicKey(publicKey);
  }

  String? get address => publicKey?.toBase58();
}
