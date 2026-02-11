class LoginRQ {
  String? username;
  String? password;

  LoginRQ({this.username, this.password});

  LoginRQ.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['password'] = this.password;
    return data;
  }
}


class LoginRS {
  bool? success;
  String? name;
  List<String>? buildings;

  LoginRS({this.success, this.name, this.buildings});

  LoginRS.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    name = json['name'];
    buildings = json['buildings'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['name'] = this.name;
    data['buildings'] = this.buildings;
    return data;
  }
}
