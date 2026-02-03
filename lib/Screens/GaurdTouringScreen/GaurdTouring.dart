import 'package:atlanwa_bms/allImports.dart';

import 'mobile/GuardTouringM.dart';

class Gaurdtouring extends StatefulWidget {
  const Gaurdtouring({super.key});

  @override
  State<Gaurdtouring> createState() => _GaurdtouringState();
}

class _GaurdtouringState extends State<Gaurdtouring> {
  @override
  Widget build(BuildContext context) {
    return Responsive(
      desktop: SizedBox(),
      mobile: GuardTouringM(),
      tablet: SizedBox(),
    );;
  }
}
