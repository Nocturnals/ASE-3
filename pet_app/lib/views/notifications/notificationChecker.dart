import 'package:flutter/material.dart';

import 'package:pet_app/models/loadingStatus.dart';

import 'notifications.dart';

void notificationChecker({@required NotificationViewModel notificationViewModel, @required BuildContext context}) {
  // if message exists clear is after some time
  if (notificationViewModel.state.loadingStatus == LoadingStatus.error) {
    Future.delayed(const Duration(milliseconds: 50), () {
      showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: Center(
                child: Text('Error'),
              ),
              content: Text(notificationViewModel.state.errorMessage),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    notificationViewModel.resetNotification();
                    Navigator.of(context, rootNavigator: true).pop('dialog');
                  },
                  child: Text('Retry'),
                )
              ],
            );
          });
    });
  } else if (notificationViewModel.state.loadingStatus ==
      LoadingStatus.showMessage) {
    Future.delayed(const Duration(milliseconds: 50), () {
      showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: Center(
                child: Text('Error'),
              ),
              content: Text(notificationViewModel.state.notifyMessage),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    notificationViewModel.resetNotification();
                    Navigator.of(context, rootNavigator: true).pop('dialog');
                  },
                  child: Text('Retry'),
                )
              ],
            );
          });
    });
  }
}
