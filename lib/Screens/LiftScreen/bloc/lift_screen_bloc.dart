import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../model/LiftFetchModel.dart';
import '../../../network/ApiService.dart';

part 'lift_screen_event.dart';
part 'lift_screen_state.dart';

class LiftScreenBloc extends Bloc<LiftScreenEvent, LiftScreenState> {
  LiftScreenBloc() : super(LiftScreenInitial()) {
    on<LiftScreenEvent>((event, emit) async {
      // TODO: implement event handler

      if (event is LiftFetchEvent) {
        if (state is! LiftFetchSuccessState) {
          emit(LiftFetchLoadingState());
        }
        try {
          final result = await ApiServices.getLiftsStatus();
          emit(LiftFetchSuccessState(result));
        } catch (e) {
          emit(LiftFetchErrorState(e.toString()));
        }
      }

    });
  }
}
