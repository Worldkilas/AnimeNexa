import 'package:anime_nexa/models/anime_nexa_user.dart';

sealed class AuthState {}

class AuthInitialState extends AuthState {}

class Authenticating extends AuthState {}

class Authenticated extends AuthState {
  final AnimeNexaUser? user;
  Authenticated({required this.user});
}

class Unauthenticated extends AuthState {
  String? error;
  Unauthenticated({String? error});
}
