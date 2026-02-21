part of 'lift_screen_bloc.dart';

@immutable
sealed class LiftScreenState {}

final class LiftScreenInitial extends LiftScreenState {}

final class LiftFetchSuccessState extends LiftScreenState {}
