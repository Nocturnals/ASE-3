import 'package:flutter/material.dart';
import 'package:pet_app/petService/model/pet.dart';
import 'package:pet_app/petService/screens/home/home_page.dart';
import 'package:pet_app/petService/screens/pets/add-edit-pet/add-edit_pet_form.dart';
import 'package:pet_app/petService/screens/pets/my_pets/my_pets_page.dart';
import 'package:pet_app/petService/services/pets/pets_service.dart';
import 'package:pet_app/petService/services/services.dart';

class AddEditPetPage extends StatefulWidget {
  static final routeName = '/add-edit-pet';

  @override
  _AddEditPetPageState createState() => _AddEditPetPageState();
}

class _AddEditPetPageState extends State<AddEditPetPage> {
  final PetsService _petsService = services.get<PetsService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Pet Profile"),
        ),
        body: Center(
            child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                AddEditPetForm(
                  petActionHandler: (Pet petObject) async {
                    if (petObject.id.isEmpty) {
                      _petsService.addPet(petObject).then((_) =>
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              MyPetsPage.routeName,
                              ModalRoute.withName(HomePage.routeName)));
                    } else {
                      _petsService
                          .updatePet(petObject)
                          .then((_) => Navigator.of(context).pop());
                    }
                  },
                ),
                FlatButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text("Cancel"),
                )
              ],
            ),
          ),
        )));
  }
}
