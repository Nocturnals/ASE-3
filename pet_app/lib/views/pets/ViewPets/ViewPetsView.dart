// flutter imports
import 'package:flutter/material.dart';

// UI imports
import 'package:pet_app/widgets/containers.dart';

class ViewAllPetsView extends StatelessWidget {
  const ViewAllPetsView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 15, top: 20, right: 15, bottom: 20),
      width: MediaQuery.of(context).size.width,
      decoration: elevatedBoxDecoration,
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Add pet'),
        ],
      ),
    );
  }
}
