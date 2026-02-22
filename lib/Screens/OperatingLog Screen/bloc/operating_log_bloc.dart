import 'package:atlanwa_bms/allImports.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../model/OpLogEntryModel.dart';
import '../../../model/OperationalLogModel.dart';
import '../../../network/ApiService.dart';

part 'operating_log_event.dart';
part 'operating_log_state.dart';

class OperatingLogBloc extends Bloc<OperatingLogEvent, OperatingLogState> {
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

      if(event is CreateOpLogEvent){
        OpLogEntryRQ req = OpLogEntryRQ();
        req.building="";
        req.natureOfCall="";
        req.workDescription="";
        req.status="";
        req.username=Utilities.userName;

      }

    });
  }
}
