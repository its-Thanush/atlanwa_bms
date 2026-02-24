part of 'operating_log_bloc.dart';

@immutable
sealed class OperatingLogEvent {}

final class FetchOperatingLogEvent extends OperatingLogEvent {}

class CreateOpLogEvent extends OperatingLogEvent {
  final String natureOfCall;

  CreateOpLogEvent({required this.natureOfCall});
}

class EditOpLogEvent extends OperatingLogEvent {
  final int logId;
  final String building;
  final String natureOfCall;
  final String workDescription;
  final String status;

  EditOpLogEvent({
    required this.logId,
    required this.building,
    required this.natureOfCall,
    required this.workDescription,
    required this.status,
  });
}
