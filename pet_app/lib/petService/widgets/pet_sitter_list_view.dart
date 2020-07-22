import 'package:flutter/material.dart';
import 'package:pet_app/petService/model/user.dart';
import 'package:pet_app/petService/widgets/pet_sitter_tile.dart';

class PetSitterListView extends StatelessWidget {
  final List<User> petSitters;

  const PetSitterListView({Key key, this.petSitters}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
        separatorBuilder: (context, index) => Divider(
          color: Colors.black12,
        ),
        itemCount: petSitters.length,
        itemBuilder: (context, index) {
          User currentUser = petSitters[index];
          return PetSitterTile(
            petSitter: currentUser,
          );
        },
      ),
    );
  }
}
