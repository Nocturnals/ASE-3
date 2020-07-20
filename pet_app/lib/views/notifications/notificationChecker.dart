import 'package:flutter/material.dart';

import 'package:pet_app/models/loadingStatus.dart';

import 'notifications.dart';

Widget _dialog(NotificationViewModel notificationViewModel,
    BuildContext context, String actionName, String message) {
  return AlertDialog(
    content: Text(
      message,
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.black),
    ),
    actions: <Widget>[
      RaisedButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        elevation: 12,
        color: Colors.blue,
        onPressed: () {
          notificationViewModel.resetMessage();
          Navigator.of(context, rootNavigator: true).pop('dialog');
        },
        child: Text(
          actionName,
          style: TextStyle(color: Colors.white),
        ),
      )
    ],
    elevation: 24.0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
  );
}

void notificationChecker(
    BuildContext context, NotificationViewModel notificationViewModel) {
  // if message exists clear is after some time
  if (notificationViewModel.state.loadingStatus == LoadingStatus.error) {
    Future.delayed(
      const Duration(milliseconds: 50),
      () {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return _dialog(notificationViewModel, context, "Retry",
                notificationViewModel.state.errorMessage);
          },
        );
      },
    );
  } else if (notificationViewModel.state.loadingStatus ==
      LoadingStatus.showMessage) {
    Future.delayed(
      const Duration(milliseconds: 50),
      () {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) {
            return _dialog(notificationViewModel, context, "Close",
                notificationViewModel.state.notifyMessage);
          },
        );
      },
    );
  }
}
