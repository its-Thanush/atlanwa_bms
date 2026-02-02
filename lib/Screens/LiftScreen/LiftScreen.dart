import 'package:atlanwa_bms/allImports.dart';

import 'mobile/LiftScreenM.dart';

class LiftScreen extends StatefulWidget {
  const LiftScreen({super.key});

  @override
  State<LiftScreen> createState() => _LiftScreenState();
}

class _LiftScreenState extends State<LiftScreen> {
  @override
  Widget build(BuildContext context) {
    return Responsive(
      desktop: SizedBox(),
      mobile: LiftScreenM(),
      tablet: SizedBox(),
    );
  }
}
