import 'package:flutter/material.dart';
import 'package:pet_app/petService/model/pet.dart';
import 'package:pet_app/petService/model/user.dart';
import 'package:pet_app/petService/services/auth/auth_service.dart';
import 'package:pet_app/petService/services/services.dart';
import 'package:pet_app/petService/services/user/user_service.dart';
import 'package:pet_app/petService/widgets/no_match_search.dart';
import 'package:pet_app/petService/widgets/pet_sitter_list_view.dart';

class PetSitterSearchResults extends StatelessWidget {
  final Pet forPet;
  final UserService _userService = services.get<UserService>();
  final AuthService _authService = services.get<AuthService>();

  PetSitterSearchResults({@required this.forPet});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _userService.getPetSitters(),
      // ignore: missing_return
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<User> petSitters = snapshot.data;
          if (petSitters.isNotEmpty)
            return PetSitterListView(
              petSitters: petSitters,
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
