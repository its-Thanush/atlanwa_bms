part of 'operating_log_bloc.dart';

@immutable
sealed class OperatingLogEvent {}

final class FetchOperatingLogEvent extends OperatingLogEvent {}

class CreateOpLogEvent extends OperatingLogEvent {}
