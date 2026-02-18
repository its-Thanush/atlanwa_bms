class GuardEntryRQ {
  String? tagId;
  String? username;
  String? building;

  GuardEntryRQ({this.tagId, this.username, this.building});

  GuardEntryRQ.fromJson(Map<String, dynamic> json) {
    tagId = json['tagId'];
    username = json['username'];
    building = json['building'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tagId'] = this.tagId;
    data['username'] = this.username;
    data['building'] = this.building;
    return data;
  }
}


class GuardEntryRS {
  bool? success;
  String? message;
  String? location;
  String? floor;

  GuardEntryRS({this.success, this.message, this.location, this.floor});

  GuardEntryRS.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    location = json['location'];
    floor = json['floor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    data['location'] = this.location;
    data['floor'] = this.floor;
    return data;
  }
}
