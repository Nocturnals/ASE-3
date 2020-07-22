// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pet_app/redux/state.dart';
import 'package:pet_app/redux/reducer.dart';
import 'package:redux/redux.dart';

import 'package:pet_app/main.dart';

void main() {
  testWidgets('Run the app', (WidgetTester tester) async {
    final Store<AppState> store =
        Store<AppState>(appStateReducer, initialState: AppState.initial());

    // Build our app and trigger a frame.
    // await tester.pumpWidget(PetSApp(
    //   store: store,
    // ));
  });
}
