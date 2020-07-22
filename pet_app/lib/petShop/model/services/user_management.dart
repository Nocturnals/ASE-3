import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pet_app/petShop/model/data/userData.dart';
import 'package:pet_app/petShop/model/notifiers/userData_notifier.dart';
import 'package:pet_app/petShop/model/services/auth_service.dart';

//Storing new user data
storeNewUser(_name, _phone, _email) async {
  final db = Firestore.instance;
  final uid = await AuthService().getCurrentUID();

  var userUpdateInfo = new UserUpdateInfo();
  userUpdateInfo.displayName = _name;
  print(userUpdateInfo.displayName);

  await db
      .collection("users")
      .document(uid)
      .collection("profile")
      .document(uid)
      .setData({
    'name': _name,
    'phone': _phone,
    'email': _email,
  }).catchError((e) {
    print(e);
  });
}

//Getting User profile
getProfile(UserDataProfileNotifier profileNotifier) async {
  final uid = await AuthService().getCurrentUID();

  QuerySnapshot snapshot = await Firestore.instance
      .collection("users")
      .document(uid)
      .collection("profile")
      .getDocuments();

  List<UserDataProfile> _userDataProfileList = [];

  snapshot.documents.forEach((document) {
    print(document.data);
    UserDataProfile userDataProfile = UserDataProfile.fromMap(document.data);
    _userDataProfileList.add(userDataProfile);
  });

  profileNotifier.userDataProfileList = _userDataProfileList;
}

//Updating User profile
updateProfile(_name, _phone) async {
  final db = Firestore.instance;
  final uid = await AuthService().getCurrentUID();

  CollectionReference profileRef =
      db.collection("users").document(uid).collection("profile");
  await profileRef.document(uid).updateData(
    {'name': _name, 'phone': _phone},
  );
}

// Adding new address
storeAddress(
  fullLegalName,
  addressLocation,
  addressNumber,
) async {
  final db = Firestore.instance;
  final uid = await AuthService().getCurrentUID();

  await db
      .collection("users")
      .document(uid)
      .collection("address")
      .document(uid)
      .setData({
    'fullLegalName': fullLegalName,
    'addressLocation': addressLocation,
    'addressNumber': addressNumber,
  }).catchError((e) {
    print(e);
  });
}

//get users address
getAddress(UserDataAddressNotifier addressNotifier) async {
  final uid = await AuthService().getCurrentUID();

  QuerySnapshot snapshot = await Firestore.instance
      .collection("users")
      .document(uid)
      .collection("address")
      .getDocuments();

  List<UserDataAddress> _userDataAddressList = [];

  snapshot.documents.forEach((document) {
    print(document.data);
    UserDataAddress userDataAddress = UserDataAddress.fromMap(document.data);
    _userDataAddressList.add(userDataAddress);
  });

  addressNotifier.userDataAddressList = _userDataAddressList;
}

//Updating new address
updateAddress(
  fullLegalName,
  addressLocation,
  addressNumber,
) async {
  final db = Firestore.instance;
  final uid = await AuthService().getCurrentUID();

  CollectionReference addressRef =
      db.collection("users").document(uid).collection("address");
  await addressRef.document(uid).updateData(
    {
      'fullLegalName': fullLegalName,
      'addressLocation': addressLocation,
      'addressNumber': addressNumber,
    },
  );
}

//Adding new card
storeNewCard(
  cardHolder,
  cardNumber,
  validThrough,
  securityCode,
) async {
  final db = Firestore.instance;
  final uid = await AuthService().getCurrentUID();

  await db
      .collection("users")
      .document(uid)
      .collection("card")
      .document(uid)
      .setData({
    'cardHolder': cardHolder,
    'cardNumber': cardNumber,
    'validThrough': validThrough,
    'securityCode': securityCode,
  }).catchError((e) {
    print(e);
  });
}

//get users card
getCard(UserDataCardNotifier cardNotifier) async {
  final uid = await AuthService().getCurrentUID();

  QuerySnapshot snapshot = await Firestore.instance
      .collection("users")
      .document(uid)
      .collection("card")
      .getDocuments();

  List<UserDataCard> _userDataCardList = [];

  snapshot.documents.forEach((document) {
    print(document.data);
    UserDataCard userDataCard = UserDataCard.fromMap(document.data);
    _userDataCardList.add(userDataCard);
  });

  cardNotifier.userDataCardList = _userDataCardList;
}

//Updating new card
updateCard(
  cardHolder,
  cardNumber,
  validThrough,
  securityCode,
) async {
  final db = Firestore.instance;
  final uid = await AuthService().getCurrentUID();

  CollectionReference cardRef =
      db.collection("users").document(uid).collection("card");
  await cardRef.document(uid).updateData(
    {
      'cardHolder': cardHolder,
      'cardNumber': cardNumber,
      'validThrough': validThrough,
      'securityCode': securityCode,
    },
  );
}
