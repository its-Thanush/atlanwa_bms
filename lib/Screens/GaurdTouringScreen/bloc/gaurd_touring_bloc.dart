import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'gaurd_touring_event.dart';
part 'gaurd_touring_state.dart';

class GaurdTouringBloc extends Bloc<GaurdTouringEvent, GaurdTouringState> {
  GaurdTouringBloc() : super(GaurdTouringInitial()) {
    on<GaurdTouringEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
