// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

// import 'package:flutter/foundation.dart';

// import 'package:client/features/home/models/fav_song_model.dart';

class UserModel {
  final String name;
  final String email;
  final String id;
  final String token;
  // final List<FavSongModel> favorites;
  UserModel({
    required this.name,
    required this.email,
    required this.id,
    required this.token,
    // required this.favorites,
  });

  UserModel copyWith({
    String? name,
    String? email,
    String? id,
    String? token,
    // List<FavSongModel>? favorites,
  }) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      id: id ?? this.id,
      token: token ?? this.token,
      // favorites: favorites ?? this.favorites,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'id': id,
      'token': token,
      // 'favorites': favorites.map((x) => x.toMap()).toList(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    final user = map['user'] as Map<String, dynamic>;
    return UserModel(
      name: user['name'] ?? '',
      email: user['email'] ?? '',
      id: user['id'] ?? '',
      token: map['token'] ?? '',
      // favorites: List<FavSongModel>.from(
      //   (map['favorites'] ?? []).map(
      //     (x) => FavSongModel.fromMap(x as Map<String, dynamic>),
      //   ),
      // ),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    // return 'UserModel(name: $name, email: $email, id: $id, token: $token, favorites: $favorites)';
    return 'UserModel(name: $name, email: $email, id: $id, token: $token)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.email == email &&
        other.id == id &&
        other.token == token;
    // &&
    // listEquals(other.favorites, favorites);
  }

  @override
  int get hashCode {
    return name.hashCode ^ email.hashCode ^ id.hashCode ^ token.hashCode;
    // ^
    // favorites.hashCode;
  }
}
