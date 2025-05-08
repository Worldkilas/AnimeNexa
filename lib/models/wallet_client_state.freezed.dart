// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wallet_client_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$WalletClientState {
  GetCapabilitiesResult? get capabilities => throw _privateConstructorUsedError;
  AuthorizationResult? get authorizationResult =>
      throw _privateConstructorUsedError;
  bool get isRequestingAirdrop => throw _privateConstructorUsedError;

  /// Create a copy of WalletClientState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WalletClientStateCopyWith<WalletClientState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WalletClientStateCopyWith<$Res> {
  factory $WalletClientStateCopyWith(
          WalletClientState value, $Res Function(WalletClientState) then) =
      _$WalletClientStateCopyWithImpl<$Res, WalletClientState>;
  @useResult
  $Res call(
      {GetCapabilitiesResult? capabilities,
      AuthorizationResult? authorizationResult,
      bool isRequestingAirdrop});

  $GetCapabilitiesResultCopyWith<$Res>? get capabilities;
  $AuthorizationResultCopyWith<$Res>? get authorizationResult;
}

/// @nodoc
class _$WalletClientStateCopyWithImpl<$Res, $Val extends WalletClientState>
    implements $WalletClientStateCopyWith<$Res> {
  _$WalletClientStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WalletClientState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? capabilities = freezed,
    Object? authorizationResult = freezed,
    Object? isRequestingAirdrop = null,
  }) {
    return _then(_value.copyWith(
      capabilities: freezed == capabilities
          ? _value.capabilities
          : capabilities // ignore: cast_nullable_to_non_nullable
              as GetCapabilitiesResult?,
      authorizationResult: freezed == authorizationResult
          ? _value.authorizationResult
          : authorizationResult // ignore: cast_nullable_to_non_nullable
              as AuthorizationResult?,
      isRequestingAirdrop: null == isRequestingAirdrop
          ? _value.isRequestingAirdrop
          : isRequestingAirdrop // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  /// Create a copy of WalletClientState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GetCapabilitiesResultCopyWith<$Res>? get capabilities {
    if (_value.capabilities == null) {
      return null;
    }

    return $GetCapabilitiesResultCopyWith<$Res>(_value.capabilities!, (value) {
      return _then(_value.copyWith(capabilities: value) as $Val);
    });
  }

  /// Create a copy of WalletClientState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AuthorizationResultCopyWith<$Res>? get authorizationResult {
    if (_value.authorizationResult == null) {
      return null;
    }

    return $AuthorizationResultCopyWith<$Res>(_value.authorizationResult!,
        (value) {
      return _then(_value.copyWith(authorizationResult: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$WalletClientStateImplCopyWith<$Res>
    implements $WalletClientStateCopyWith<$Res> {
  factory _$$WalletClientStateImplCopyWith(_$WalletClientStateImpl value,
          $Res Function(_$WalletClientStateImpl) then) =
      __$$WalletClientStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {GetCapabilitiesResult? capabilities,
      AuthorizationResult? authorizationResult,
      bool isRequestingAirdrop});

  @override
  $GetCapabilitiesResultCopyWith<$Res>? get capabilities;
  @override
  $AuthorizationResultCopyWith<$Res>? get authorizationResult;
}

/// @nodoc
class __$$WalletClientStateImplCopyWithImpl<$Res>
    extends _$WalletClientStateCopyWithImpl<$Res, _$WalletClientStateImpl>
    implements _$$WalletClientStateImplCopyWith<$Res> {
  __$$WalletClientStateImplCopyWithImpl(_$WalletClientStateImpl _value,
      $Res Function(_$WalletClientStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of WalletClientState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? capabilities = freezed,
    Object? authorizationResult = freezed,
    Object? isRequestingAirdrop = null,
  }) {
    return _then(_$WalletClientStateImpl(
      capabilities: freezed == capabilities
          ? _value.capabilities
          : capabilities // ignore: cast_nullable_to_non_nullable
              as GetCapabilitiesResult?,
      authorizationResult: freezed == authorizationResult
          ? _value.authorizationResult
          : authorizationResult // ignore: cast_nullable_to_non_nullable
              as AuthorizationResult?,
      isRequestingAirdrop: null == isRequestingAirdrop
          ? _value.isRequestingAirdrop
          : isRequestingAirdrop // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$WalletClientStateImpl extends _WalletClientState {
  const _$WalletClientStateImpl(
      {this.capabilities,
      this.authorizationResult,
      this.isRequestingAirdrop = false})
      : super._();

  @override
  final GetCapabilitiesResult? capabilities;
  @override
  final AuthorizationResult? authorizationResult;
  @override
  @JsonKey()
  final bool isRequestingAirdrop;

  @override
  String toString() {
    return 'WalletClientState(capabilities: $capabilities, authorizationResult: $authorizationResult, isRequestingAirdrop: $isRequestingAirdrop)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WalletClientStateImpl &&
            (identical(other.capabilities, capabilities) ||
                other.capabilities == capabilities) &&
            (identical(other.authorizationResult, authorizationResult) ||
                other.authorizationResult == authorizationResult) &&
            (identical(other.isRequestingAirdrop, isRequestingAirdrop) ||
                other.isRequestingAirdrop == isRequestingAirdrop));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, capabilities, authorizationResult, isRequestingAirdrop);

  /// Create a copy of WalletClientState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WalletClientStateImplCopyWith<_$WalletClientStateImpl> get copyWith =>
      __$$WalletClientStateImplCopyWithImpl<_$WalletClientStateImpl>(
          this, _$identity);
}

abstract class _WalletClientState extends WalletClientState {
  const factory _WalletClientState(
      {final GetCapabilitiesResult? capabilities,
      final AuthorizationResult? authorizationResult,
      final bool isRequestingAirdrop}) = _$WalletClientStateImpl;
  const _WalletClientState._() : super._();

  @override
  GetCapabilitiesResult? get capabilities;
  @override
  AuthorizationResult? get authorizationResult;
  @override
  bool get isRequestingAirdrop;

  /// Create a copy of WalletClientState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WalletClientStateImplCopyWith<_$WalletClientStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
