import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';

import './app/data/repositories/repositories.dart';
import './app/modules/core/core.dart';

void main() async {
  Bloc.observer = AppBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final authenticationRepository = AuthenticationRepository();
  // try to get user
  await authenticationRepository.user.first;
  runApp(App(authenticationRepository: authenticationRepository));
}
