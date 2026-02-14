import 'package:atlanwa_bms/allImports.dart';
import '../Screens/GaurdTouringScreen/GaurdTouring.dart';
import '../Screens/GaurdTouringScreen/bloc/gaurd_touring_bloc.dart';
import '../Screens/HTLTscreen/HTLTscreen.dart';
import '../Screens/HTLTscreen/bloc/htltssreen_bloc.dart';
import '../Screens/LiftScreen/LiftScreen.dart';
import '../Screens/LiftScreen/bloc/lift_screen_bloc.dart';
import '../Screens/OperatingLog Screen/OperatingLog.dart';
import '../Screens/OperatingLog Screen/bloc/operating_log_bloc.dart';
import '../Screens/SafetyCheckScreen/SafetyCheckScreen.dart';
import '../Screens/SafetyCheckScreen/bloc/safety_check_bloc.dart';




final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRoutes{

  AppRoutes._();

  static GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    routerNeglect: true,
    initialLocation: '/splash',
    routes: <RouteBase>[
      GoRoute(
          name: 'splash',
          path: '/splash',
          builder: (context, state) => Splashscreen()
      ),
      GoRoute(
          name: 'login',
          path: '/login',
          builder: (context, state) => BlocProvider(
            lazy: false,
            create: (_) => LoginScreenBloc(),
            child:  Loginscreen(),
          )
      ),
      GoRoute(
          name: 'home',
          path: '/home',
          builder: (context, state) => BlocProvider(
            lazy: false,
            create: (_) => HomeScreenBloc(),
            child: HomeScreen(extra: state.extra as Map<String, dynamic>?),
          )
      ),
      GoRoute(
          name: 'lift',
          path: '/lift',
          builder: (context, state) => BlocProvider(
            lazy: false,
            create: (_) => LiftScreenBloc(),
            child:  LiftScreen(),
          )
      ),
      GoRoute(
          name: 'safety',
          path: '/safety',
          builder: (context, state) => BlocProvider(
            lazy: false,
            create: (_) => SafetyCheckBloc(),
            child:  Safetycheckscreen(),
          )
      ),
      GoRoute(
          name: 'touring',
          path: '/touring',
          builder: (context, state) => BlocProvider(
            lazy: false,
            create: (_) => GaurdTouringBloc(),
            child:  Gaurdtouring(),
          )
      ),
      GoRoute(
          name: 'operatinglog',
          path: '/operatinglog',
          builder: (context, state) => BlocProvider(
            lazy: false,
            create: (_) => OperatingLogBloc(),
            child:  OperatingLog(),
          )
      ),
      GoRoute(
          name: 'Htltscreen',
          path: '/Htltscreen',
          builder: (context, state) => BlocProvider(
            lazy: false,
            create: (_) => HtltssreenBloc(),
            child:  Htltscreen(),
          )
      ),



    ],
      errorPageBuilder: (context, state) => MaterialPage(
       key: state.pageKey,
        child: Errorscreen(),
        ),
  );

}