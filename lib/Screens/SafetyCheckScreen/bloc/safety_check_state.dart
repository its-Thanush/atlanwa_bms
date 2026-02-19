part of 'safety_check_bloc.dart';

@immutable
sealed class SafetyCheckState {}

final class SafetyCheckInitial extends SafetyCheckState {}

 class FireFetchSuccessState extends SafetyCheckState {}

class FireFetchFailedState extends SafetyCheckState {}


class FireSubmitSuccessState extends SafetyCheckState {}

class FireSubmitFailedState extends SafetyCheckState {}


class FireSubmitValidationFailedState extends SafetyCheckState {
 final int unansweredCount;
 FireSubmitValidationFailedState(this.unansweredCount);
}

