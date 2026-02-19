part of 'safety_check_bloc.dart';

@immutable
sealed class SafetyCheckEvent {}

class FireFetchEvent extends SafetyCheckEvent{}

class FireSubmitEvent extends SafetyCheckEvent{}