import 'package:atlanwa_bms/allImports.dart';

class SplashscreenM extends StatefulWidget {
  const SplashscreenM({super.key});

  @override
  State<SplashscreenM> createState() => _SplashscreenMState();
}

class _SplashscreenMState extends State<SplashscreenM> with TickerProviderStateMixin {
  late AnimationController _titleController;
  late AnimationController _subtitleController;
  late AnimationController _logoController;
  late Animation<Offset> _titleSlideAnimation;
  late Animation<Offset> _subtitleSlideAnimation;
  late Animation<double> _logoScaleAnimation;


  @override
  void initState() {
    super.initState();
    _initializeAnimations();

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        context.go('/login');
      }
    });
  }

  void _initializeAnimations() {
    _titleController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _subtitleController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _titleSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _titleController, curve: Curves.easeOut));

    _subtitleSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _subtitleController, curve: Curves.easeOut));

    _logoScaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );

    _logoController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      _titleController.forward();
    });
    Future.delayed(const Duration(milliseconds: 400), () {
      _subtitleController.forward();
    });
  }


  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    _logoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              primaryColor.withOpacity(0.15),
              Background,
              primaryColor1.withOpacity(0.1),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: _logoScaleAnimation,
                child: Container(
                  width: SizeConfig.screenWidth! * 0.3,
                  height: SizeConfig.screenWidth! * 0.3,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [primaryColor, primaryColor1],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.4),
                        blurRadius: 30,
                        offset: const Offset(0, 15),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      Icons.shield,
                      size: SizeConfig.screenWidth! * 0.15,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: SizeConfig.commonMargin! * 5),
              SlideTransition(
                position: _titleSlideAnimation,
                child: FadeTransition(
                  opacity: _titleController,
                  child: CustomText(
                    text: 'A T L A N W A',
                    size: SizeConfig.bigText! + 5,
                    weight: FontWeight.w900,
                    color: primaryColor,
                    letterSpacing: 3.0,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(height: SizeConfig.commonMargin! * 1.5),
              SlideTransition(
                position: _subtitleSlideAnimation,
                child: FadeTransition(
                  opacity: _subtitleController,
                  child: Column(
                    children: [
                      CustomText(
                        text: 'Limitless Possibilities',
                        size: SizeConfig.smallTitleText,
                        weight: FontWeight.w600,
                        color: Colors.grey[700],
                        letterSpacing: 1.0,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: SizeConfig.commonMargin!),
                      Container(
                        width: 60,
                        height: 3,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [primaryColor, primaryColor1],
                          ),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: SizeConfig.commonMargin! * 8),
              FadeTransition(
                opacity: _subtitleController,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                  strokeWidth: 3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
