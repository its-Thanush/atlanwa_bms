import 'package:atlanwa_bms/allImports.dart';





class Errorscreen extends StatefulWidget {
  const Errorscreen({super.key});

  @override
  State<Errorscreen> createState() => _ErrorscreenState();
}

class _ErrorscreenState extends State<Errorscreen> {



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomText(text: "Page not found...",size: 30,weight: FontWeight.bold,),
            Gap(10),
            CustomText(text: "the page you are looking for doesn't exist",size: 25,weight: FontWeight.normal,textAlign: TextAlign.center,),
            Gap(30),
            // Image.asset(Utilitiesa.errorBG,width: SizeConfig.blockSizeHorizontal!*50,height: SizeConfig.blockSizeVertical!*50,),
            Gap(45),
            MaterialButton(
              elevation: 0,
              minWidth: 100,
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              color: primaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)
              ),
              onPressed: () {
                context.go('/');
              },
              child: CustomText(
                text: "Go Home",
                size: 25,
                color: white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}