import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:whatsapp_clone/features/user/user_injection_container.dart';

import 'features/chat/presentation/chat_injection_container.dart';

final sl = GetIt.instance;

Future<void> init() async {

  final auth = FirebaseAuth.instance;
  final fireStore = FirebaseFirestore.instance;
//meaning that these instances will be created only when they are first requested,
// and the same instance will be reused.
  sl.registerLazySingleton(() => auth);
  sl.registerLazySingleton(() => fireStore);

  await userInjectionContainer();
  await chatInjectionContainer();
  // await statusInjectionContainer();
  // await callInjectionContainer();

}