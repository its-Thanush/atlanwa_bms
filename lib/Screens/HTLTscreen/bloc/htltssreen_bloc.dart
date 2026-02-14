import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'htltssreen_event.dart';
part 'htltssreen_state.dart';

class HtltssreenBloc extends Bloc<HtltssreenEvent, HtltssreenState> {
  HtltssreenBloc() : super(HtltssreenInitial()) {
    on<HtltssreenEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
