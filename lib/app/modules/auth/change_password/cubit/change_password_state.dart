part of 'change_password_cubit.dart';

enum ConfirmPasswordValidationError { invalid }

class ChangePasswordState extends Equatable {
  const ChangePasswordState({
    this.oldPassword = const Password.pure(),
    this.newPassword = const Password.pure(),
    this.confirmedNewPassword = const ConfirmedPassword.pure(),
    this.status = FormzStatus.pure,
  });

  final Password oldPassword;
  final Password newPassword;
  final ConfirmedPassword confirmedNewPassword;
  final FormzStatus status;

  @override
  List<Object> get props => [
        oldPassword,
        newPassword,
        confirmedNewPassword,
        status,
      ];

  ChangePasswordState copyWith({
    Password? oldPassword,
    Password? newPassword,
    ConfirmedPassword? confirmedNewPassword,
    FormzStatus? status,
  }) {
    return ChangePasswordState(
      oldPassword: oldPassword ?? this.oldPassword,
      newPassword: newPassword ?? this.newPassword,
      confirmedNewPassword: confirmedNewPassword ?? this.confirmedNewPassword,
      status: status ?? this.status,
    );
  }
}
