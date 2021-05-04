import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../auth/change_password/change_password.dart';
import '../../auth/reset_password/reset_password.dart';
import '../../core/bloc/app_bloc.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: ProfileView());

  @override
  Widget build(BuildContext context) {
    final user = context.select((AppBloc bloc) => bloc.state.user);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: <Widget>[
          IconButton(
            key: const Key('homePage_logout_iconButton'),
            icon: const Icon(Icons.exit_to_app),
            onPressed: () => context.read<AppBloc>().add(AppLogoutRequested()),
          )
        ],
      ),
      body: Align(
        alignment: const Alignment(0, -1 / 3),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(height: 4.0),
            Text(user.email ?? ''),
            const SizedBox(height: 4.0),
            Text(user.name ?? ''),
            TextButton(
              onPressed: () =>
                  Navigator.of(context).push<void>(ChangePasswordView.route()),
              child: Text(
                'CHANGE PASSWORD',
              ),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.of(context).push<void>(ResetPasswordView.route()),
              child: Text(
                'RESET PASSWORD',
              ),
            )
          ],
        ),
      ),
    );
  }
}
