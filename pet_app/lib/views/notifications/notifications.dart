import 'package:flutter/material.dart';

import 'package:redux/redux.dart';

import 'package:pet_app/redux/state.dart' show AppState;
import 'package:pet_app/redux/auth/authActions.dart';
import 'package:pet_app/redux/auth/authState.dart' show AuthState;
import 'package:redux_thunk/redux_thunk.dart';

class NotificationViewModel {
  final AuthState state;
  final Function resetNotification;

  NotificationViewModel({@required this.state, @required this.resetNotification});

  factory NotificationViewModel.create(Store<AppState> store) {
    resetMessage() {
      store.dispatch(_resetNotification());
    }

    return NotificationViewModel(
      state: store.state.authState,
      resetNotification: resetMessage,
    );
  }
}

ThunkAction _resetNotification() {
  return (Store store) async {
    Future(() async {
      // reset the message after some time
      await Future.delayed(const Duration(seconds: 0), () {
        store.dispatch(ResetMessageAction());
      });
    });
  };
}