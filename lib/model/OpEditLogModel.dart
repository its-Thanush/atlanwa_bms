class OpLogEditRQ {
  String? building;
  String? natureOfCall;
  String? workDescription;
  String? status;
  String? username;
  String? lastUpdatedBy;
  List<String>? historyEntries;

  OpLogEditRQ(
      {this.building,
        this.natureOfCall,
        this.workDescription,
        this.status,
        this.username,
        this.lastUpdatedBy,
        this.historyEntries});

  OpLogEditRQ.fromJson(Map<String, dynamic> json) {
    building = json['building'];
    natureOfCall = json['natureOfCall'];
    workDescription = json['workDescription'];
    status = json['status'];
    username = json['username'];
    lastUpdatedBy = json['lastUpdatedBy'];
    historyEntries = json['historyEntries'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['building'] = this.building;
    data['natureOfCall'] = this.natureOfCall;
    data['workDescription'] = this.workDescription;
    data['status'] = this.status;
    data['username'] = this.username;
    data['lastUpdatedBy'] = this.lastUpdatedBy;
    data['historyEntries'] = this.historyEntries;
    return data;
  }
}
