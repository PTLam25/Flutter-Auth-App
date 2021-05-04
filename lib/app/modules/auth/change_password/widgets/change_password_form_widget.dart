import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../change_password.dart';

class ChangePasswordForm extends StatelessWidget {
  const ChangePasswordForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChangePasswordCubit, ChangePasswordState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Sign Up Failure')),
            );
        }
      },
      child: Align(
        alignment: const Alignment(0, -1 / 3),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _OldPasswordInput(),
            const SizedBox(height: 8.0),
            _NewPasswordInput(),
            const SizedBox(height: 8.0),
            _ConfirmNewPasswordInput(),
            const SizedBox(height: 8.0),
            _ChangePasswordButton(),
          ],
        ),
      ),
    );
  }
}

class _OldPasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChangePasswordCubit, ChangePasswordState>(
      buildWhen: (previous, current) =>
          previous.oldPassword != current.oldPassword,
      builder: (context, state) {
        return TextField(
          onChanged: (oldPassword) => context
              .read<ChangePasswordCubit>()
              .oldPasswordChanged(oldPassword),
          decoration: InputDecoration(
            labelText: 'old password',
            helperText: '',
            errorText: state.oldPassword.invalid ? 'invalid password' : null,
          ),
        );
      },
    );
  }
}

class _NewPasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChangePasswordCubit, ChangePasswordState>(
      buildWhen: (previous, current) =>
          previous.newPassword != current.newPassword,
      builder: (context, state) {
        return TextField(
          onChanged: (newPassword) => context
              .read<ChangePasswordCubit>()
              .newPasswordChanged(newPassword),
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'new password',
            helperText: '',
            errorText: state.newPassword.invalid ? 'invalid password' : null,
          ),
        );
      },
    );
  }
}

class _ConfirmNewPasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChangePasswordCubit, ChangePasswordState>(
      buildWhen: (previous, current) =>
          previous.oldPassword != current.oldPassword ||
          previous.confirmedNewPassword != current.confirmedNewPassword,
      builder: (context, state) {
        return TextField(
          onChanged: (confirmedNewPassword) => context
              .read<ChangePasswordCubit>()
              .confirmedNewPasswordChanged(confirmedNewPassword),
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'confirm new password',
            helperText: '',
            errorText: state.confirmedNewPassword.invalid
                ? 'passwords do not match'
                : null,
          ),
        );
      },
    );
  }
}

class _ChangePasswordButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChangePasswordCubit, ChangePasswordState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  primary: Colors.orangeAccent,
                ),
                onPressed: state.status.isValidated
                    ? () => context
                        .read<ChangePasswordCubit>()
                        .changePasswordFormSubmitted()
                    : null,
                child: const Text('CHANGE PASSWORD'),
              );
      },
    );
  }
}
