class UserPostPopUpItems{
  List<Map<String, String>> get popUpItems {
    String deletePost = 'Delete Post';
    String editPost = 'Edit Post';

    List<Map<String, String>> popUpItems = <Map<String, String>>[
      {"action": "delete", "value": deletePost},
      {"action": "edit", "value": editPost}
    ];

    return popUpItems;
  }
}

class OtherPostPopUpItems{
  String username;

  List<Map<String, String>> get popUpItems {
    String notInterested = 'Not interested in this';
    String unFollow = 'Unfollow @' + this.username;
    String mute = 'Mute @' + this.username;
    String block = 'Block @' + this.username;
    String report = 'Report Post';

    List<Map<String, String>> popUpItems = <Map<String, String>>[
      {"action": "notinterested", "value": notInterested},
      {"action": "unfollow", "value": unFollow},
      {"action": "mute", "value": mute},
      {"action": "block", "value": block},
      {"action": "report", "value": report}
    ];

    return popUpItems;
  }
}