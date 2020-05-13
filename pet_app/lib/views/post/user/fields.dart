import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:pet_app/constants/postPopUpItems.dart';

import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:pet_app/constants/keys.dart';
import 'package:pet_app/models/post.dart';
import 'package:pet_app/redux/state.dart' show AppState;
import 'package:pet_app/models/loadingStatus.dart';
import 'package:pet_app/widgets/loader.dart';

import 'postViewModel.dart';

class Fields extends StatefulWidget {
  final Post post;

  Fields({
    Key key,
    @required this.post,
  }) : super(key: key);

  @override
  _FieldsState createState() => _FieldsState();
}

class _FieldsState extends State<Fields> {
  ScrollController _scrollController = ScrollController();
  Post _post;
  bool _liked;
  bool _likeButtonRefreshed;
  bool _saved;
  bool _saveButtonRefreshed;
  bool isAuthed = false;
  String _time;

  @override
  void initState() {
    super.initState();

    _post = widget.post;
    _liked = false;
    _likeButtonRefreshed = false;
    _saved = false;
    _saveButtonRefreshed = false;

    DateTime now = new DateTime.now();
    int differenceinHours = now.difference(_post.dateOfCreation).inHours;
    int differenceinDays = now.difference(_post.dateOfCreation).inDays;
    _time = differenceinHours >= 24 
            ? "$differenceinDays + 'd ago'" 
            : "$differenceinHours + 'ago'";
  }

  // function runs on hitting like button
  void _onHitLikeButton(PostViewModel postViewModel) {
    _liked
      ? postViewModel.removeLike()
      : postViewModel.addLike();

    setState(() {
      _liked = _liked ? false : true;
    });
  }

  // function for copying post url to clipboard
  void _onHitShareButton(String url) {
    Clipboard.setData(ClipboardData(text: url));
  }

  // function for saving post
  void _onHitSaveButton(String postId) {
    setState(() {
      _saved = _saved ? false : true;
    });

    debugPrint(postId);
  }

  // function to delete post
  void _onHitDeleteButton(PostViewModel postViewModel, String postId) {
    postViewModel.deletePost(postId: postId);
  }

  @override
  Widget build(BuildContext context) {
    // Getting post menu options...
    UserPostPopUpItems popUpItems = new UserPostPopUpItems();
    List<Map<String, String>> postPopUpItems = popUpItems.popUpItems;

    // login redirect snack bar
    Widget _loginRedirectSnack(String message) {
      return SnackBar(
        content: Column(
          children: <Widget>[
            Text(message),
            FlatButton(
              onPressed: () {
                Keys.navKey.currentState.pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
              },
              child: Text("LOGIN")
            )
          ],
        )
      );
    }

    // profile photo
    Widget _profilePhotoField(String url) {
      return Container(
        // width: 190.0,
        // height: 190.0,
        decoration: new BoxDecoration(
          shape: BoxShape.circle,
          image: new DecorationImage(
              fit: BoxFit.fill,
              image: new NetworkImage(url),
          )
        )
      );
    }

    // username field
    Widget _usernameField(String username, String time) {
      return Text(
        '@' + username + ' · ' + time,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
        softWrap: false,
        overflow: TextOverflow.fade,
      );
    }

    // popup button action
    void popUpButtonAction(String choice) {
      print(choice);
    }
    // popup menu field
    Widget _popUpMenuField(PostViewModel postViewModel) {
      return PopupMenuButton<String>(
        onSelected: popUpButtonAction,
        itemBuilder: (BuildContext context) {
          return postPopUpItems.map((Map<String, String> choice) {
            return PopupMenuItem<String>(
              value: choice["value"],
              child: FlatButton(
                onPressed: () {
                  switch (choice["action"]) {
                    case "delete":
                      _onHitDeleteButton(postViewModel, _post.id);
                      break;
                    default:
                  }
                },
                child: Text(choice["value"])
              )
            );
          }).toList();
        }
      );
    }

    // description field
    Widget _descriptionField(String description) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(bottom: 10, left: 5, right: 5),
            child: Text( description ),
          )
        ],
      );
    }

    // images Field
    Widget _imagesField(List<String> mediaUrls) {
      return FadeInImage(
        placeholder: null,
        image: NetworkImage(mediaUrls[0])
      );
    }

    // like button field
    Widget _likeButtonField(PostViewModel postViewModel, bool liked, bool isAuthed) {
      if (!_likeButtonRefreshed) {
        setState(() {
          _liked = liked;
          _likeButtonRefreshed = true;
        });
      }

      return IconButton(
        icon: Icon(
          _liked ? Icons.favorite : Icons.favorite_border,
          color: Colors.red,
        ),
        onPressed: isAuthed 
                      ? _onHitLikeButton 
                      : _loginRedirectSnack("Login to like the post"),
      );
    }

    // share button field
    Widget _shareButtonField(String postUrl) {
      return IconButton(
        icon: Icon(Icons.share),
        onPressed: () {
          _onHitShareButton(postUrl);
        }
      );
    }

    // save button field
    Widget _saveButtonField(bool saved, String postId, bool isAuthed) {
      if (!_saveButtonRefreshed) {
        setState(() {
          _saved = saved;
          _saveButtonRefreshed = true;
        });
      }

      return IconButton(
        icon: Icon(
          _saved 
            ? Icons.bookmark 
            : Icons.bookmark_border
        ),
        onPressed: () {
          isAuthed 
            ? _onHitSaveButton(postId) 
            : _loginRedirectSnack("Login to save the post");
        }
      );
    }

    return StoreConnector<AppState, PostViewModel>(
      converter: (Store<AppState> store) => PostViewModel.create(store),
      builder: (BuildContext context, PostViewModel postViewModel) =>
          postViewModel.state.loadingStatus == LoadingStatus.loading
              ? Center(
                  child: Loader(),
                )
              : InkWell(
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                child: Column(
                  children: <Widget>[
                    ListTile(
                      contentPadding: EdgeInsets.only(left: 10),
                      leading: _profilePhotoField(
                        "https://images.pexels.com/photos/814499/pexels-photo-814499.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"
                      ),
                      title: _usernameField(_post.authorName, _time),
                      trailing: postViewModel.isAuthed 
                                ? _popUpMenuField(postViewModel) 
                                : null,
                    ),

                    // description and images
                    Container(
                      padding: EdgeInsets.all(5),
                      child: Column(
                        children: <Widget>[
                          _descriptionField(_post.description),
                          _imagesField(_post.mediaUrls),
                          Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(width: 0.5, color: Color.fromRGBO(0, 0, 0, 0.3))
                              )
                            ),
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                // LIKE BUTTON
                                _likeButtonField(
                                  postViewModel,
                                  postViewModel.isAuthed 
                                    ? _post.likedBy.contains(postViewModel.loggedUser.id) 
                                        ? true 
                                        : false 
                                    : false,
                                  postViewModel.isAuthed
                                ),
                                // SHARE BUTTON
                                _shareButtonField('${DotEnv().env['localhost']}/api/post/${_post.id}'),
                                // SAVE BUTTON
                                _saveButtonField(
                                  postViewModel.isAuthed 
                                    ? postViewModel.loggedUser.likedPostIds.contains(postViewModel.loggedUser.id) 
                                        ? true
                                        : false 
                                    : false,
                                  _post.id,
                                  postViewModel.isAuthed
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
    );
  }
}