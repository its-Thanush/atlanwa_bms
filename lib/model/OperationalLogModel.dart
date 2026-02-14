class OperationallogsModel {
  int? id;
  String? sno;
  String? building;
  String? date;
  String? time;
  String? natureOfCall;
  String? workDescription;
  String? status;
  String? username;
  String? lastUpdatedBy;
  String? lastUpdatedAt;
  String? changeDescription;
  String? createdAt;
  String? updatedAt;
  List<History>? history;

  OperationallogsModel({
    this.id,
    this.sno,
    this.building,
    this.date,
    this.time,
    this.natureOfCall,
    this.workDescription,
    this.status,
    this.username,
    this.lastUpdatedBy,
    this.lastUpdatedAt,
    this.changeDescription,
    this.createdAt,
    this.updatedAt,
    this.history,
  });

  OperationallogsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sno = json['sno'];
    building = json['building'];
    date = json['date'];
    time = json['time'];
    natureOfCall = json['natureOfCall'];
    workDescription = json['workDescription'];
    status = json['status'];
    username = json['username'];
    lastUpdatedBy = json['lastUpdatedBy'];
    lastUpdatedAt = json['lastUpdatedAt'];
    changeDescription = json['changeDescription'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    if (json['history'] != null) {
      history = <History>[];
      json['history'].forEach((v) {
        history!.add(History.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['sno'] = sno;
    data['building'] = building;
    data['date'] = date;
    data['time'] = time;
    data['natureOfCall'] = natureOfCall;
    data['workDescription'] = workDescription;
    data['status'] = status;
    data['username'] = username;
    data['lastUpdatedBy'] = lastUpdatedBy;
    data['lastUpdatedAt'] = lastUpdatedAt;
    data['changeDescription'] = changeDescription;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (history != null) {
      data['history'] = history!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class History {
  int? id;
  int? serviceLogId;
  String? changeType;
  String? changeDescription;
  String? changedBy;
  String? changedAt;
  String? oldValue;
  String? newValue;

  History({
    this.id,
    this.serviceLogId,
    this.changeType,
    this.changeDescription,
    this.changedBy,
    this.changedAt,
    this.oldValue,
    this.newValue,
  });

  History.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    serviceLogId = json['serviceLogId'];
    changeType = json['changeType'];
    changeDescription = json['changeDescription'];
    changedBy = json['changedBy'];
    changedAt = json['changedAt'];
    oldValue = json['oldValue'];
    newValue = json['newValue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['serviceLogId'] = serviceLogId;
    data['changeType'] = changeType;
    data['changeDescription'] = changeDescription;
    data['changedBy'] = changedBy;
    data['changedAt'] = changedAt;
    data['oldValue'] = oldValue;
    data['newValue'] = newValue;
    return data;
  }
}