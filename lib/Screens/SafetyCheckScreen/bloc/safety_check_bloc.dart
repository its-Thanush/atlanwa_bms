import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'safety_check_event.dart';
part 'safety_check_state.dart';

class SafetyCheckBloc extends Bloc<SafetyCheckEvent, SafetyCheckState> {
  SafetyCheckBloc() : super(SafetyCheckInitial()) {
    on<SafetyCheckEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
