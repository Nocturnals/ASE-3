import 'package:flutter/foundation.dart';

@immutable
class User {
  final String id;
  final String username;
  final String email;
  final int age;
  final int petsCount;
  final List<dynamic> petIds;
  final List<dynamic> postIds;
  final List<dynamic> followers;
  final List<dynamic> following;
  final List<dynamic> likedPostIds;
  final List<dynamic> favAnimalsIds;
  final List<dynamic> orderIds;
  final List<dynamic> remainderIds;
  final bool emailVerified;

  User(
      {@required this.id,
      @required this.username,
      @required this.email,
      @required this.age,
      @required this.petsCount,
      @required this.petIds,
      @required this.postIds,
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
      postIds: null,
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
    List<dynamic> petIds,
    List<dynamic> postIds,
    List<dynamic> followers,
    List<dynamic> following,
    List<dynamic> likedPostIds,
    List<dynamic> favAnimalsIds,
    List<dynamic> orderIds,
    List<dynamic> remainderIds,
    bool emailVerified,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      age: age ?? this.age,
      petsCount: petsCount ?? this.petsCount,
      petIds: petIds ?? this.petIds,
      postIds: postIds ?? this.postIds,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      likedPostIds: likedPostIds ?? this.likedPostIds,
      favAnimalsIds: favAnimalsIds ?? this.favAnimalsIds,
      orderIds: orderIds ?? this.orderIds,
      remainderIds: remainderIds ?? this.remainderIds,
      emailVerified: emailVerified ?? this.emailVerified,
    );
  }

  User.fromMap(Map json)
      : id = json['id'],
        username = json['username'],
        email = json['email'],
        age = json['age'],
        petsCount = json['pets_count'],
        petIds = json['pet_ids'],
        postIds = json['post_ids'],
        followers = json['followers'],
        following = json['following'],
        likedPostIds = json['liked_post_ids'],
        favAnimalsIds = json['fav_animals_ids'],
        orderIds = json['order_ids'],
        remainderIds = json['remainder_ids'],
        emailVerified = json['email_verified'];

  Map toMap() => {
    'id': this.id,
    'username': this.username,
    'email': this.email,
    'age': this.age,
    'pets_count': this.petsCount,
    'pet_ids': this.petIds,
    'post_ids': this.postIds,
    'followers': this.followers,
    'following': this.following,
    'liked_post_ids': this.likedPostIds,
    'fav_animals_ids': this.favAnimalsIds,
    'order_ids': this.orderIds,
    'remainder_ids': this.remainderIds,
    'email_verified': this.emailVerified,
  };

  @override
  bool operator ==(Object other) =>
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
