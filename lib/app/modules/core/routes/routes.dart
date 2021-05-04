import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../core.dart';

List<Page> onGenerateAppViewPages(AppStatus state, List<Page<dynamic>> pages) {
  switch (state) {
    case AppStatus.authenticated:
      return [
        MaterialPage<void>(
          child: Scaffold(
            body: Center(child: Text('HOME PAGE')),
          ),
        )
      ];
    case AppStatus.unauthenticated:
    default:
      return [
        MaterialPage<void>(
          child: Scaffold(
            body: Center(child: Text('LOGIN PAGE')),
          ),
        )
      ];
  }
}
