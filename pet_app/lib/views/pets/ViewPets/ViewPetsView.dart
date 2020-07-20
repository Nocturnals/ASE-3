// dart imports
import 'dart:convert' as convert;

// flutter imports
import 'package:flutter/material.dart';

// model imports
import 'package:pet_app/models/pet.dart';
import 'package:pet_app/widgets/loader.dart';

// networking imports
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

// UI imports
import 'package:google_fonts/google_fonts.dart';
import 'package:pet_app/widgets/containers.dart';

class ViewAllPetsView extends StatefulWidget {
  const ViewAllPetsView({Key key}) : super(key: key);

  @override
  _ViewAllPetsViewState createState() => _ViewAllPetsViewState();
}

class _ViewAllPetsViewState extends State<ViewAllPetsView> {
  bool _isLoading = false;
  List<Pet> petList = List<Pet>();

  @override
  void initState() {
    _isLoading = false;
    petList.clear();
    getUserPets();
    super.initState();
  }

  Future<void> getUserPets() async {
    // set the is loading to true
    setState(() {
      _isLoading = true;
    });
    try {
      // get the jsontoken of the current user
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String jToken = prefs.getString('JToken');

      // send the request to get the user pets
      http.Response response = await http.get(
        '${DotEnv().env['localhost']}/api/pet/',
        headers: {
          "authorization": 'bearer $jToken',
          "Content-Type": "application/json",
        },
      );

      var jsonResponse = convert.jsonDecode(response.body);
      // check if the request is success
      if (response.statusCode == 200) {
        // add the values into the petlist
        petList.clear();
        for (var pet in jsonResponse['petsList']) {
          petList.add(Pet.fromMap(pet));
        }
      } else {
        print(
            'Error in request with code: ${response.statusCode}\nAnd with message: ${jsonResponse['message']}');
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text(jsonResponse['message'])));
      }
    } catch (e) {
      print(e);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 15, top: 20, right: 15, bottom: 20),
      width: MediaQuery.of(context).size.width,
      decoration: elevatedBoxDecoration,
      child: _isLoading
          ? Center(
              child: Loader(),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // text field
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    color: Colors.blue,
                  ),
                  height: 45,
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: Text(
                      'Your pets',
                      style: GoogleFonts.bangers(
                        color: Colors.deepPurple,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),

                Expanded(
                  child: ListView.builder(
                    itemCount: petList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        height: 45,
                        alignment: Alignment.center,
                        child: ListTile(
                          trailing: Text(petList[index].animalType),
                          subtitle: Text(
                            'DOB: ' +
                                petList[index].dob.day.toString() +
                                '/' +
                                petList[index].dob.month.toString() +
                                '/' +
                                petList[index].dob.year.toString(),
                          ),
                          title: Text(
                            petList[index].petName,
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
    );
  }
}
