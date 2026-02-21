import 'dart:async';

import 'package:atlanwa_bms/allImports.dart';
import 'package:gap/gap.dart';
import '../../../model/LiftFetchModel.dart';
import '../bloc/lift_screen_bloc.dart';

class LiftScreenM extends StatefulWidget {
  const LiftScreenM({super.key});

  @override
  State<LiftScreenM> createState() => _LiftScreenMState();
}

class _LiftScreenMState extends State<LiftScreenM> with TickerProviderStateMixin {
  late LiftScreenBloc bloc;

  Timer? _pollingTimer;

  String _selectedBuilding = 'PRESTIGE POLYGON';
  List<Lift> _currentLifts = [];
  LiftFetchModel? _fetchedData;

  final List<String> _buildings = [
    'PRESTIGE POLYGON',
    'PRESTIGE PALLADIUM',
    'PRESTIGE METROPOLITAN',
    'PRESTIGE COSMOPOLITAN',
    'PRESTIGE CYBER TOWERS',
  ];

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<LiftScreenBloc>(context);
    _initAnimations();
    _pollingTimer = Timer.periodic(
      const Duration(milliseconds: 500),
          (_) => bloc.add(LiftFetchEvent()),
    );

  }

  void _initAnimations() {
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  List<Lift> _getLiftsForBuilding(LiftFetchModel data, String building) {
    switch (building) {
      case 'PRESTIGE POLYGON':      return data.polygon ?? [];
      case 'PRESTIGE PALLADIUM':    return data.palladium ?? [];
      case 'PRESTIGE METROPOLITAN': return data.metropolitan ?? [];
      case 'PRESTIGE COSMOPOLITAN': return data.cosmopolitan ?? [];
      case 'PRESTIGE CYBER TOWERS': return data.cyberTowers ?? [];
      default: return [];
    }
  }

  Color _getLiftColor(Lift lift) {
    if (lift.alarm == '1') return statusError;
    if (lift.fl == '?')    return statusInactive;
    final fl = lift.fl ?? '';
    if (fl == 'G' || fl == '0') return statusWarning;
    if (fl.startsWith('B') || fl.startsWith('-')) return statusInfo;
    return statusActive;
  }

  IconData _getFloorIcon(String? fl) {
    if (fl == null || fl == '?') return Icons.help_outline;
    if (fl == 'G' || fl == '0') return Icons.remove;
    if (fl.startsWith('B') || fl.startsWith('-')) return Icons.arrow_downward;
    return Icons.arrow_upward;
  }

  String _getFloorLabel(String? fl) {
    if (fl == null || fl == '?') return 'Unknown';
    if (fl == 'G')           return 'Ground Floor';
    if (fl.startsWith('B'))  return 'Basement ${fl.substring(1)}';
    if (fl.startsWith('-'))  return 'Basement ${fl.substring(1)}';
    return 'Floor $fl';
  }

  int _countAlarms() =>
      _currentLifts.where((l) => l.alarm == '1').length;

  int _countActive() =>
      _currentLifts.where((l) => l.fl != '?' && l.alarm != '1').length;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return BlocListener<LiftScreenBloc, LiftScreenState>(
      listener: (context, state) {
        if (state is LiftFetchSuccessState) {
          setState(() {
            _fetchedData = state.data;
            _currentLifts = _getLiftsForBuilding(state.data, _selectedBuilding);
          });
        }
      },
      child: Scaffold(
        backgroundColor: Background,
        body: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              _buildHeader(),
              Expanded(child: _buildBody()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [liftStatusPrimary, liftStatusPrimary.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: liftStatusPrimary.withOpacity(0.25),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        children: [
          Gap(40),
          Row(
            children: [
              _buildHeaderIconBtn(Icons.arrow_back, () => context.go('/home')),
              Gap(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: 'Lift Status Monitor',
                      color: white,
                      size: SizeConfig.medbigText,
                      weight: FontWeight.w700,
                      letterSpacing: 0.3,
                    ),
                    Gap(2),
                    CustomText(
                      text: 'Real-time elevator monitoring',
                      color: white.withOpacity(0.8),
                      size: SizeConfig.tinyText,
                      weight: FontWeight.w400,
                    ),
                  ],
                ),
              ),
              // Live badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: statusActive,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: statusActive.withOpacity(0.6),
                            blurRadius: 4,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                    Gap(5),
                    CustomText(
                      text: 'Live',
                      color: white,
                      size: SizeConfig.tinyText,
                      weight: FontWeight.w600,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Gap(14),
          _buildBuildingDropdown(),
          // Gap(12),
          //
          // _buildStatusLegend(),
        ],
      ),
    );
  }

  Widget _buildHeaderIconBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: white, size: 20),
      ),
    );
  }

  Widget _buildBuildingDropdown() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: white.withOpacity(0.3), width: 1),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedBuilding,
          dropdownColor: liftStatusPrimary,
          iconEnabledColor: white,
          isExpanded: true,
          isDense: true,
          icon: Icon(Icons.keyboard_arrow_down_rounded, color: white),
          style: TextStyle(
            color: white,
            fontSize: SizeConfig.smallSubText,
            fontFamily: 'Lato',
            fontWeight: FontWeight.w600,
          ),
          items: _buildings
              .map((b) => DropdownMenuItem(
            value: b,
            child: Row(
              children: [
                Icon(Icons.business, color: white.withOpacity(0.8), size: 16),
                Gap(8),
                Text(b),
              ],
            ),
          ))
              .toList(),
          onChanged: (val) {
            if (val == null) return;
            setState(() {
              _selectedBuilding = val;
              if (_fetchedData != null) {
                _currentLifts = _getLiftsForBuilding(_fetchedData!, val);
              }
            });
          },
        ),
      ),
    );
  }


  Widget _buildDivider() =>
      Container(width: 1, height: 16, color: white.withOpacity(0.25));

  Widget _buildBody() {
    return BlocBuilder<LiftScreenBloc, LiftScreenState>(
      builder: (context, state) {
        if (state is LiftFetchLoadingState) {
          return _buildLoading();
        }
        if (state is LiftFetchErrorState) {
          return _buildError(state.message);
        }
        if (_currentLifts.isEmpty) {
          return _buildEmpty();
        }
        return _buildContent();
      },
    );
  }

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: liftStatusPrimary),
          Gap(16),
          CustomText(
            text: 'Fetching lift data…',
            color: TextColourAsh,
            size: SizeConfig.smallSubText,
            weight: FontWeight.w500,
          ),
        ],
      ),
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: statusError.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.error_outline, color: statusError, size: 36),
            ),
            Gap(16),
            CustomText(
              text: 'Failed to load lift data',
              color: TextColourBlk,
              size: SizeConfig.subText,
              weight: FontWeight.w700,
            ),
            Gap(8),
            CustomText(
              text: message,
              color: TextColourAsh,
              size: SizeConfig.tinyText,
              weight: FontWeight.w400,
              textAlign: TextAlign.center,
            ),
            Gap(20),
            GestureDetector(
              onTap: () => bloc.add(LiftFetchEvent()),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: liftStatusPrimary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.refresh_rounded, color: white, size: 18),
                    Gap(8),
                    CustomText(
                      text: 'Retry',
                      color: white,
                      size: SizeConfig.subText,
                      weight: FontWeight.w600,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.elevator_outlined, color: TextColourAsh, size: 48),
          Gap(12),
          CustomText(
            text: 'No lift data available',
            color: TextColourAsh,
            size: SizeConfig.subText,
            weight: FontWeight.w500,
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return SlideTransition(
      position: _slideAnimation,
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.82,
              ),
              itemCount: _currentLifts.length,
              itemBuilder: (context, index) {
                return _buildLiftCard(_currentLifts[index]);
              },
            ),
          ],
        ),
      ),
    );
  }



  Widget _buildLiftCard(Lift lift) {
    final color = _getLiftColor(lift);
    final icon  = _getFloorIcon(lift.fl);
    final hasAlarm = lift.alarm == '1';
    final doorOpen = lift.door == '1';

    return Container(
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withOpacity(hasAlarm ? 0.6 : 0.25),
          width: hasAlarm ? 2 : 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.12),
            blurRadius: 16,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
            decoration: BoxDecoration(
              color: color.withOpacity(0.08),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(19),
                topRight: Radius.circular(19),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: 'Lift ${lift.id}',
                  color: TextColourBlk,
                  size: SizeConfig.subText,
                  weight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
                Row(
                  children: [
                    if (hasAlarm) ...[
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: statusError.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(Icons.warning_amber,
                            color: statusError, size: 14),
                      ),
                      Gap(6),
                    ],
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: color.withOpacity(0.35),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(icon, color: white, size: 18),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Floor circle
                  Container(
                    width: 68,
                    height: 68,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: color, width: 3),
                      color: color.withOpacity(0.06),
                      boxShadow: [
                        BoxShadow(
                          color: color.withOpacity(0.15),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Center(
                      child: CustomText(
                        text: lift.fl ?? '--',
                        color: color,
                        size: lift.fl != null && lift.fl!.length > 2
                            ? SizeConfig.titleText!
                            : SizeConfig.bigText! + 4,
                        weight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  Gap(8),
                  CustomText(
                    text: _getFloorLabel(lift.fl),
                    color: TextColourAsh,
                    size: SizeConfig.miniText,
                    weight: FontWeight.w500,
                  ),
                  // Gap(8),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     _buildStatusBadge(
                  //       icon: doorOpen
                  //           ? Icons.sensor_door
                  //           : Icons.door_front_door,
                  //       label: doorOpen ? 'Open' : 'Closed',
                  //       color: doorOpen ? statusWarning : statusActive,
                  //     ),
                  //     if (hasAlarm) ...[
                  //       Gap(6),
                  //       _buildStatusBadge(
                  //         icon: Icons.notifications_active,
                  //         label: 'Alarm',
                  //         color: statusError,
                  //       ),
                  //     ],
                  //   ],
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.25), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: color),
          Gap(3),
          CustomText(
            text: label,
            color: color,
            size: SizeConfig.miniText,
            weight: FontWeight.w600,
          ),
        ],
      ),
    );
  }
}