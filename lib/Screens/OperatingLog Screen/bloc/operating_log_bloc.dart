import 'dart:convert';

import 'package:atlanwa_bms/allImports.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../model/OpEditLogModel.dart';
import '../../../model/OpLogEntryModel.dart';
import '../../../model/OperationalLogModel.dart';
import '../../../network/ApiService.dart';

part 'operating_log_event.dart';
part 'operating_log_state.dart';

class OperatingLogBloc extends Bloc<OperatingLogEvent, OperatingLogState> {
  TextEditingController workDescriptionController = TextEditingController();

  OperatingLogBloc() : super(OperatingLogInitial()) {
    on<OperatingLogEvent>((event, emit) async {
      if (event is FetchOperatingLogEvent) {
        emit(OperatingLogLoading());
        try {
          final logs = await ApiServices.getOperatingLogs();
          emit(OperatingLogLoaded(logs: logs));
        } catch (e) {
          emit(OperatingLogError(message: e.toString()));
        }
      }

      if (event is CreateOpLogEvent) {
        emit(OperatingLogLoading());
        OpLogEntryRQ req = OpLogEntryRQ();
        req.building = Utilities.selectedBuilding;
        req.natureOfCall = event.natureOfCall;
        req.workDescription = workDescriptionController.text;
        req.status = "open";
        req.username = Utilities.userName;

        print("Req----->" + jsonEncode(req));

        try {
          await ApiServices.OperatorLogEntry(req);
          emit(OpSubmitSuccessState());
        } catch (e) {
          emit(OpSubmitFailedState());
        }
      }

      if (event is EditOpLogEvent) {
        emit(OperatingLogLoading());
        OpLogEditRQ req = OpLogEditRQ();

        req.building = event.building;
        req.natureOfCall = event.natureOfCall;
        req.workDescription = event.workDescription;
        req.status = event.status;
        req.username = Utilities.userName;
        req.lastUpdatedBy = Utilities.userName;
        req.historyEntries = [];

        print("Req----->" + jsonEncode(req));

        try {
          await ApiServices.EditOperatingLogEntry(event.logId, req);
          emit(OpSubmitSuccessState());
        } catch (e) {
          emit(OpSubmitFailedState());
        }
      }
    });
  }
}
