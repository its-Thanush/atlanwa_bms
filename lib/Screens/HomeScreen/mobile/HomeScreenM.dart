import 'package:atlanwa_bms/allImports.dart';


class HomeScreenM extends StatefulWidget {
  const HomeScreenM({super.key});

  @override
  State<HomeScreenM> createState() => _HomeScreenMState();
}

class _HomeScreenMState extends State<HomeScreenM> {
  late HomeScreenBloc bloc;

  @override
  void initState() {
    bloc = BlocProvider.of<HomeScreenBloc>(context);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeScreenBloc, HomeScreenState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      child: BlocBuilder<HomeScreenBloc, HomeScreenState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                  onPressed: (){}, 
                  icon: Icon(Icons.menu,color: white,size: SizeConfig.titleText,)
              ),
              actions: [
                IconButton(
                    onPressed: (){},
                    icon: Icon(Icons.logout,color: white,size: SizeConfig.titleText,)
                ),
              ],
              backgroundColor: primaryColor,
              title: CustomText(text: "Atlanwa BMS",color: white,size: SizeConfig.medtitleText,weight: FontWeight.bold,),),
          );
        },
      ),
    );
  }

}
