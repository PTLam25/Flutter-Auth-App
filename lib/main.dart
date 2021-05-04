import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './app/data/repositories/repositories.dart';
import './app/modules/core/core.dart';

void main() async {
  Bloc.observer = AppBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final SharedPreferences storage = await SharedPreferences.getInstance();
  final authenticationRepository = AuthenticationRepository(storage: storage);
  // try to get user
  await authenticationRepository.user.first;

  runApp(App(authenticationRepository: authenticationRepository));
}
