import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// The pet model
@immutable
class Pet {
  final String petId;
  final String petName;
  final String ownerId;
  final String animalType;
  final DateTime dob;

  Pet({
    @required this.petId,
    @required this.petName,
    @required this.ownerId,
    @required this.animalType,
    @required this.dob,
  });

  Pet.fromMap(Map json)
      : this.petId = json['pet_id'],
        this.petName = json['pet_name'],
        this.ownerId = json['owner_id'],
        this.animalType = json['animal_type'],
        this.dob = DateTime.parse(json['dob']);
}
