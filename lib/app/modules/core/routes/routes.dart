import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../auth/login/login.dart';
import '../../profile/profile.dart';
import '../core.dart';

List<Page> onGenerateAppViewPages(AppStatus state, List<Page<dynamic>> pages) {
  switch (state) {
    case AppStatus.authenticated:
      return [ProfileView.page()];
    case AppStatus.unauthenticated:
    default:
      return [LoginView.page()];
  }
}
