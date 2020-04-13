import 'package:flutter/material.dart';
// import 'package:pet_app/src/Widget/imageSlider/imageSlider.dart';

import 'package:pet_app/constants/postPopUpItems.dart';


class PostItem extends StatefulWidget {
  final String dp;
  final String descr;
  final String postImage;
  final String name;
  final String username;
  final String time;


  PostItem({
    Key key,
    @required this.dp,
    @required this.descr,
    @required this.postImage,
    @required this.name,
    @required this.username,
    @required this.time,
  }) : super(key: key);
  @override
  _PostItemState createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  @override
  Widget build(BuildContext context) {
    // Getting post menu options...
    PostPopUpItems popUpItems = new PostPopUpItems();
    popUpItems.username = 'neelakanta.sriram';
    List<String> postPopUpItems = popUpItems.popUpItems;

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
                  "${widget.dp}",
                ),
              ),

              contentPadding: EdgeInsets.only(left: 10),
              title: Text(
                "${widget.name}",
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
              subtitle: Text(
                '@' + '${widget.username}' + ' · ' + '${widget.time}',
                softWrap: false,
                overflow: TextOverflow.fade,
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
                          "${widget.descr}"
                        ),
                      )
                    ],
                  ),

                  Image.asset(
                    "${widget.postImage}",
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
