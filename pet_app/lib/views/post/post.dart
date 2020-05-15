import 'package:flutter/material.dart';

import 'package:pet_app/constants/postPopUpItems.dart';


class PostItem extends StatefulWidget {
  final String profilePhoto;
  final String description;
  final String mediaUrls;
  final String username;
  final String time;
  final bool other;

  PostItem({
    Key key,
    @required this.profilePhoto,
    @required this.description,
    @required this.mediaUrls,
    @required this.username,
    @required this.time,
    @required this.other,
  }) : super(key: key);
  @override
  _PostItemState createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  @override
  Widget build(BuildContext context) {
    // Getting post menu options...
    List popUpItems = [];
    if (widget.other) {
      popUpItems.add(new OtherPostPopUpItems());
      popUpItems[0].username = '${widget.username}';
    }
    else popUpItems.add(new UserPostPopUpItems());

    List<String> postPopUpItems = popUpItems[0].popUpItems;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0),
      child: InkWell(
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        child: Column(
          children: <Widget>[
            ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage(
                  "${widget.profilePhoto}",
                ),
              ),

              contentPadding: EdgeInsets.only(left: 10),
              title: Text(
                '@' + '${widget.username}' + ' · ' + '${widget.time}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                softWrap: false,
                overflow: TextOverflow.fade,
              ),
              trailing: InkWell(
                onTap: null,
                child: PopupMenuButton<String>(
                  onSelected: popUpButtonAction,
                  itemBuilder: (BuildContext context) {
                    return postPopUpItems.map((String choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        child: Text(
                          choice,
                        )
                      );
                    }).toList();
                  }
                ),
              ),
            ),
            
            Container(
              padding: EdgeInsets.all(5),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(bottom: 10, left: 5, right: 5),
                        child: Text(
                          "${widget.description}"
                        ),
                      )
                    ],
                  ),

                  Image.asset(
                    "${widget.mediaUrls[0]}",
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                  ),

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
                        IconButton(
                          icon: Icon(Icons.favorite_border, color: Colors.red,),
                          onPressed: null
                        ),
                        IconButton(
                          icon: Icon(Icons.comment),
                          onPressed: null
                        ),
                        IconButton(
                          icon: Icon(Icons.share),
                          onPressed: null
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        onTap: (){},
      ),
    );
  }

  // Functions
  void popUpButtonAction(String choice) {
    print(choice);
  }
}
