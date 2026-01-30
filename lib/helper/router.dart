import 'package:atlanwa_bms/allImports.dart';




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
            child:  HomeScreen(),
          )
      ),

    ],
      errorPageBuilder: (context, state) => MaterialPage(
       key: state.pageKey,
        child: Errorscreen(),
        ),
  );

}