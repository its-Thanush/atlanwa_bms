import 'dart:convert';
import 'dart:io';

import 'package:atlanwa_bms/allImports.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gap/gap.dart';

import '../../../Widgets/CommonNfcAuth.dart';
import '../../../model/FireFetchModel.dart';
import '../../../network/ApiService.dart';

class HomeScreenM extends StatefulWidget {
  final Map<String, dynamic>? extra;

  const HomeScreenM({super.key, this.extra});

  @override
  State<HomeScreenM> createState() => _HomeScreenMState();
}

class _HomeScreenMState extends State<HomeScreenM> {
  late HomeScreenBloc bloc;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime? _lastBackPressed;

  final Set<String> _comingSoonRoutes = {
    // 'operating_log',
    'stp_automation',
    'parking_slots',
  };

  final List<BMSModuleItem> bmsModules = [
    BMSModuleItem(
      title: 'Lift Status',
      icon: Icons.elevator,
      color: liftStatusPrimary,
      lightColor: liftStatusLight,
      description: 'Monitor elevator operations',
      route: 'lift_status',
    ),
    BMSModuleItem(
      title: 'Operating Log',
      icon: Icons.history,
      color: operatingLogPrimary,
      lightColor: operatingLogLight,
      description: 'View system operations log',
      route: 'operating_log',
    ),
    BMSModuleItem(
      title: 'HT/LT Panel',
      icon: Icons.settings_input_component,
      color: htltPanelPrimary,
      lightColor: htltPanelLight,
      description: 'High/Low tension panels',
      route: 'ht_lt_panel',
    ),
    BMSModuleItem(
      title: 'STP Automation',
      icon: Icons.water_drop,
      color: stpAutomationPrimary,
      lightColor: stpAutomationLight,
      description: 'Sewage treatment plant',
      route: 'stp_automation',
    ),
    BMSModuleItem(
      title: 'Parking Slots',
      icon: Icons.local_parking,
      color: parkingSlotsPrimary,
      lightColor: parkingSlotsLight,
      description: 'Check slot availability',
      route: 'parking_slots',
    ),
    BMSModuleItem(
      title: 'Safety Check',
      icon: Icons.verified_user,
      color: safetyCheckPrimary,
      lightColor: safetyCheckLight,
      description: 'Safety compliance monitoring',
      route: 'safety_check',
    ),
    BMSModuleItem(
      title: 'Guard Touring',
      icon: Icons.security,
      color: guardTouringPrimary,
      lightColor: guardTouringLight,
      description: 'Security patrol tracking',
      route: 'guard_touring',
    ),
  ];

