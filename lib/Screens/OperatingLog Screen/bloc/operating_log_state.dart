part of 'operating_log_bloc.dart';

@immutable
sealed class OperatingLogState {}

class OperatingLogInitial extends OperatingLogState {}

class OperatingLogLoading extends OperatingLogState {}

class OperatingLogLoaded extends OperatingLogState {
  final List<OperationallogsModel> logs;

  OperatingLogLoaded({required this.logs});
}

class OperatingLogError extends OperatingLogState {
  final String message;

  OperatingLogError({required this.message});
}

class OpSubmitSuccessState extends OperatingLogState{}

class OpSubmitFailedState extends OperatingLogState{}