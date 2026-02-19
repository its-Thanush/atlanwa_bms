class FireSubmitRQ {
  String? tagId;
  String? buildingName;
  String? username;
  String? type;
  AnsweredQuestions? questions;
  String? remarks;

  FireSubmitRQ(
      { this.tagId,
        this.buildingName,
        this.username,
        this.type,
        this.questions,
        this.remarks
      });

  FireSubmitRQ.fromJson(Map<String, dynamic> json) {
    tagId = json['tag_id'];
    buildingName = json['building_name'];
    username = json['username'];
    type = json['type'];
    questions = json['questions'] != null
        ? new AnsweredQuestions.fromJson(json['questions'])
        : null;
    remarks = json['remarks'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tag_id'] = this.tagId;
    data['building_name'] = this.buildingName;
    data['username'] = this.username;
    data['type'] = this.type;
    if (this.questions != null) {
      data['questions'] = this.questions!.toJson();
    }
    data['remarks'] = this.remarks;
    return data;
  }
}

class AnsweredQuestions {
  final Map<String, String> answers;

  AnsweredQuestions({required this.answers});

  AnsweredQuestions.fromJson(Map<String, dynamic> json)
      : answers = json.map((k, v) => MapEntry(k, v.toString()));

  Map<String, dynamic> toJson() => answers;
}

class FireSubmitRS {
  bool? success;
  String? message;
  int? logId;

  FireSubmitRS({this.success, this.message, this.logId});

  FireSubmitRS.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    logId = json['logId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    data['logId'] = this.logId;
    return data;
  }
}



