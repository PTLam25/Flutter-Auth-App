import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

import '../../../../data/repositories/repositories.dart';
import '../../../../global/form_inputs/form_inputs.dart';

part 'change_password_state.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  ChangePasswordCubit(this._authenticationRepository)
      : super(const ChangePasswordState());

  final AuthenticationRepository _authenticationRepository;

  void oldPasswordChanged(String value) {
    final oldPassword = Password.dirty(value);
    emit(state.copyWith(
      oldPassword: oldPassword,
      status: Formz.validate([
        oldPassword,
        state.newPassword,
        state.confirmedNewPassword,
      ]),
    ));
  }

  void newPasswordChanged(String value) {
    final newPassword = Password.dirty(value);
    final confirmedNewPassword = ConfirmedPassword.dirty(
      password: newPassword.value,
      value: state.confirmedNewPassword.value,
    );
    emit(state.copyWith(
      newPassword: newPassword,
      confirmedNewPassword: confirmedNewPassword,
      status: Formz.validate([
        state.oldPassword,
        newPassword,
        state.confirmedNewPassword,
      ]),
    ));
  }

  void confirmedNewPasswordChanged(String value) {
    final confirmedNewPassword = ConfirmedPassword.dirty(
      password: state.newPassword.value,
      value: value,
    );
    emit(state.copyWith(
      confirmedNewPassword: confirmedNewPassword,
      status: Formz.validate([
        state.oldPassword,
        state.newPassword,
        confirmedNewPassword,
      ]),
    ));
  }

  Future<void> changePasswordFormSubmitted() async {
    if (!state.status.isValidated) return;
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      await _authenticationRepository.updatePassword(state.newPassword.value);
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } on Exception {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }
}
