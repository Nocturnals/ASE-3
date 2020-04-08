import 'package:flutter/foundation.dart';

@immutable
class User {
  final String id;
  final String username;
  final String email;
  final int age;
  final int petsCount;
  final List<String> petIds;
  final List<String> followers;
  final List<String> following;
  final List<String> likedPostIds;
  final List<String> favAnimalsIds;
  final List<String> orderIds;
  final List<String> remainderIds;
  final bool emailVerified;

  User(
      {@required this.id,
      @required this.username,
      @required this.email,
      @required this.age,
      @required this.petsCount,
      @required this.petIds,
      @required this.followers,
      @required this.following,
      @required this.likedPostIds,
      @required this.favAnimalsIds,
      @required this.orderIds,
      @required this.remainderIds,
      @required this.emailVerified});

  factory User.initial() {
    return User(
      id: null,
      username: null,
      email: null,
      age: null,
      petsCount: null,
      petIds: null,
      followers: null,
      following: null,
      likedPostIds: null,
      favAnimalsIds: null,
      orderIds: null,
      remainderIds: null,
      emailVerified: null,
    );
  }

  User copyWith({
    String id,
    String username,
    String email,
    int age,
    int petsCount,
    List<String> petIds,
    List<String> followers,
    List<String> following,
    List<String> likedPostIds,
    List<String> favAnimalsIds,
    List<String> orderIds,
    List<String> remainderIds,
    bool emailVerified,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      age: age ?? this.age,
      petsCount: petsCount ?? this.petsCount,
      petIds: petIds ?? this.petIds,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      likedPostIds: likedPostIds ?? this.likedPostIds,
      favAnimalsIds: favAnimalsIds ?? this.favAnimalsIds,
      orderIds: orderIds ?? this.orderIds,
      remainderIds: remainderIds ?? this.remainderIds,
      emailVerified: emailVerified ?? this.emailVerified,
    );
  }

  @override
  bool operator == (Object other) =>
      identical(this, other) ||
      other is User &&
          this.runtimeType == other.runtimeType &&
          this.id == other.id && 
          this.username == other.username && 
          this.email == other.email && 
          this.age == other.age && 
          this.petsCount == other.petsCount &&
          listEquals(this.petIds, other.petIds) &&
          listEquals(this.followers, other.followers) &&
          listEquals(this.following, other.following) &&
          listEquals(this.likedPostIds, other.likedPostIds) &&
          listEquals(this.favAnimalsIds, other.favAnimalsIds) &&
          listEquals(this.orderIds, other.orderIds) &&
          listEquals(this.remainderIds, other.remainderIds) &&
          this.emailVerified == other.emailVerified;

  @override
  int get hashCode =>
      this.id.hashCode ^
      this.username.hashCode ^
      this.email.hashCode ^
      this.age ^
      this.petIds.hashCode ^
      this.petsCount.hashCode ^
      this.followers.hashCode ^
      this.following.hashCode ^
      this.likedPostIds.hashCode ^
      this.favAnimalsIds.hashCode ^
      this.orderIds.hashCode ^
      this.remainderIds.hashCode ^
      this.emailVerified.hashCode;
}
