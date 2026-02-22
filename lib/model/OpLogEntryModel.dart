class OpLogEntryRS {
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

  OpLogEntryRS(
      {this.id,
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
        this.history});

  OpLogEntryRS.fromJson(Map<String, dynamic> json) {
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
        history!.add(new History.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['sno'] = this.sno;
    data['building'] = this.building;
    data['date'] = this.date;
    data['time'] = this.time;
    data['natureOfCall'] = this.natureOfCall;
    data['workDescription'] = this.workDescription;
    data['status'] = this.status;
    data['username'] = this.username;
    data['lastUpdatedBy'] = this.lastUpdatedBy;
    data['lastUpdatedAt'] = this.lastUpdatedAt;
    data['changeDescription'] = this.changeDescription;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.history != null) {
      data['history'] = this.history!.map((v) => v.toJson()).toList();
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

  History(
      {this.id,
        this.serviceLogId,
        this.changeType,
        this.changeDescription,
        this.changedBy,
        this.changedAt,
        this.oldValue,
        this.newValue});

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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['serviceLogId'] = this.serviceLogId;
    data['changeType'] = this.changeType;
    data['changeDescription'] = this.changeDescription;
    data['changedBy'] = this.changedBy;
    data['changedAt'] = this.changedAt;
    data['oldValue'] = this.oldValue;
    data['newValue'] = this.newValue;
    return data;
  }
}


class OpLogEntryRQ {
  String? building;
  String? natureOfCall;
  String? workDescription;
  String? status;
  String? username;

  OpLogEntryRQ(
      {this.building,
        this.natureOfCall,
        this.workDescription,
        this.status,
        this.username});

  OpLogEntryRQ.fromJson(Map<String, dynamic> json) {
    building = json['building'];
    natureOfCall = json['natureOfCall'];
    workDescription = json['workDescription'];
    status = json['status'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['building'] = this.building;
    data['natureOfCall'] = this.natureOfCall;
    data['workDescription'] = this.workDescription;
    data['status'] = this.status;
    data['username'] = this.username;
    return data;
  }
}
