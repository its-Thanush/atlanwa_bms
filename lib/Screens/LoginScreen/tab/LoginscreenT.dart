import 'package:atlanwa_bms/allImports.dart';


class LoginscreenT extends StatefulWidget {
  const LoginscreenT({super.key});

  @override
  State<LoginscreenT> createState() => _LoginscreenTState();
}

class _LoginscreenTState extends State<LoginscreenT> {

  late LoginScreenBloc bloc;


  @override
  void initState() {
    bloc=BlocProvider.of<LoginScreenBloc>(context);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
