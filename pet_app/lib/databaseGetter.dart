import 'dart:convert' as convert;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pet_app/widgets/loader.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseGetter extends StatefulWidget {
  const DatabaseGetter({Key key}) : super(key: key);

  @override
  _DatabaseGetterState createState() => _DatabaseGetterState();
}

class _DatabaseGetterState extends State<DatabaseGetter> {
  bool _isLoading = false;

  Future<void> getData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      String collectionName = 'userData';
      List<Map<String, dynamic>> docDataList = List<Map<String, dynamic>>();

      // get the data
      QuerySnapshot snapshot = await Firestore.instance
          .collection(collectionName)
          .document('hello1@mail.com')
          .collection('profile')
          .getDocuments();
      snapshot.documents.forEach((element) {
        docDataList.add(element.data);
      });

      // DocumentSnapshot doc = await Firestore.instance
      //     .collection(collectionName)
      //     .document('hello1@mail.com')
      //     .get();
      // docDataList.add(doc.data);

      // convert the food data
      String jsonData = convert.jsonEncode(docDataList);

      print(jsonData);
      // create json file
      Directory externalDir = await getExternalStorageDirectory();

      File file = await File(externalDir.path + '/' + collectionName + '.json')
          .create();
      file.writeAsString(jsonData);
    } catch (e) {
      print(e);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(
              child: Loader(),
            )
          : Center(
              child: Text('got data'),
            ),
    );
  }
}

class DataUploader extends StatefulWidget {
  const DataUploader({Key key}) : super(key: key);

  @override
  _DataUploaderState createState() => _DataUploaderState();
}

class _DataUploaderState extends State<DataUploader> {
  bool _isLoading = false;

  Future<void> uploadData() async {
    setState(() {
      _isLoading = true;
    });

    // get the json file
    String data = await rootBundle.loadString('assets/data/data.json');

    // convert the data to map
    List<dynamic> mapData = convert.jsonDecode(data);

    // add to firestore
    CollectionReference usersCol = Firestore.instance.collection('pets');
    QuerySnapshot snapshot = await usersCol.getDocuments();
    print(snapshot.documents.length);
    for (var i = 0; i < mapData.length; i++) {
      await usersCol.add(mapData[i]);
    }

    print(mapData.length);

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    uploadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(
              child: Loader(),
            )
          : Center(
              child: Text('got data'),
            ),
    );
  }
}
