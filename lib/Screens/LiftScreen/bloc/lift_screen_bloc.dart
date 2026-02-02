import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'lift_screen_event.dart';
part 'lift_screen_state.dart';

class LiftScreenBloc extends Bloc<LiftScreenEvent, LiftScreenState> {
  LiftScreenBloc() : super(LiftScreenInitial()) {
    on<LiftScreenEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
