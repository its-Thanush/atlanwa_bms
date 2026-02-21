
class LiftFetchModel {
  List<Lift>? polygon;
  List<Lift>? palladium;
  List<Lift>? metropolitan;
  List<Lift>? cosmopolitan;
  List<Lift>? cyberTowers;

  LiftFetchModel({
    this.polygon,
    this.palladium,
    this.metropolitan,
    this.cosmopolitan,
    this.cyberTowers,
  });

  LiftFetchModel.fromJson(Map<String, dynamic> json) {
    if (json['PRESTIGE POLYGON'] != null) {
      polygon = (json['PRESTIGE POLYGON'] as List)
          .map((e) => Lift.fromJson(e))
          .toList();
    }

    if (json['PRESTIGE PALLADIUM'] != null) {
      palladium = (json['PRESTIGE PALLADIUM'] as List)
          .map((e) => Lift.fromJson(e))
          .toList();
    }

    if (json['PRESTIGE METROPOLITAN'] != null) {
      metropolitan = (json['PRESTIGE METROPOLITAN'] as List)
          .map((e) => Lift.fromJson(e))
          .toList();
    }

    if (json['PRESTIGE COSMOPOLITAN'] != null) {
      cosmopolitan = (json['PRESTIGE COSMOPOLITAN'] as List)
          .map((e) => Lift.fromJson(e))
          .toList();
    }

    if (json['PRESTIGE CYBER TOWERS'] != null) {
      cyberTowers = (json['PRESTIGE CYBER TOWERS'] as List)
          .map((e) => Lift.fromJson(e))
          .toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (polygon != null) {
      data['PRESTIGE POLYGON'] = polygon!.map((e) => e.toJson()).toList();
    }

    if (palladium != null) {
      data['PRESTIGE PALLADIUM'] = palladium!.map((e) => e.toJson()).toList();
    }

    if (metropolitan != null) {
      data['PRESTIGE METROPOLITAN'] =
          metropolitan!.map((e) => e.toJson()).toList();
    }

    if (cosmopolitan != null) {
      data['PRESTIGE COSMOPOLITAN'] =
          cosmopolitan!.map((e) => e.toJson()).toList();
    }

    if (cyberTowers != null) {
      data['PRESTIGE CYBER TOWERS'] =
          cyberTowers!.map((e) => e.toJson()).toList();
    }

    return data;
  }
}


class Lift {
  String? id;
  String? fl;
  String? alarm;
  String? door;

  Lift({this.id, this.fl, this.alarm, this.door});

  Lift.fromJson(Map<String, dynamic> json) {
    id = json['ID'];
    fl = json['Fl'];
    alarm = json['Alarm'];
    door = json['Door'];
  }

  Map<String, dynamic> toJson() {
    return {
      'ID': id,
      'Fl': fl,
      'Alarm': alarm,
      'Door': door,
    };
  }
}
