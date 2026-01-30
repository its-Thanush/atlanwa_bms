import 'package:atlanwa_bms/allImports.dart';

class LoginscreenM extends StatefulWidget {
  const LoginscreenM({super.key});

  @override
  State<LoginscreenM> createState() => _LoginscreenMState();
}

class _LoginscreenMState extends State<LoginscreenM>  with TickerProviderStateMixin {
  late LoginScreenBloc bloc;


  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoggingIn = false;
  String? _loginError;



  @override
  void initState() {
    bloc = BlocProvider.of<LoginScreenBloc>(context);
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _scaleController.forward();
    // TODO: implement initState
    super.initState();
  }


  void _validateAndLogin() {
    setState(() {
      _loginError = null;
    });

    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      setState(() {
        _loginError = 'Please enter username and password';
      });
      return;
    }

    if (username == 'Atlanwa' && password == '123456') {
      setState(() {
        _isLoggingIn = true;
      });

      Future.delayed( Duration(seconds: 1), () {
        if (mounted) {
          context.go('/home');
        }
      });

    } else {
      setState(() {
        _loginError = 'Invalid username or password';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return BlocListener<LoginScreenBloc, LoginScreenState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      child: BlocBuilder<LoginScreenBloc, LoginScreenState>(
        builder: (context, state) {
          return Scaffold(
            body: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                height: SizeConfig.screenHeight!,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [primaryColor.withOpacity(0.1), Background],
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.commonMargin! * 2,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Header
                      CustomText(
                        text: 'A T L A N W A',
                        size: SizeConfig.maxHeightAndWidth,
                        weight: FontWeight.bold,
                        color: primaryColor,
                        letterSpacing: 1.5,
                      ),
                      Gap(SizeConfig.commonMargin! * 0.5),
                      CustomText(
                        text: 'Limitless Possibilities',
                        size: SizeConfig.smallSubText,
                        weight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                      Gap(SizeConfig.commonMargin! * 4),
                        Gap(SizeConfig.commonMargin! * 3),
                        CustomText(
                          text: 'Enter Credentials',
                          size: SizeConfig.medtitleText,
                          weight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        Gap(SizeConfig.commonMargin! * 2),
                        TextField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            labelText: 'Username',
                            labelStyle: TextStyle(
                              color: primaryColor,
                              fontSize: SizeConfig.tinyText,
                            ),
                            prefixIcon: Icon(Icons.person, color: primaryColor),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: primaryColor2, width: 1.5),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: primaryColor2, width: 1.5),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: primaryColor, width: 2),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: SizeConfig.commonMargin! * 1.2,
                            ),
                          ),
                          style: TextStyle(
                            fontSize: SizeConfig.subText,
                            color: Colors.black87,
                          ),
                        ),
                        Gap(SizeConfig.commonMargin! * 2),

                        // Password Field
                        TextField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(
                              color: primaryColor,
                              fontSize: SizeConfig.tinyText,
                            ),
                            prefixIcon: Icon(Icons.lock, color: primaryColor),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                              child: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: primaryColor,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: primaryColor2, width: 1.5),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: primaryColor2, width: 1.5),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: primaryColor, width: 2),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: SizeConfig.commonMargin! * 1.2,
                            ),
                          ),
                          style: TextStyle(
                            fontSize: SizeConfig.subText,
                            color: Colors.black87,
                          ),
                        ),

                        // Error Message
                        if (_loginError != null) ...[
                          Gap(SizeConfig.commonMargin! * 1.5),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(SizeConfig.commonMargin!),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.red, width: 1),
                            ),
                            child: CustomText(
                              text: _loginError!,
                              size: SizeConfig.smallSubText,
                              weight: FontWeight.w500,
                              color: Colors.red,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                        Gap(SizeConfig.commonMargin! * 3),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isLoggingIn ? null : _validateAndLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              disabledBackgroundColor: Colors.grey[400],
                              padding: EdgeInsets.symmetric(
                                vertical: SizeConfig.commonMargin! * 1.5,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 4,
                            ),
                            child: _isLoggingIn
                                ? SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                                strokeWidth: 3,
                              ),
                            )
                                : CustomText(
                              text: 'Login',
                              size: SizeConfig.smallTitleText,
                              weight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Gap(SizeConfig.commonMargin! * 1.5),
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
}
