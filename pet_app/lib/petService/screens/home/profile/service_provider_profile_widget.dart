import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_app/petService/screens/services/my-services/my_services_page.dart';
import 'package:pet_app/widgets/card.dart';

class ServiceProviderWidget extends StatelessWidget {
  final bool newUI;
  ServiceProviderWidget({@required this.newUI});

  void navigatetoServicePage(BuildContext context) {
    Navigator.of(context).pushNamed(MyServicesPage.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return newUI
            ? card(context, 'shop', 'png', 'Service', () {
                navigatetoServicePage(context);
              })
            : Column(
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  RaisedButton(
                    child: Text("My Services"),
                    onPressed: () {
                      navigatetoServicePage(context);
                    },
                  )
                ],
              );
      },
    );
  }
}
