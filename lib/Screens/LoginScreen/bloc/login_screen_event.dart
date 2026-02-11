part of 'login_screen_bloc.dart';

@immutable
sealed class LoginScreenEvent {}

class LoginSubmitEvent extends LoginScreenEvent {
  String username;
  String password;
  LoginSubmitEvent(this.username,this.password);
}

