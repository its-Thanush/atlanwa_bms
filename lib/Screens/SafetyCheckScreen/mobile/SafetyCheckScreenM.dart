import 'dart:async';
import 'package:atlanwa_bms/allImports.dart';
import 'package:gap/gap.dart';
import '../bloc/safety_check_bloc.dart';

class SafetycheckscreenM extends StatefulWidget {

  const SafetycheckscreenM({ super.key});

  @override
  State<SafetycheckscreenM> createState() => _SafetycheckscreenMState();
}

class _SafetycheckscreenMState extends State<SafetycheckscreenM>
    with TickerProviderStateMixin {
  late SafetyCheckBloc bloc;


  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<SafetyCheckBloc>(context);
    _initializeAnimations();
    _startTimer();
    bloc.add(FireFetchEvent());
  }

  void _initializeAnimations() {
    // Fade animation
    bloc.fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    bloc.fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: bloc.fadeController, curve: Curves.easeIn),
    );
    bloc.fadeController.forward();

    // Slide animation
    bloc.slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    bloc.slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
          CurvedAnimation(parent: bloc.slideController, curve: Curves.easeOut),
        );
    bloc.slideController.forward();
  }

  void _startTimer() {
    bloc.timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          bloc.currentTime = DateTime.now();
        });
      }
    });
  }

  @override
  void dispose() {
    bloc.remarksController.dispose();
    bloc.fadeController.dispose();
    bloc.slideController.dispose();
    bloc.timer.cancel();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    final days = [
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday'
    ];
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];

    return '${days[date.weekday % 7]}, ${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String _formatTime(DateTime date) {
    int hour = date.hour;
    String period = hour >= 12 ? 'PM' : 'AM';
    hour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);

    String minute = date.minute.toString().padLeft(2, '0');
    String second = date.second.toString().padLeft(2, '0');

    return '$hour:$minute:$second $period';
  }

  int get completedCheckpoints =>
      bloc.selectedAnswerIndex.where((i) => i != -1).length;

  double get progressPercentage =>
      bloc.checkpoints.isEmpty ? 0 : (completedCheckpoints / bloc.checkpoints.length);

  void _showSubmitBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: safetyCheckPrimary.withOpacity(0.1),
              blurRadius: 20,
              offset: Offset(0, -4),
            ),
          ],
        ),
        padding: EdgeInsets.all(SizeConfig.commonMargin! * 2.5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: TextColourAsh.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Gap(SizeConfig.commonMargin! * 2),

            // Icon
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: safetyCheckLight,
              ),
              child: Icon(
                Icons.check_circle_outline,
                size: 40,
                color: safetyCheckPrimary,
              ),
            ),
            Gap(SizeConfig.commonMargin! * 2),

            CustomText(
              text: 'Submit Safety Check?',
              size: SizeConfig.medtitleText,
              weight: FontWeight.w700,
              color: TextColourBlk,
            ),
            Gap(SizeConfig.commonMargin!),
            CustomText(
              text:
              'You have completed $completedCheckpoints out of ${bloc.checkpoints.length} checkpoints',
              size: SizeConfig.smallSubText,
              weight: FontWeight.w400,
              color: TextColourAsh,
              textAlign: TextAlign.center,
            ),
            Gap(SizeConfig.commonMargin! * 3),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      FocusScope.of(context).unfocus();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: surfaceDark,
                      padding: EdgeInsets.symmetric(
                        vertical: SizeConfig.commonMargin! * 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: CustomText(
                      text: 'Cancel',
                      size: SizeConfig.subText,
                      weight: FontWeight.w600,
                      color: TextColourBlk,
                    ),
                  ),
                ),
                Gap(SizeConfig.commonMargin! * 1.5),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      FocusScope.of(context).unfocus();
                      bloc.add(FireSubmitEvent());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: safetyCheckPrimary,
                      padding: EdgeInsets.symmetric(
                        vertical: SizeConfig.commonMargin! * 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    child: CustomText(
                      text: 'Submit',
                      size: SizeConfig.subText,
                      weight: FontWeight.w600,
                      color: white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return BlocListener<SafetyCheckBloc, SafetyCheckState>(
      listener: (context, state) {
        if(state is FireFetchSuccessState){
          bloc.selectedAnswerIndex = List.filled(bloc.checkpoints.length, -1);
        }

        if (state is FireSubmitValidationFailedState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.warning_amber_rounded, color: white, size: 20),
                  Gap(SizeConfig.commonMargin!),
                  Expanded(
                    child: CustomText(
                      text: 'Please answer all ${bloc.checkpoints.length} questions before submitting.',
                      color: white,
                      size: SizeConfig.smallSubText,
                      weight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              backgroundColor: Colors.orange,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              duration: Duration(seconds: 3),
            ),
          );
        }

        if (state is FireSubmitSuccessState) {
          setState(() {
            bloc.selectedAnswerIndex = List.filled(bloc.checkpoints.length, -1);
            bloc.remarksController.clear();
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.check_circle, color: white, size: 20),
                  Gap(SizeConfig.commonMargin!),
                  Expanded(
                    child: CustomText(
                      text: 'Safety check submitted successfully!',
                      color: white,
                      size: SizeConfig.smallSubText,
                      weight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              backgroundColor: statusActive,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              duration: Duration(seconds: 3),
            ),
          );
        }

        if (state is FireSubmitFailedState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: CustomText(
                text: 'Submission failed. Please try again.',
                color: white,
                size: SizeConfig.smallSubText,
              ),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              duration: Duration(seconds: 3),
            ),
          );
        }

      },
      child: BlocBuilder<SafetyCheckBloc, SafetyCheckState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: appBackground,
            appBar: AppBar(
              backgroundColor: safetyCheckPrimary,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios_new, color: white, size: 20),
                onPressed: () {
                  context.go('/home');
                },
              ),
              title: CustomText(
                text: 'Safety Check',
                color: white,
                size: SizeConfig.titleText,
                weight: FontWeight.w700,
              ),
              actions: [
                Container(
                  margin: EdgeInsets.only(right: SizeConfig.commonMargin! * 1.5),
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.commonMargin! * 1.2,
                    vertical: SizeConfig.commonMargin! * 0.6,
                  ),
                  decoration: BoxDecoration(
                    color: white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.access_time, color: white, size: 16),
                      Gap(SizeConfig.commonMargin! * 0.5),
                      CustomText(
                        text: _formatTime(bloc.currentTime),
                        color: white,
                        size: SizeConfig.smallSubText,
                        weight: FontWeight.w600,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            body: FadeTransition(
              opacity: bloc.fadeAnimation,
              child: SlideTransition(
                position: bloc.slideAnimation,
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(SizeConfig.commonMargin! * 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildLocationHeader(),
                      if(bloc.isResponseCame)...[
                        Gap(SizeConfig.commonMargin! * 2),
                        _buildProgressCard(),
                        Gap(SizeConfig.commonMargin! * 2.5),
                        _buildCheckpointsList(),
                        Gap(SizeConfig.commonMargin! * 2.5),
                        _buildRemarksSection(),
                        Gap(SizeConfig.commonMargin! * 3),
                        _buildSubmitButton(),
                        Gap(SizeConfig.commonMargin! * 2),
                      ]else...[
                        Container(
                          child: CustomText(text: "No Response",),
                        ),
                      ]
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLocationHeader() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [safetyCheckPrimary, safetyCheckPrimary.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: safetyCheckPrimary.withOpacity(0.3),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.all(SizeConfig.commonMargin! * 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.location_on,
                  color: white,
                  size: 28,
                ),
              ),
              Gap(SizeConfig.commonMargin! * 1.5),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: 'Location',
                      size: SizeConfig.smallSubText,
                      weight: FontWeight.w500,
                      color: white.withOpacity(0.9),
                    ),
                    Gap(SizeConfig.commonMargin! * 0.3),
                    CustomText(
                      text: Utilities.userName,
                      size: SizeConfig.medtitleText,
                      weight: FontWeight.w700,
                      color: white,
                    ),
                  ],
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.commonMargin!),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: white.withOpacity(0.9), size: 20),
          Gap(SizeConfig.commonMargin! * 0.5),
          CustomText(
            text: label,
            size: SizeConfig.tinyText,
            weight: FontWeight.w400,
            color: white.withOpacity(0.8),
          ),
          Gap(SizeConfig.commonMargin! * 0.3),
          CustomText(
            text: value,
            size: SizeConfig.subText,
            weight: FontWeight.w700,
            color: white,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard() {
    return Container(
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: safetyCheckPrimary.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(SizeConfig.commonMargin! * 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: 'Inspection Progress',
                size: SizeConfig.medtitleText,
                weight: FontWeight.w700,
                color: TextColourBlk,
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.commonMargin! * 1,
                  vertical: SizeConfig.commonMargin! * 0.5,
                ),
                decoration: BoxDecoration(
                  color: safetyCheckLight,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: CustomText(
                  text: '$completedCheckpoints/${bloc.checkpoints.length}',
                  size: SizeConfig.smallSubText,
                  weight: FontWeight.w700,
                  color: safetyCheckPrimary,
                ),
              ),
            ],
          ),
          Gap(SizeConfig.commonMargin! * 1.5),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progressPercentage,
              backgroundColor: safetyCheckLight,
              valueColor: AlwaysStoppedAnimation<Color>(safetyCheckPrimary),
              minHeight: 10,
            ),
          ),
          Gap(SizeConfig.commonMargin!),
          CustomText(
            text:
            '${(progressPercentage * 100).toStringAsFixed(0)}% Complete',
            size: SizeConfig.smallSubText,
            weight: FontWeight.w500,
            color: TextColourAsh,
          ),
        ],
      ),
    );
  }

  Widget _buildCheckpointsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.checklist_rounded,
              color: safetyCheckPrimary,
              size: 24,
            ),
            Gap(SizeConfig.commonMargin!),
            CustomText(
              text: 'Inspection Checkpoints',
              size: SizeConfig.medtitleText,
              weight: FontWeight.w700,
              color: TextColourBlk,
            ),
          ],
        ),
        Gap(SizeConfig.commonMargin! * 1.5),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: bloc.checkpoints.length,
          itemBuilder: (context, index) {
            final question = bloc.checkpoints[index];
            final options = question.availableOptions;
            final selectedIdx = bloc.selectedAnswerIndex[index];
            final isAnswered = selectedIdx != -1;

            return AnimatedContainer(
              duration: Duration(milliseconds: 300),
              margin: EdgeInsets.only(bottom: SizeConfig.commonMargin! * 1.2),
              decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isAnswered ? statusActive : borderColor,
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isAnswered
                        ? statusActive.withOpacity(0.1)
                        : Colors.black.withOpacity(0.03),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: Padding(
                  padding: EdgeInsets.all(SizeConfig.commonMargin! * 1.5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Question header row — unchanged
                      Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isAnswered ? statusActive : safetyCheckLight,
                            ),
                            child: Center(
                              child: CustomText(
                                text: '${index + 1}',
                                size: SizeConfig.subText,
                                weight: FontWeight.w700,
                                color: isAnswered ? white : safetyCheckPrimary,
                              ),
                            ),
                          ),
                          Gap(SizeConfig.commonMargin! * 1.2),
                          Expanded(
                            child: CustomText(
                              text: question.question ?? '',
                              size: SizeConfig.subText,
                              weight: FontWeight.w500,
                              color: isAnswered ? TextColourBlk : TextColourGrey,
                              maxLines: 3,
                              textOverflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Gap(SizeConfig.commonMargin! * 1),
                        ],
                      ),
                      Gap(10),
                      // Dynamic options — only non-empty options, single selection
                      ...List.generate(options.length, (optIdx) {
                        final isSelected = selectedIdx == optIdx;
                        return Row(
                          children: [
                            Checkbox(
                              activeColor: Colors.green,
                              value: isSelected,
                              onChanged: (checked) {
                                setState(() {
                                  bloc.selectedAnswerIndex[index] = isSelected ? -1 : optIdx;
                                });
                              },
                            ),
                            Gap(10),
                            CustomText(
                              text: options[optIdx],
                              size: SizeConfig.subText,
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildRemarksSection() {
    return Container(
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: borderColor,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(SizeConfig.commonMargin! * 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.comment_outlined,
                color: safetyCheckPrimary,
                size: 22,
              ),
              Gap(SizeConfig.commonMargin!),
              CustomText(
                text: 'Remarks',
                size: SizeConfig.medtitleText,
                weight: FontWeight.w700,
                color: TextColourBlk,
              ),
            ],
          ),
          Gap(SizeConfig.commonMargin! * 1.5),
          Container(
            decoration: BoxDecoration(
              color: surfaceDark,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: borderColor,
                width: 1,
              ),
            ),
            padding: EdgeInsets.all(SizeConfig.commonMargin! * 1.5),
            child: TextField(
              controller: bloc.remarksController,
              maxLines: 5,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter any remarks or observations...',
                hintStyle: TextStyle(
                  color: TextColourAsh,
                  fontSize: SizeConfig.smallSubText,
                  fontWeight: FontWeight.w400,
                ),
                contentPadding: EdgeInsets.zero,
              ),
              style: TextStyle(
                fontSize: SizeConfig.subText,
                color: TextColourBlk,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: safetyCheckPrimary.withOpacity(0.3),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _showSubmitBottomSheet,
        style: ElevatedButton.styleFrom(
          backgroundColor: safetyCheckPrimary,
          padding: EdgeInsets.symmetric(
            vertical: SizeConfig.commonMargin! * 2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.send_rounded, color: white, size: 22),
            Gap(SizeConfig.commonMargin!),
            CustomText(
              text: 'Submit Safety Check',
              size: SizeConfig.medtitleText,
              weight: FontWeight.w700,
              color: white,
            ),
          ],
        ),
      ),
    );
  }
}