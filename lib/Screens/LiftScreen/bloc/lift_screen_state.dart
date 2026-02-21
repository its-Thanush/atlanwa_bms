part of 'lift_screen_bloc.dart';

@immutable
sealed class LiftScreenState {}

final class LiftScreenInitial extends LiftScreenState {}

class LiftFetchLoadingState extends LiftScreenState {}

class LiftFetchSuccessState extends LiftScreenState {
  final LiftFetchModel data;
  LiftFetchSuccessState(this.data);
}

class LiftFetchErrorState extends LiftScreenState {
  final String message;
  LiftFetchErrorState(this.message);
}