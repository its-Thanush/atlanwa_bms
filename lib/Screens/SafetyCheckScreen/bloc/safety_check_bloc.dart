import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../allImports.dart';
import '../../../model/FireFetchModel.dart';
import '../../../model/FireSubmitModel.dart';
import '../../../network/ApiService.dart';

part 'safety_check_event.dart';
part 'safety_check_state.dart';

class SafetyCheckBloc extends Bloc<SafetyCheckEvent, SafetyCheckState> {

  List<Questions> checkpoints =[];
  bool isResponseCame = true;


  late AnimationController fadeController;
  late AnimationController slideController;
  late Animation<double> fadeAnimation;
  late Animation<Offset> slideAnimation;

  List<int> selectedAnswerIndex =[];
  final TextEditingController remarksController = TextEditingController();
  late Timer timer;
  DateTime currentTime = DateTime.now();


  SafetyCheckBloc() : super(SafetyCheckInitial()) {
    on<SafetyCheckEvent>((event, emit) async {
      // TODO: implement event handler

      if(event is FireFetchEvent){
        FireFetchRQ req = FireFetchRQ();
        req.tagId="456";
        req.buildingName="PRESTIGE POLYGON";

        print("---REQ--- ${jsonEncode(req)}");

        await ApiServices.FireFetch(req).then((value) async {

          if (value.success == true) {
            checkpoints = value.questions!;
            selectedAnswerIndex = List.filled(checkpoints.length, -1);
            isResponseCame = true;
            emit(FireFetchSuccessState());
          }else{
            emit(FireFetchFailedState());
          }

        });
      }

      if (event is FireSubmitEvent) {
        final unanswered = selectedAnswerIndex.where((i) => i == -1).length;
        if (unanswered > 0) {
          emit(FireSubmitValidationFailedState(unanswered));
          return;
        }
        final Map<String, String> answersMap = {};
        for (int i = 0; i < checkpoints.length; i++) {
          final question = checkpoints[i].question ?? '';
          final selectedOption = checkpoints[i].availableOptions[selectedAnswerIndex[i]];
          answersMap[question] = selectedOption;
        }

        FireSubmitRQ req = FireSubmitRQ();
        req.tagId = "456";
        req.buildingName = "PRESTIGE POLYGON";
        req.username = Utilities.userName;
        req.type = "Fire Hydrant cabinet";
        req.questions = AnsweredQuestions(answers: answersMap);
        req.remarks = remarksController.text;

        print("---REQ--- ${jsonEncode(req)}");

        await ApiServices.FireSubmit(req).then((value) async {
          if (value.success == true) {
            emit(FireSubmitSuccessState());
          } else {
            emit(FireSubmitFailedState());
          }
        });
      }



    });

  }
}
