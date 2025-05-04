import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AnimeNexaUser {
  final String userId;
  final String email;
  final String username;
  final String displayName;
  final String? backgroundImageUrl;
  final String? avatarUrl;
  final int xps;
  final String? walletAddress;
  final DateTime? createdAt;

  AnimeNexaUser({
    required this.userId,
    required this.email,
    required this.username,
    required this.displayName,
    required this.avatarUrl,
    this.xps = 0,
    this.backgroundImageUrl,
    required this.walletAddress,
    required this.createdAt,
  });

  //convert from firebase user model to AnimeNexaUser
  factory AnimeNexaUser.fromFirebaseUser(User user,
      {int xps = 0, String? walletAddress}) {
    return AnimeNexaUser(
      userId: user.uid,
      email: user.email ?? '',
      username: user.displayName ?? '',
      displayName: user.displayName ?? '',
      avatarUrl: user.photoURL,
      xps: xps,
      walletAddress: walletAddress ?? '',
      createdAt: user.metadata.creationTime,
    );
  }

  /// 🧱 Create from Firestore JSON
  factory AnimeNexaUser.fromJson(Map<String, dynamic> json) {
    return AnimeNexaUser(
      userId: json['userId'] as String,
      email: json['email'] as String,
      username: json['username'] as String,
      displayName: json['displayName'] as String,
      backgroundImageUrl: json['backgroundImageUrl'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      xps: (json['xps'] ?? 0) as int,
      walletAddress: json['walletAddress'] as String?,
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] as Timestamp).toDate()
          : null,
    );
  }

  /// 💾 Convert to Firestore JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'email': email,
      'username': username,
      'displayName': displayName,
      'backgroundImageUrl': backgroundImageUrl,
      'avatarUrl': avatarUrl,
      'xps': xps,
      'walletAddress': walletAddress,
      'createdAt': createdAt,
    };
  }

  /// ✏️ Immutable copy
  AnimeNexaUser copyWith({
    String? userId,
    String? email,
    String? username,
    String? displayName,
    String? backgroundImageUrl,
    String? avatarUrl,
    int? xps,
    String? walletAddress,
    DateTime? createdAt,
  }) {
    return AnimeNexaUser(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      username: username ?? this.username,
      displayName: displayName ?? this.displayName,
      backgroundImageUrl: backgroundImageUrl ?? this.backgroundImageUrl,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      xps: xps ?? this.xps,
      walletAddress: walletAddress ?? this.walletAddress,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
