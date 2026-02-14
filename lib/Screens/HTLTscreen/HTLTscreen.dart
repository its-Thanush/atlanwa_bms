import 'package:atlanwa_bms/allImports.dart';

import 'mobile/HtltscreenM.dart';


class Htltscreen extends StatefulWidget {
  const Htltscreen({super.key});

  @override
  State<Htltscreen> createState() => _LiftScreenState();
}

class _LiftScreenState extends State<Htltscreen> {
  @override
  Widget build(BuildContext context) {
    return Responsive(
      desktop: SizedBox(),
      mobile: HtltscreenM(),
      tablet: SizedBox(),
    );
  }
}