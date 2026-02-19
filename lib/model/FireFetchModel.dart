class FireFetchRQ {
  String? tagId;
  String? buildingName;

  FireFetchRQ({this.tagId, this.buildingName});

  FireFetchRQ.fromJson(Map<String, dynamic> json) {
    tagId = json['tag_id'];
    buildingName = json['building_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tag_id'] = this.tagId;
    data['building_name'] = this.buildingName;
    return data;
  }
}



class FireFetchRS {
  bool? success;
  String? message;
  List<Questions>? questions;

  FireFetchRS({this.success, this.message, this.questions});

  FireFetchRS.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['questions'] != null) {
      questions = <Questions>[];
      json['questions'].forEach((v) {
        questions!.add(new Questions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.questions != null) {
      data['questions'] = this.questions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Questions {
  String? question;
  String? option1;
  String? option2;
  String? option3;

  Questions({this.question, this.option1, this.option2, this.option3});

  Questions.fromJson(Map<String, dynamic> json) {
    question = json['question'];
    option1 = json['option1'];
    option2 = json['option2'];
    option3 = json['option3'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['question'] = this.question;
    data['option1'] = this.option1;
    data['option2'] = this.option2;
    data['option3'] = this.option3;
    return data;
  }

  List<String> get availableOptions {
    return [option1, option2, option3]
        .where((o) => o != null && o.trim().isNotEmpty)
        .map((o) => o!)
        .toList();
  }

}
