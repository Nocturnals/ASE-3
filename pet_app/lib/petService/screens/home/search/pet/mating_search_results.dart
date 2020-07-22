import 'package:flutter/material.dart';
import 'package:pet_app/petService/model/pet.dart';
import 'package:pet_app/petService/services/pets/pets_service.dart';
import 'package:pet_app/petService/services/services.dart';
import 'package:pet_app/petService/widgets/no_match_search.dart';
import 'package:pet_app/petService/widgets/pet_list_view.dart';

class MatingSearchResults extends StatelessWidget {
  final Pet forPet;
  final PetsService _petsService = services.get<PetsService>();

  MatingSearchResults({@required this.forPet});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _petsService.getMatingCompanionsForType(forPet.petType),
      // ignore: missing_return
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Pet> pets = snapshot.data;
          if (pets.isNotEmpty)
            return PetListView(
              petList: pets,
            );
          else
            return NoMatchSearch();
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
