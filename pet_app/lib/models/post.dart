import 'package:flutter/foundation.dart';

@immutable
class Post {
  final String id;
  final String authorName;
  final String description;
  final List<String> mediaUrls;
  final int likesCount;
  final List<String> likedBy;
  final DateTime dateOfCreation;

  Post(
      {
        @required this.id,
        @required this.authorName,
        @required this.description,
        @required this.mediaUrls,
        @required this.likesCount,
        @required this.likedBy,
        @required this.dateOfCreation
      }
  );

  factory Post.initial() {
    return Post(
      id: null,
      authorName: null,
      description: null,
      mediaUrls: null,
      likesCount: null,
      likedBy: null,
      dateOfCreation: null
    );
  }

  Post copyWith({
    String id,
    String authorName,
    String description,
    String mediaUrls,
    int likesCount,
    List<String> likedBy,
    DateTime dateOfCreation,
  }) {
    return Post(
      id: id ?? this.id,
      authorName: authorName ?? this.authorName,
      description: description ?? this.description,
      mediaUrls: mediaUrls ?? this.mediaUrls,
      likesCount: likesCount ?? this.likesCount,
      likedBy: likedBy ?? this.likedBy,
      dateOfCreation: dateOfCreation ?? this.dateOfCreation,
    );
  }

  Post.fromMap(Map json)
      : id = json['id'],
        authorName = json['author_name'],
        description = json['description'],
        mediaUrls = json['media_urls'],
        likesCount = json['likes_count'],
        likedBy = json['liked_by'],
        dateOfCreation = json['date_of_creation'];

   Map toMap() => {
    'id': this.id,
    'author_name': this.authorName,
    'description': this.description,
    'media_urls': this.mediaUrls,
    'likes_count': this.likesCount,
    'liked_by': this.likedBy,
    'date_of_creation': this.dateOfCreation,
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Post &&
          this.runtimeType == other.runtimeType &&
          this.id == other.id &&
          this.authorName == other.authorName &&
          this.description == other.description &&
          this.likesCount == other.likesCount &&
          listEquals(this.mediaUrls, other.mediaUrls) &&
          listEquals(this.likedBy, other.likedBy);

  @override
  int get hashCode =>
      this.id.hashCode ^
      this.authorName.hashCode ^
      this.description.hashCode ^
      this.mediaUrls.hashCode ^
      this.likesCount ^
      this.likedBy.hashCode;
}