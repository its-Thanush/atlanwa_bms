
import 'package:atlanwa_bms/allImports.dart';

class HomeScreen extends StatefulWidget {
  final Map<String, dynamic>? extra;

  const HomeScreen({super.key, this.extra});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Responsive(
      desktop: SizedBox(),
      mobile: HomeScreenM(extra: widget.extra),
      tablet: SizedBox(),
    );
  }
}