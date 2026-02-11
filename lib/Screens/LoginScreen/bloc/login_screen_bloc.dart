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
      // TODO: implement event handler

      if(event is LoginSubmitEvent){
        LoginRQ req = LoginRQ();
        
        req.username=event.username;
        req.password=event.password;

        print("---REQ--- ${jsonEncode(req)}");

        await ApiServices.invokeLogin(req).then((value) async {
          if(value.success=="true"){



            print("---NAME ----"+value.name!);

          }else{
            print("failed API");
          }

        });



        
        emit(LoginSuccessState());
      }


    });
  }
}

