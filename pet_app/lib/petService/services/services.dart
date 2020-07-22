import 'package:get_it/get_it.dart';
import 'package:pet_app/petService/services/auth/auth_service.dart';
import 'package:pet_app/petService/services/auth/firebase_auth_service.dart';
import 'package:pet_app/petService/services/chat/chat_service.dart';
import 'package:pet_app/petService/services/chat/firebase_chat_service.dart';
import 'package:pet_app/petService/services/pets/firebase_pets_service.dart';
import 'package:pet_app/petService/services/pets/pets_service.dart';
import 'package:pet_app/petService/services/services/firebase_services_service.dart';
import 'package:pet_app/petService/services/storage/firebase_storage_service.dart';
import 'package:pet_app/petService/services/storage/storage_service.dart';
import 'package:pet_app/petService/services/user/firebase_user_service.dart';
import 'package:pet_app/petService/services/services/services_service.dart';
import 'package:pet_app/petService/services/user/user_service.dart';

final services = GetIt.instance;

void initServices() {
  services.registerLazySingleton<UserService>(() => FirebaseUserService());
  services.registerLazySingleton<AuthService>(() => FirebaseAuthService());
  services
      .registerLazySingleton<StorageService>(() => FirebaseStorageService());
  services.registerLazySingleton<PetsService>(() => FirebasePetsService());
  services.registerLazySingleton<ChatService>(() => FirebaseChatService());
  services
      .registerLazySingleton<ServicesService>(() => FirebaseServicesService());
}
