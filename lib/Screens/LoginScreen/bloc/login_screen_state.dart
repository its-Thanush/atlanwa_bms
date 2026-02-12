part of 'login_screen_bloc.dart';

@immutable
sealed class LoginScreenState {}

final class LoginScreenInitial extends LoginScreenState {}

final class LoginLoadingState extends LoginScreenState {}

final class LoginSuccessState extends LoginScreenState {
  final String? name;
  final List<String>? buildings;

  LoginSuccessState({this.name, this.buildings});
}

final class LoginErrorState extends LoginScreenState {
  final String errorMessage;

  LoginErrorState(this.errorMessage);
}