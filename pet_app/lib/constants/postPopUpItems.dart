class PostPopUpItems{
  String username;

  List<String> get popUpItems {
    String notInterested = 'Not interested in this';
    String unFollow = 'Unfollow @' + this.username;
    String mute = 'Mute @' + this.username;
    String block = 'Block @' + this.username;
    String report = 'Report Post';

    List<String> popUpItems = <String>[
      notInterested,
      unFollow,
      mute,
      block,
      report
    ];

    return popUpItems;
  }
}