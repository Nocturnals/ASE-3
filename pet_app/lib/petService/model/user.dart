class User {
  String email;
  String username;
  String uid;
  String pictureUrl;
  String bio;
  String location;
  bool isPetSitter;
  bool isServiceProvider;
  List<String> conversations;

  User(this.email, this.username, this.uid)
      : pictureUrl = "",
        bio = "",
        location = "",
        isPetSitter = false,
        isServiceProvider = false,
        conversations = List();

  Map<String, dynamic> toJson() => {
        'email': email,
        'name': username,
        'uid': uid,
        'picture_url': pictureUrl,
        'bio': bio,
        'location': location,
        'pet_sitter': isPetSitter,
        'service_provider': isServiceProvider,
        'conversations': conversations
      };

  User.fromJson(Map<String, dynamic> json)
      : uid = json['uid'],
        username = json['name'],
        email = json['email'],
        pictureUrl = json['picture_url'],
        bio = json['bio'],
        location = json['location'],
        isPetSitter = json['pet_sitter'],
        isServiceProvider = json['service_provider'],
        conversations = List.from(json['conversations']);
}