  @override
  void initState() {
    bloc = BlocProvider.of<HomeScreenBloc>(context);
    _loadUserData();

    super.initState();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final storage = FlutterSecureStorage();

    setState(() {
      Utilities.userName = prefs.getString('userName')!;
      Utilities.buildings = prefs.getStringList('buildings') ?? [];
      if (Utilities.buildings.isNotEmpty && Utilities.selectedBuilding.isEmpty) {
        Utilities.selectedBuilding = Utilities.buildings.first;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        final now = DateTime.now();
        final isDoubleBack =
            _lastBackPressed != null &&
            now.difference(_lastBackPressed!) < Duration(seconds: 2);
        if (isDoubleBack) {
          exit(0);
        } else {
          _lastBackPressed = now;
          _showExitSnackbar();
        }
      },
      child: BlocListener<HomeScreenBloc, HomeScreenState>(
        listener: (context, state) {},
        child: BlocBuilder<HomeScreenBloc, HomeScreenState>(
          builder: (context, state) {
            return Scaffold(
              key: _scaffoldKey,
              appBar: _buildAppBar(),
              drawer: _buildDrawer(),
              backgroundColor: Background,
              body: _buildBody(),
            );
          },
        ),
      ),
    );
  }

  void _showExitSnackbar() {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        backgroundColor: Color(0xFF1E1E2E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: Duration(seconds: 2),
        content: Row(
          children: [
            Icon(Icons.exit_to_app_rounded, color: primaryColor, size: 20),
            Gap(12),
            CustomText(
              text: 'Press back again to exit',
              color: white,
              size: SizeConfig.smallSubText,
              weight: FontWeight.w500,
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: primaryColor,
      leading: IconButton(
        onPressed: () {
          _scaffoldKey.currentState!.openDrawer();
        },
        icon: Icon(Icons.menu, color: white),
        splashRadius: 24,
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomText(
            text: 'Atlanwa BMS',
            color: white,
            size: SizeConfig.titleText,
            weight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
          CustomText(
            text: 'Building Management System',
            color: white.withOpacity(0.7),
            size: SizeConfig.tinyText,
            weight: FontWeight.w400,
            letterSpacing: 0.3,
          ),
        ],
      ),
      // actions: [
      //   Container(
      //     margin: EdgeInsets.only(right: 8),
      //     child: Center(
      //       child: IconButton(
      //         onPressed: () {},
      //         icon: Icon(Icons.logout, color: white),
      //         tooltip: 'Logout',
      //         splashRadius: 24,
      //       ),
      //     ),
      //   ),
      // ],
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      width: 280,
      backgroundColor: white,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primaryColor, primaryColor1],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.15),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            padding: EdgeInsets.only(top: 40, bottom: 20, left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.domain, color: white, size: 32),
                ),
                Gap(SizeConfig.smalltinyText!),
                CustomText(
                  text: Utilities.userName,
                  color: white,
                  size: SizeConfig.medtitleText,
                  weight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
                Gap(4),
                CustomText(
                  text: 'Admin Access',
                  color: white.withOpacity(0.7),
                  size: SizeConfig.smalltinyText,
                  weight: FontWeight.w400,
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (Utilities.buildings.isNotEmpty == true) ...[
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        child: CustomText(
                          text: 'YOUR BUILDINGS',
                          color: primaryColor,
                          size: SizeConfig.smalltinyText,
                          weight: FontWeight.w700,
                          letterSpacing: 0.8,
                        ),
                      ),
                      Gap(8),
                      ...Utilities.buildings.map((building) {
                        final isSelected =
                            Utilities.selectedBuilding == building;
                        return Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            // CHANGE: highlight selected with solid light purple, else transparent
                            color: isSelected
                                ? primaryColor.withOpacity(0.12)
                                : primaryColor.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              // CHANGE: stronger border when selected
                              color: isSelected
                                  ? primaryColor.withOpacity(0.5)
                                  : primaryColor.withOpacity(0.1),
                              width: isSelected ? 1.5 : 1,
                            ),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  Utilities.selectedBuilding = building;
                                });
                                Navigator.pop(context);
                              },
                              borderRadius: BorderRadius.circular(10),
                              splashColor: primaryColor.withOpacity(0.1),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 36,
                                      height: 36,
                                      decoration: BoxDecoration(
                                        // CHANGE: icon bg stronger when selected
                                        color: isSelected
                                            ? primaryColor.withOpacity(0.25)
                                            : primaryColor.withOpacity(0.15),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(
                                        Icons.apartment_rounded,
                                        color: primaryColor,
                                        size: 18,
                                      ),
                                    ),
                                    Gap(12),
                                    Expanded(
                                      child: CustomText(
                                        text: building,
                                        color: isSelected
                                            ? primaryColor
                                            : TextColourBlk,
                                        size: SizeConfig.smallSubText,
                                        weight: isSelected
                                            ? FontWeight.w700
                                            : FontWeight.w600,
                                        maxLines: 2,
                                        textOverflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Icon(
                                      isSelected
                                          ? Icons.check_circle_rounded
                                          : Icons.arrow_forward_ios_rounded,
                                      color: isSelected
                                          ? primaryColor
                                          : primaryColor.withOpacity(0.4),
                                      size: isSelected ? 18 : 14,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                      Gap(SizeConfig.commonMargin! * 2),
                    ],
                  ],
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: GreyColourAsh.withOpacity(0.1),
                  width: 1,
                ),
              ),
            ),
            padding: EdgeInsets.all(12),
            child: _drawerTile(
              icon: Icons.logout_rounded,
              title: 'Logout',
              onTap: () async {
                showDialog(
                  context: context,
                  barrierColor: Colors.black.withOpacity(0.5),
                  builder: (BuildContext context) {
                    return Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      backgroundColor: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.all(
                          SizeConfig.maxHeightAndWidth! * 1.2,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Icon Container
                            Container(
                              padding: EdgeInsets.all(
                                SizeConfig.bigHeightAndWidth!,
                              ),
                              decoration: BoxDecoration(
                                color: statusError.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.logout_rounded,
                                color: statusError,
                                size: SizeConfig.bigText!,
                              ),
                            ),

                            SizedBox(height: SizeConfig.bigHeightAndWidth!),

                            // Title
                            CustomText(
                              text: 'Are you sure?',
                              size: SizeConfig.medtitleText,
                              weight: FontWeight.bold,
                              color: TextColourBlk,
                            ),

                            SizedBox(height: SizeConfig.heightAndWidth!),

                            // Subtitle
                            CustomText(
                              text: 'You will be logged out of your account.',
                              size: SizeConfig.smallSubText,
                              color: TextColourAsh,
                              textAlign: TextAlign.center,
                            ),

                            SizedBox(
                              height: SizeConfig.maxHeightAndWidth! * 1.5,
                            ),

                            // Buttons Row
                            Row(
                              children: [
                                // Cancel Button
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => Navigator.pop(context),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        vertical: SizeConfig.bigHeightAndWidth!,
                                      ),
                                      decoration: BoxDecoration(
                                        color: GreyColourAsh,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                        child: CustomText(
                                          text: 'Cancel',
                                          size: SizeConfig.subText,
                                          weight: FontWeight.w600,
                                          color: TextColourBlk,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                SizedBox(width: SizeConfig.heightAndWidth!),

                                // Logout Button
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () async {
                                      Navigator.pop(context);
                                      final prefs =
                                          await SharedPreferences.getInstance();
                                      await prefs.remove('userName');
                                      await prefs.remove('buildings');
                                      if (mounted) {
                                        context.go('/login');
                                      }
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        vertical: SizeConfig.bigHeightAndWidth!,
                                      ),
                                      decoration: BoxDecoration(
                                        color: statusError,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                        child: CustomText(
                                          text: 'Logout',
                                          size: SizeConfig.subText,
                                          weight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              isLogout: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _drawerTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isLogout ? statusError : primaryColor,
        size: 22,
      ),
      title: CustomText(
        text: title,
        color: isLogout ? statusError : primaryColor1,
        size: SizeConfig.smallSubText,
        weight: FontWeight.w600,
        letterSpacing: 0.2,
      ),
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      hoverColor: GreyColourAsh.withOpacity(0.1),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(top: 24, left: 16, right: 16, bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_buildWelcomeSection(), Gap(32), _buildModulesGrid()],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryColor, primaryColor1, primaryColor2],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.15),
            blurRadius: 24,
            offset: Offset(0, 8),
          ),
        ],
      ),
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: 'Welcome ${Utilities.userName ?? 'User'}',
            color: white.withOpacity(0.8),
            size: SizeConfig.smallSubText,
            weight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
          Gap(5),
          CustomText(
            text: Utilities.selectedBuilding,
            color: white,
            size: SizeConfig.medbigText,
            weight: FontWeight.w700,
          ),
          Gap(5),
          Row(
            children: [
              Container(
                width: 4,
                height: 24,
                decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Gap(12),
              Expanded(
                child: CustomText(
                  text:
                      'Monitor and control all your building management modules in one unified interface',
                  color: white,
                  size: SizeConfig.smallSubText,
                  weight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildModulesGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.95,
      ),
      itemCount: bmsModules.length,
      itemBuilder: (context, index) {
        return _buildModuleCard(bmsModules[index]);
      },
    );
  }

  Widget _buildModuleCard(BMSModuleItem module) {
    return GestureDetector(
      onTap: () {
        _navigateToModule(module.route);
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: cardBackground,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: module.color.withOpacity(0.08),
                blurRadius: 20,
                offset: Offset(0, 4),
              ),
            ],
            border: Border.all(color: module.color.withOpacity(0.1), width: 1),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _navigateToModule(module.route),
              borderRadius: BorderRadius.circular(16),
              splashColor: module.color.withOpacity(0.1),
              highlightColor: module.color.withOpacity(0.05),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Gap(15),
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: module.lightColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(module.icon, color: module.color, size: 28),
                    ),
                    Gap(15),
                    Column(
                      children: [
                        CustomText(
                          text: module.title,
                          textAlign: TextAlign.center,
                          color: TextColourBlk,
                          size: SizeConfig.subText,
                          weight: FontWeight.bold,
                        ),
                        Gap(8),
                        CustomText(
                          text: module.description,
                          textAlign: TextAlign.center,
                          color: TextColourAsh.withOpacity(0.6),
                          size: SizeConfig.tinyText,
                          weight: FontWeight.w400,
                          textOverflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToModule(String route) {
    if (_comingSoonRoutes.contains(route)) {
      _showComingSoonSnackbar();
      return;
    }

    if (route == 'safety_check') {
      final nfcKey = GlobalKey<CommonNFCAuthState>();

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CommonNFCAuth(
            key: nfcKey,
            topic: 'Safety Check',
            userName: Utilities.userName,
            building: Utilities.selectedBuilding,
            setAuth: false,
            authorizedId: '',
            onAuthSuccess: (scannedId) async {
              Utilities.nfcAuth = scannedId;

              FireFetchRQ req = FireFetchRQ();
              req.tagId = Utilities.nfcAuth;
              req.buildingName = Utilities.selectedBuilding;

              print("---REQ--- ${jsonEncode(req)}");

              try {
                final value = await ApiServices.FireFetch(req);

                if (value.success == true) {
                  // ✅ Success — show on NFC screen then navigate
                  nfcKey.currentState?.showApiSuccess();
                  await Future.delayed(const Duration(milliseconds: 1200));
                  Navigator.pop(context);
                  context.goNamed('safety');
                } else {
                  // ❌ API denied — show denied on NFC screen
                  Utilities.AUTHfailed = true;
                  nfcKey.currentState?.showApiDenied(
                    'Access Denied – Unauthorized Card',
                  );
                }
              } catch (e) {
                // ❌ Error — show denied on NFC screen
                Utilities.AUTHfailed = true;
                print("FireFetch error: $e");
                nfcKey.currentState?.showApiDenied(
                  'Something went wrong. Please try again.',
                );
              }
            },
          ),
        ),
      );
      return;
    }

    final routeMap = {
      'lift_status': 'lift',
      'operating_log': 'operatinglog',
      'ht_lt_panel': 'Htltscreen',
      'stp_automation': 'stp_automation',
      'parking_slots': 'parking_slots',
      'guard_touring': 'touring',
      'safety_check': 'safety',
    };

    final namedRoute = routeMap[route];

    if (namedRoute != null) {
      context.pushNamed(namedRoute);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: CustomText(
            text: 'Route not found: $route',
            color: white,
            size: SizeConfig.smallSubText,
          ),
          duration: Duration(milliseconds: 800),
          backgroundColor: statusError,
        ),
      );
    }
  }

  void _showComingSoonSnackbar() {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        backgroundColor: Color(0xFF1E1E2E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: Duration(seconds: 2),
        content: Row(
          children: [
            Icon(Icons.construction_rounded, color: SecondaryColor, size: 20),
            Gap(12),
            CustomText(
              text: 'Coming Soon',
              color: white,
              size: SizeConfig.smallSubText,
              weight: FontWeight.w500,
            ),
          ],
        ),
      ),
    );
  }
}

class BMSModuleItem {
  final String title;
  final IconData icon;
  final Color color;
  final Color lightColor;
  final String description;
  final String route;

  BMSModuleItem({
    required this.title,
    required this.icon,
    required this.color,
    required this.lightColor,
    required this.description,
    required this.route,
  });
}
