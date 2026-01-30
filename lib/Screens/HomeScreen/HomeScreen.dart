
import 'package:atlanwa_bms/allImports.dart';





class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Responsive(
      desktop: SizedBox(),
      mobile: HomeScreenM(),
      tablet: SizedBox(),
    );
  }
}