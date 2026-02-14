import 'dart:async';

import 'package:atlanwa_bms/allImports.dart';
import 'package:local_session_timeout/local_session_timeout.dart';

class Utilities {
  static final sessionStateStream = StreamController<SessionState>();

  static String userName = "";
  static List<String> buildings = [];

  static Future<void> loadSession() async {
    final prefs = await SharedPreferences.getInstance();

    userName = prefs.getString('userName') ?? '';
    buildings = prefs.getStringList('buildings') ?? [];
  }
}
