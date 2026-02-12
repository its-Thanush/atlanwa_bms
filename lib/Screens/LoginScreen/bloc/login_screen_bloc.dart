import 'dart:convert';

import 'package:atlanwa_bms/allImports.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../model/loginModel.dart';
import '../../../network/ApiService.dart';

part 'login_screen_event.dart';
part 'login_screen_state.dart';

class LoginScreenBloc extends Bloc<LoginScreenEvent, LoginScreenState> {
  LoginScreenBloc() : super(LoginScreenInitial()) {
    on<LoginScreenEvent>((event, emit) async {
      if (event is LoginSubmitEvent) {
        // Emit loading state
        emit(LoginLoadingState());

        try {
          LoginRQ req = LoginRQ();
          req.username = event.username;
          req.password = event.password;

          print("---REQ--- ${jsonEncode(req)}");

          await ApiServices.invokeLogin(req).then((value) async {
            if (value.success == true) {
              print("---NAME ----" + value.name!);

              // Emit success state
              emit(LoginSuccessState(
                name: value.name,
                buildings: value.buildings,
              ));
            } else {
              String errorMessage = value.message ?? 'Invalid username or password';
              print("Failed API: $errorMessage");
              emit(LoginErrorState(errorMessage));
            }
          }).catchError((error) {
            // Handle network or other errors
            print("Login error: $error");
            emit(LoginErrorState('Network error. Please check your connection and try again.'));
          });
        } catch (e) {
          // Handle unexpected errors
          print("Unexpected error: $e");
          emit(LoginErrorState('An unexpected error occurred. Please try again.'));
        }
      }
    });
  }
}