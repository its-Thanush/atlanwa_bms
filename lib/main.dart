import 'package:flutter/material.dart';
import 'package:atlanwa_bms/allImports.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    final sessionConfig = SessionConfig(
      invalidateSessionForAppLostFocus: const Duration(minutes: 180),
      invalidateSessionForUserInactivity: const Duration(minutes: 180),
    );

    return SessionTimeoutManager(
      userActivityDebounceDuration: const Duration(seconds: 3),
      sessionConfig: sessionConfig,
      sessionStateStream: Utilities.sessionStateStream.stream,
      child: MaterialApp.router(
          title:"Atlanwa BMS",
            theme: ThemeData(
              primarySwatch: Colors.blue,
              useMaterial3: true,
            ),
        debugShowCheckedModeBanner: false,
        builder: EasyLoading.init(),
        routerConfig: AppRoutes.router,
      ),
    );

  }
}

// return BlocProvider<LoginScreenBloc>(
//   create: (context) => LoginScreenBloc(),
//   child: MaterialApp(
//     debugShowCheckedModeBanner: false,
//     title: 'Atlanwa BMS',
//     theme: ThemeData(
//       primarySwatch: Colors.blue,
//       useMaterial3: true,
//     ),
//     home: Loginscreen(),
//
//   ),
// );

