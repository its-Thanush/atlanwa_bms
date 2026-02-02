import 'package:atlanwa_bms/allImports.dart';
import 'package:gap/gap.dart';
import '../bloc/lift_screen_bloc.dart';

class LiftScreenM extends StatefulWidget {
  const LiftScreenM({super.key});

  @override
  State<LiftScreenM> createState() => _LiftScreenMState();
}

class _LiftScreenMState extends State<LiftScreenM> {
  late LiftScreenBloc bloc;

  final List<LiftData> lifts = [
    LiftData(
      id: 'P1',
      currentFloor: 7,
      direction: LiftDirection.up,
      status: LiftStatus.moving,
    ),
    LiftData(
      id: 'P2',
      currentFloor: 4,
      direction: LiftDirection.up,
      status: LiftStatus.moving,
    ),
    LiftData(
      id: 'P3',
      currentFloor: -2, // B2
      direction: LiftDirection.down,
      status: LiftStatus.moving,
    ),
    LiftData(
      id: 'P4',
      currentFloor: 5,
      direction: LiftDirection.up,
      status: LiftStatus.moving,
    ),
    LiftData(
      id: 'P5',
      currentFloor: 12,
      direction: LiftDirection.idle,
      status: LiftStatus.idle,
    ),
    LiftData(
      id: 'P6',
      currentFloor: 4,
      direction: LiftDirection.down,
      status: LiftStatus.moving,
    ),
  ];

  @override
  void initState() {
    bloc = BlocProvider.of<LiftScreenBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return BlocListener<LiftScreenBloc, LiftScreenState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      child: BlocBuilder<LiftScreenBloc, LiftScreenState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Background,
            body: SafeArea(
              child: Column(
                children: [
                  _buildHeader(),
                  Expanded(
                    child: _buildLiftGrid(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryColor, primaryColor1.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.2),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  onPressed: () {
                    context.go('/home');
                  },
                  icon: Icon(Icons.arrow_back, color: white),
                  tooltip: 'Back to Home',
                  splashRadius: 24,
                ),
              ),
              Gap(16),
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
                    Gap(4),
                    CustomText(
                      text: 'Real-time elevator monitoring',
                      color: white.withOpacity(0.85),
                      size: SizeConfig.smalltinyText,
                      weight: FontWeight.w400,
                      letterSpacing: 0.2,
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: statusActive,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: statusActive.withOpacity(0.5),
                            blurRadius: 4,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                    Gap(6),
                    CustomText(
                      text: 'Live',
                      color: white,
                      size: SizeConfig.smalltinyText,
                      weight: FontWeight.w600,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Gap(16),
          _buildStatusLegend(),
        ],
      ),
    );
  }

  Widget _buildStatusLegend() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildLegendItem(Icons.arrow_upward, 'Moving Up', white),
          Container(width: 1, height: 20, color: white.withOpacity(0.3)),
          _buildLegendItem(Icons.arrow_downward, 'Moving Down', white),
          Container(width: 1, height: 20, color: white.withOpacity(0.3)),
          _buildLegendItem(Icons.remove, 'Idle', white),
        ],
      ),
    );
  }

  Widget _buildLegendItem(IconData icon, String label, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 16),
        Gap(4),
        CustomText(
          text: label,
          color: color.withOpacity(0.9),
          size: SizeConfig.miniText,
          weight: FontWeight.w500,
        ),
      ],
    );
  }

  Widget _buildLiftGrid() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.85,
        ),
        itemCount: lifts.length,
        itemBuilder: (context, index) {
          return _buildLiftCard(lifts[index]);
        },
      ),
    );
  }

  Widget _buildLiftCard(LiftData lift) {
    return Container(
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _getLiftStatusColor(lift).withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: _getLiftStatusColor(lift).withOpacity(0.15),
            blurRadius: 20,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header with direction indicator
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: _getLiftStatusColor(lift).withOpacity(0.1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
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
                  letterSpacing: 0.3,
                ),
                Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: _getLiftStatusColor(lift),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: _getLiftStatusColor(lift).withOpacity(0.3),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    _getDirectionIcon(lift.direction),
                    color: white,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),

          // Floor display
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _getLiftStatusColor(lift),
                        width: 3,
                      ),
                      color: _getLiftStatusColor(lift).withOpacity(0.05),
                    ),
                    child: Center(
                      child: CustomText(
                        text: _getFloorDisplay(lift.currentFloor),
                        color: _getLiftStatusColor(lift),
                        size: SizeConfig.bigText! + 8,
                        weight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  Gap(12),
                  CustomText(
                    text: _getFloorLabel(lift.currentFloor),
                    color: TextColourAsh,
                    size: SizeConfig.smallSubText,
                    weight: FontWeight.w500,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getFloorDisplay(int floor) {
    if (floor < 0) {
      return 'B${floor.abs()}';
    }
    return floor.toString();
  }

  String _getFloorLabel(int floor) {
    if (floor < 0) {
      return 'Basement ${floor.abs()}';
    } else if (floor == 0) {
      return 'Ground Floor';
    }
    return 'Floor $floor';
  }

  IconData _getDirectionIcon(LiftDirection direction) {
    switch (direction) {
      case LiftDirection.up:
        return Icons.arrow_upward;
      case LiftDirection.down:
        return Icons.arrow_downward;
      case LiftDirection.idle:
        return Icons.remove;
    }
  }

  Color _getLiftStatusColor(LiftData lift) {
    switch (lift.status) {
      case LiftStatus.moving:
        if (lift.direction == LiftDirection.up) {
          return statusActive;
        } else if (lift.direction == LiftDirection.down) {
          return statusInfo;
        }
        return statusInactive;
      case LiftStatus.idle:
        return statusWarning;
      case LiftStatus.maintenance:
        return statusError;
    }
  }

  String _getStatusText(LiftStatus status) {
    switch (status) {
      case LiftStatus.moving:
        return 'In Motion';
      case LiftStatus.idle:
        return 'Idle';
      case LiftStatus.maintenance:
        return 'Maintenance';
    }
  }
}

// Data Models
class LiftData {
  final String id;
  final int currentFloor;
  final LiftDirection direction;
  final LiftStatus status;

  LiftData({
    required this.id,
    required this.currentFloor,
    required this.direction,
    required this.status,
  });
}

enum LiftDirection {
  up,
  down,
  idle,
}

enum LiftStatus {
  moving,
  idle,
  maintenance,
}