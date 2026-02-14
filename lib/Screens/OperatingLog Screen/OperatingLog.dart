import 'package:atlanwa_bms/allImports.dart';

import 'mobile/OperatingLogM.dart';

class OperatingLog extends StatefulWidget {
  const OperatingLog({super.key});

  @override
  State<OperatingLog> createState() => _OperatingLogState();
}

class _OperatingLogState extends State<OperatingLog> {
  @override
  Widget build(BuildContext context) {
    return Responsive(
      desktop: SizedBox(),
      mobile: OperatingLogM(),
      tablet: SizedBox(),
    );
  }
}