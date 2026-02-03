import 'package:atlanwa_bms/allImports.dart';

import 'mobile/SafetyCheckScreenM.dart';

class Safetycheckscreen extends StatefulWidget {
  const Safetycheckscreen({super.key});

  @override
  State<Safetycheckscreen> createState() => _SafetycheckscreenState();
}

class _SafetycheckscreenState extends State<Safetycheckscreen> {
  @override
  Widget build(BuildContext context) {
    return Responsive(
      desktop: SizedBox(),
      mobile: SafetycheckscreenM(),
      tablet: SizedBox(),
    );
  }
}
