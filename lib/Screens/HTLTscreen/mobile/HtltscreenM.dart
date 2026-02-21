import 'package:atlanwa_bms/allImports.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import '../../../Widgets/CommonNfcAuth.dart';
import '../bloc/htltssreen_bloc.dart';


class HtltscreenM extends StatefulWidget {
  const HtltscreenM({super.key});

  @override
  State<HtltscreenM> createState() => _HtltscreenMState();
}

class _HtltscreenMState extends State<HtltscreenM> with TickerProviderStateMixin {

  late HtltssreenBloc bloc;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  String selectedView = 'menu';
  Map<String, dynamic> sampleData = {};

  @override
  void initState() {
    super.initState();
    _loadSampleData();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );
    _fadeController.forward();
  }

  void _loadSampleData() {
    sampleData = {
      "id": 3853,
      "building": "PRESTIGE POLYGON",
      "date": "2026-02-14",
      "time": "12:00",
      "panelType": "BOTH",
      "htPanel": {
        "currentAmp": {
          "b": "16.0",
          "r": "16.9",
          "y": "16.4",
          "hz": "50",
          "pf": "0.95"
        },
        "icFromTneb": "EB",
        "outgoingTr1": {
          "oilTemp": "40",
          "currentAmp": {"b": "6.9", "r": "7.1", "y": "6.9"},
          "windingTemp": "40"
        },
        "outgoingTr2": {
          "oilTemp": "40",
          "currentAmp": {"b": "7.9", "r": "8.2", "y": "8.4"},
          "windingTemp": "40"
        },
        "outgoingTr3": {
          "oilTemp": "42",
          "currentAmp": {"b": "4.1", "r": "4.5", "y": "4.2"},
          "windingTemp": "42"
        },
        "voltageFromWreb": {"volt": "32.9"}
      },
      "ltPanel": {
        "incomer1": {
          "kwh": "6959376",
          "tap": "04",
          "voltage": {"br": "405", "ry": "406", "yb": "405"},
          "currentAmp": {"b": "468", "r": "515", "y": "465"}
        },
        "incomer2": {
          "kwh": "82780",
          "tap": "03",
          "voltage": {"br": "408", "ry": "407", "yb": "408"},
          "currentAmp": {"b": "572", "r": "645", "y": "589"}
        },
        "incomer3": {
          "kwh": "17804338",
          "tap": "03",
          "voltage": {"br": "404", "ry": "406", "yb": "404"},
          "currentAmp": {"b": "318", "r": "365", "y": "341"}
        }
      },
      "powerFailure": [],
      "remarks": "Auto-generated entry - Please update"
    };
  }

  void _CreateLog(BuildContext context){
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildLogForm(context),
    );
  }

  void _CreateLTLog(BuildContext context){
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildLTLogForm(context),
    );
  }

  Widget _buildLogForm(BuildContext context) {
    return Container(
      height: 600,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CustomText(
                    text: "Create Log",
                    size: SizeConfig.titleText,
                    weight: FontWeight.w700,
                    color: pro_primaryColor,
                  ),
                  Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              ),
              CustomText(text: "I/C From TNEB", size: SizeConfig.smallSubText, weight: FontWeight.w600,),
              Divider(),
              CustomText(
                text: "Source",
                size: SizeConfig.smallSubText,
                weight: FontWeight.w600,
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  hintText: "EB",
                  hintStyle: TextStyle(fontSize: SizeConfig.smallSubText, color: TextColourAsh),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide(color: borderColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide(color: borderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide(color: htltPanelPrimary),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                items: ['EB', 'DG', 'SOLAR'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: CustomText(
                      text: value,
                      size: SizeConfig.smallSubText,
                      color: TextColourBlk,
                    ),
                  );
                }).toList(),
                onChanged: (value) {},
              ),
              const SizedBox(height: 12),
              CustomText(
                text: "Volt (kv)",
                size: SizeConfig.smallSubText,
                weight: FontWeight.w600,
              ),
              const SizedBox(height: 6),
              CustomText(
                text: "Voltage (kV) *",
                size: SizeConfig.tinyText,
                color: TextColourAsh,
              ),
              const SizedBox(height: 4),
              TextFormField(
                decoration: InputDecoration(
                  hintText: "Enter voltage in kV",
                  hintStyle: TextStyle(fontSize: SizeConfig.smallSubText, color: TextColorGreyLit),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide(color: borderColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide(color: borderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide(color: htltPanelPrimary),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
              ),
              const SizedBox(height: 12),
              CustomText(
                text: "Current Amp",
                size: SizeConfig.smallSubText,
                weight: FontWeight.w600,
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(text: "R *", size: SizeConfig.tinyText, color: TextColourAsh),
                        const SizedBox(height: 4),
                        TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: borderColor)),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: borderColor)),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: htltPanelPrimary)),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(text: "B *", size: SizeConfig.tinyText, color: TextColourAsh),
                        const SizedBox(height: 4),
                        TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: borderColor)),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: borderColor)),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: htltPanelPrimary)),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(text: "YR *", size: SizeConfig.tinyText, color: TextColourAsh),
                        const SizedBox(height: 4),
                        TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: borderColor)),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: borderColor)),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: htltPanelPrimary)),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(text: "Nø *", size: SizeConfig.tinyText, color: TextColourAsh),
                        const SizedBox(height: 4),
                        TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: borderColor)),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: borderColor)),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: htltPanelPrimary)),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              CustomText(
                text: "Outgoing Tr-1 (2000 Kva)",
                size: SizeConfig.smallSubText,
                weight: FontWeight.w600,
              ),
              const SizedBox(height: 6),
              CustomText(text: "Current Amp", size: SizeConfig.tinyText, weight: FontWeight.w600),
              const SizedBox(height: 4),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(text: "R *", size: SizeConfig.tinyText, color: TextColourAsh),
                        const SizedBox(height: 4),
                        TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: borderColor)),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: borderColor)),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: htltPanelPrimary)),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(text: "Y *", size: SizeConfig.tinyText, color: TextColourAsh),
                        const SizedBox(height: 4),
                        TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: borderColor)),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: borderColor)),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: htltPanelPrimary)),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(text: "B *", size: SizeConfig.tinyText, color: TextColourAsh),
                        const SizedBox(height: 4),
                        TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: borderColor)),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: borderColor)),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: htltPanelPrimary)),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              CustomText(text: "Winding Temp", size: SizeConfig.tinyText, weight: FontWeight.w600),
              const SizedBox(height: 4),
              CustomText(text: "Temperature (°C) *", size: SizeConfig.tinyText, color: TextColourAsh),
              const SizedBox(height: 4),
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: borderColor)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: borderColor)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: htltPanelPrimary)),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
              ),
              const SizedBox(height: 12),
              CustomText(text: "Oil Temperature", size: SizeConfig.tinyText, weight: FontWeight.w600),
              const SizedBox(height: 4),
              CustomText(text: "Temperature (°C) *", size: SizeConfig.tinyText, color: TextColourAsh),
              const SizedBox(height: 4),
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: borderColor)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: borderColor)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: htltPanelPrimary)),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
              ),
              const SizedBox(height: 12),
              CustomText(
                text: "Outgoing Tr-2 (2000 Kva)",
                size: SizeConfig.smallSubText,
                weight: FontWeight.w600,
              ),
              const SizedBox(height: 6),
              CustomText(text: "Current Amp", size: SizeConfig.tinyText, weight: FontWeight.w600),
              const SizedBox(height: 4),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(text: "R *", size: SizeConfig.tinyText, color: TextColourAsh),
                        const SizedBox(height: 4),
                        TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: borderColor)),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: borderColor)),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: htltPanelPrimary)),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(text: "Y *", size: SizeConfig.tinyText, color: TextColourAsh),
                        const SizedBox(height: 4),
                        TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: borderColor)),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: borderColor)),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: htltPanelPrimary)),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(text: "B *", size: SizeConfig.tinyText, color: TextColourAsh),
                        const SizedBox(height: 4),
                        TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: borderColor)),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: borderColor)),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: htltPanelPrimary)),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              CustomText(text: "Winding Temp", size: SizeConfig.tinyText, weight: FontWeight.w600),
              const SizedBox(height: 4),
              CustomText(text: "Temperature (°C) *", size: SizeConfig.tinyText, color: TextColourAsh),
              const SizedBox(height: 4),
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: borderColor)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: borderColor)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: htltPanelPrimary)),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
              ),
              const SizedBox(height: 12),
              CustomText(text: "Oil Temperature", size: SizeConfig.tinyText, weight: FontWeight.w600),
              const SizedBox(height: 4),
              CustomText(text: "Temperature (°C) *", size: SizeConfig.tinyText, color: TextColourAsh),
              const SizedBox(height: 4),
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: borderColor)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: borderColor)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: htltPanelPrimary)),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
              ),
              const SizedBox(height: 12),
              CustomText(
                text: "Outgoing Tr-3 (2000 Kva)",
                size: SizeConfig.smallSubText,
                weight: FontWeight.w600,
              ),
              const SizedBox(height: 6),
              CustomText(text: "Current Amp", size: SizeConfig.tinyText, weight: FontWeight.w600),
              const SizedBox(height: 4),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(text: "R *", size: SizeConfig.tinyText, color: TextColourAsh),
                        const SizedBox(height: 4),
                        TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: borderColor)),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: borderColor)),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: htltPanelPrimary)),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(text: "Y *", size: SizeConfig.tinyText, color: TextColourAsh),
                        const SizedBox(height: 4),
                        TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: borderColor)),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: borderColor)),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: htltPanelPrimary)),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(text: "B *", size: SizeConfig.tinyText, color: TextColourAsh),
                        const SizedBox(height: 4),
                        TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: borderColor)),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: borderColor)),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: htltPanelPrimary)),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              CustomText(text: "Winding Temp", size: SizeConfig.tinyText, weight: FontWeight.w600),
              const SizedBox(height: 4),
              CustomText(text: "Temperature (°C) *", size: SizeConfig.tinyText, color: TextColourAsh),
              const SizedBox(height: 4),
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: borderColor)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: borderColor)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: htltPanelPrimary)),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
              ),
              const SizedBox(height: 12),
              CustomText(text: "Oil Temperature", size: SizeConfig.tinyText, weight: FontWeight.w600),
              const SizedBox(height: 4),
              CustomText(text: "Temperature (°C) *", size: SizeConfig.tinyText, color: TextColourAsh),
              const SizedBox(height: 4),
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: borderColor)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: borderColor)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: htltPanelPrimary)),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: htltPanelPrimary,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: CustomText(
                    text: "Submit",
                    size: SizeConfig.medtitleText,
                    color: white,
                    weight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLTLogForm(BuildContext context) {
    return Container(
      height: 600,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  height: 5,
                  width: 45,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Row(
                children: [
                  CustomText(
                    text: "LT Panel - Incomers",
                    size: SizeConfig.titleText,
                    weight: FontWeight.w700,
                    color: pro_primaryColor,
                  ),
                  Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              ),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: surfaceDark,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: "Incomer-1 (From Tr-1)",
                      size: SizeConfig.smallSubText,
                      weight: FontWeight.w600,
                    ),
                    const SizedBox(height: 12),
                    CustomText(
                      text: "Voltage",
                      size: SizeConfig.smallSubText,
                      weight: FontWeight.w600,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(text: "RY *", size: SizeConfig.tinyText, color: TextColourAsh),
                              const SizedBox(height: 4),
                              TextFormField(
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: white,
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: borderColor)),
                                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: borderColor)),
                                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: htltPanelPrimary)),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(text: "YB *", size: SizeConfig.tinyText, color: TextColourAsh),
                              const SizedBox(height: 4),
                              TextFormField(
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: white,
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: borderColor)),
                                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: borderColor)),
                                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: htltPanelPrimary)),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(text: "BR *", size: SizeConfig.tinyText, color: TextColourAsh),
                              const SizedBox(height: 4),
                              TextFormField(
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: white,
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: borderColor)),
                                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: borderColor)),
                                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: htltPanelPrimary)),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    CustomText(
                      text: "Current Amp",
                      size: SizeConfig.smallSubText,
                      weight: FontWeight.w600,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(text: "R *", size: SizeConfig.tinyText, color: TextColourAsh),
                              const SizedBox(height: 4),
                              TextFormField(
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: white,
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: borderColor)),
                                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: borderColor)),
                                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: htltPanelPrimary)),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(text: "Y *", size: SizeConfig.tinyText, color: TextColourAsh),
                              const SizedBox(height: 4),
                              TextFormField(
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: white,
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: borderColor)),
                                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: borderColor)),
                                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: htltPanelPrimary)),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(text: "B *", size: SizeConfig.tinyText, color: TextColourAsh),
                              const SizedBox(height: 4),
                              TextFormField(
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: white,
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: borderColor)),
                                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: borderColor)),
                                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: htltPanelPrimary)),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(text: "TAP Position *", size: SizeConfig.smallSubText, weight: FontWeight.w600),
                              const SizedBox(height: 6),
                              DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: white,
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: borderColor)),
                                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: borderColor)),
                                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: htltPanelPrimary)),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                ),
                                items: [],
                                onChanged: (value) {},
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(text: "KWH *", size: SizeConfig.smallSubText, weight: FontWeight.w600),
                              const SizedBox(height: 6),
                              TextFormField(
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: white,
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: borderColor)),
                                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: borderColor)),
                                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: htltPanelPrimary)),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: surfaceDark,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: "Incomer-2 (From Tr-2)",
                      size: SizeConfig.smallSubText,
                      weight: FontWeight.w600,
                    ),
                    const SizedBox(height: 12),
                    CustomText(
                      text: "Voltage",
                      size: SizeConfig.smallSubText,
                      weight: FontWeight.w600,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(text: "RY *", size: SizeConfig.tinyText, color: TextColourAsh),
                              const SizedBox(height: 4),
                              TextFormField(
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: white,
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: borderColor)),
                                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: borderColor)),
                                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: htltPanelPrimary)),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(text: "YB *", size: SizeConfig.tinyText, color: TextColourAsh),
                              const SizedBox(height: 4),
                              TextFormField(
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: white,
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: borderColor)),
                                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: borderColor)),
                                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: htltPanelPrimary)),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(text: "BR *", size: SizeConfig.tinyText, color: TextColourAsh),
                              const SizedBox(height: 4),
                              TextFormField(
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: white,
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: borderColor)),
                                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: borderColor)),
                                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: htltPanelPrimary)),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    CustomText(
                      text: "Current Amp",
                      size: SizeConfig.smallSubText,
                      weight: FontWeight.w600,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(text: "R *", size: SizeConfig.tinyText, color: TextColourAsh),
                              const SizedBox(height: 4),
                              TextFormField(
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: white,
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: borderColor)),
                                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: borderColor)),
                                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: htltPanelPrimary)),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(text: "Y *", size: SizeConfig.tinyText, color: TextColourAsh),
                              const SizedBox(height: 4),
                              TextFormField(
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: white,
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: borderColor)),
                                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: borderColor)),
                                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: htltPanelPrimary)),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(text: "B *", size: SizeConfig.tinyText, color: TextColourAsh),
                              const SizedBox(height: 4),
                              TextFormField(
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: white,
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: borderColor)),
                                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: borderColor)),
                                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: htltPanelPrimary)),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(text: "TAP Position *", size: SizeConfig.smallSubText, weight: FontWeight.w600),
                              const SizedBox(height: 6),
                              DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: white,
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: borderColor)),
                                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: borderColor)),
                                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: htltPanelPrimary)),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                ),
                                items: [],
                                onChanged: (value) {},
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(text: "KWH *", size: SizeConfig.smallSubText, weight: FontWeight.w600),
                              const SizedBox(height: 6),
                              TextFormField(
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: white,
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: borderColor)),
                                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: borderColor)),
                                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: htltPanelPrimary)),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: surfaceDark,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: "Incomer-3 (From Tr-3)",
                      size: SizeConfig.smallSubText,
                      weight: FontWeight.w600,
                    ),
                    const SizedBox(height: 12),
                    CustomText(
                      text: "Voltage",
                      size: SizeConfig.smallSubText,
                      weight: FontWeight.w600,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(text: "RY *", size: SizeConfig.tinyText, color: TextColourAsh),
                              const SizedBox(height: 4),
                              TextFormField(
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: white,
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: borderColor)),
                                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: borderColor)),
                                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: htltPanelPrimary)),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(text: "YB *", size: SizeConfig.tinyText, color: TextColourAsh),
                              const SizedBox(height: 4),
                              TextFormField(
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: white,
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: borderColor)),
                                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: borderColor)),
                                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: htltPanelPrimary)),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(text: "BR *", size: SizeConfig.tinyText, color: TextColourAsh),
                              const SizedBox(height: 4),
                              TextFormField(
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: white,
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: borderColor)),
                                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: borderColor)),
                                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: htltPanelPrimary)),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    CustomText(
                      text: "Current Amp",
                      size: SizeConfig.smallSubText,
                      weight: FontWeight.w600,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(text: "R *", size: SizeConfig.tinyText, color: TextColourAsh),
                              const SizedBox(height: 4),
                              TextFormField(
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: white,
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: borderColor)),
                                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: borderColor)),
                                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: htltPanelPrimary)),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(text: "Y *", size: SizeConfig.tinyText, color: TextColourAsh),
                              const SizedBox(height: 4),
                              TextFormField(
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: white,
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: borderColor)),
                                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: borderColor)),
                                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: htltPanelPrimary)),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(text: "B *", size: SizeConfig.tinyText, color: TextColourAsh),
                              const SizedBox(height: 4),
                              TextFormField(
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: white,
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: borderColor)),
                                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: borderColor)),
                                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: htltPanelPrimary)),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(text: "TAP Position *", size: SizeConfig.smallSubText, weight: FontWeight.w600),
                              const SizedBox(height: 6),
                              DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: white,
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: borderColor)),
                                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: borderColor)),
                                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: htltPanelPrimary)),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                ),
                                items: [],
                                onChanged: (value) {},
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(text: "KWH *", size: SizeConfig.smallSubText, weight: FontWeight.w600),
                              const SizedBox(height: 6),
                              TextFormField(
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: white,
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: borderColor)),
                                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: borderColor)),
                                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: htltPanelPrimary)),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: htltPanelPrimary,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: CustomText(
                    text: "Submit",
                    size: SizeConfig.medtitleText,
                    color: white,
                    weight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _openWithNFCAuth({required String topic, required String targetView}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CommonNFCAuth(
          topic: topic,
          userName: Utilities.userName,
          building: "PRESTIGE",
          authorizedId: '123',
          onAuthSuccess: (scannedId) {
            Navigator.pop(context);
            if(targetView=='ht'){
              _CreateLog(context);
            }else
              {
                _CreateLTLog(context);
              }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return BlocListener<HtltssreenBloc, HtltssreenState>(
      listener: (context, state) {
      },
      child: BlocBuilder<HtltssreenBloc, HtltssreenState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: appBackground,
            appBar: AppBar(
              backgroundColor: htltPanelPrimary,
              elevation: 0,
              leading: selectedView != 'menu'
                  ? IconButton(
                icon: Icon(Icons.arrow_back, color: white),
                onPressed: () {
                  setState(() {
                    selectedView = 'menu';
                  });
                },
              )
                  : IconButton(
                icon: Icon(Icons.arrow_back, color: white),
                onPressed: () => context.go('/home'),
              ),
              title: CustomText(
                text: selectedView == 'menu'
                    ? 'HT/LT Panel Monitoring'
                    : selectedView == 'ht'
                    ? 'HT Panel Logs'
                    : selectedView == 'lt'
                    ? 'LT Panel Logs'
                    : 'HT/LT Panel',
                size: SizeConfig.medtitleText,
                weight: FontWeight.w700,
                color: white,
              ),
              actions: [
                if (selectedView == 'menu')
                  IconButton(
                    icon: Icon(Icons.refresh, color: white),
                    onPressed: () {
                    },
                  ),
                if(selectedView =='ht')
                  GestureDetector(
                    onTap: (){
                      _openWithNFCAuth(topic: 'HT Panel', targetView: 'ht');
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(7),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 7, horizontal: 10),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.add, color: htltPanelPrimary, size: 18),
                          SizedBox(width: 5),
                          CustomText(
                            text: "Create",
                            color: htltPanelPrimary,
                            size: SizeConfig.medtitleText,
                            weight: FontWeight.w600,
                          ),
                        ],
                      ),
                    ),
                  ),
                if(selectedView =='lt')
                  GestureDetector(
                    onTap: (){
                      _openWithNFCAuth(topic: 'LT Panel', targetView: 'lt');
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(7),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 7, horizontal: 10),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.add, color: htltPanelPrimary, size: 18),
                          SizedBox(width: 5),
                          CustomText(
                            text: "Create",
                            color: htltPanelPrimary,
                            size: SizeConfig.medtitleText,
                            weight: FontWeight.w600,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            body: FadeTransition(
              opacity: _fadeAnimation,
              child: selectedView == 'menu'
                  ? _buildMainMenu()
                  : selectedView == 'ht'
                  ? _buildHTPanel()
                  : selectedView == 'lt'
                  ? _buildLTPanel()
                  : _buildMainMenu(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMainMenu() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(SizeConfig.commonMargin! * 1.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard(),
          Gap(SizeConfig.commonMargin! * 2),
          CustomText(
            text: 'Panel Monitoring',
            size: SizeConfig.subText,
            weight: FontWeight.w700,
            color: TextColourBlk,
          ),
          Gap(SizeConfig.commonMargin! * 1.5),
          _buildMenuOption(
            title: 'HT Panel',
            subtitle: 'High Tension Panel Logs',
            icon: Icons.bolt,
            color: htltPanelPrimary,
            onTap: () {
              setState(() {
                selectedView = 'ht';
              });

            },
          ),
          Gap(SizeConfig.commonMargin! * 1.5),
          _buildMenuOption(
            title: 'LT Panel',
            subtitle: 'Low Tension Panel Logs',
            icon: Icons.electric_bolt,
            color: operatingLogPrimary,
            onTap: () {
              setState(() {
                selectedView = 'lt';
              });
            },
          ),
          Gap(SizeConfig.commonMargin! * 2),
          CustomText(
            text: 'Actions',
            size: SizeConfig.subText,
            weight: FontWeight.w700,
            color: TextColourBlk,
          ),
          Gap(SizeConfig.commonMargin! * 1.5),
          _buildMenuOption(
            title: 'Power Failure Log',
            subtitle: 'Add power failure details',
            icon: Icons.power_off,
            color: statusError,
            onTap: () => _showPowerFailureDialog(),
          ),
          Gap(SizeConfig.commonMargin! * 1.5),
          _buildMenuOption(
            title: 'Add Remarks',
            subtitle: 'Add notes and observations',
            icon: Icons.note_add,
            color: statusInfo,
            onTap: () => _showRemarksDialog(),
          ),
          Gap(SizeConfig.commonMargin! * 1.5),
          _buildMenuOption(
            title: 'Verify Logs',
            subtitle: 'Verify all panel entries',
            icon: Icons.verified,
            color: statusActive,
            onTap: () => _showVerifyDialog(),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: EdgeInsets.all(SizeConfig.commonMargin! * 1.5),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [htltPanelPrimary, htltPanelPrimary.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: htltPanelPrimary.withOpacity(0.3),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.dashboard,
                  color: white,
                  size: SizeConfig.medtitleText,
                ),
              ),
              Gap(SizeConfig.commonMargin! * 1),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: sampleData['building'] ?? 'N/A',
                      size: SizeConfig.medtitleText,
                      weight: FontWeight.w700,
                      color: white,
                    ),
                    Gap(SizeConfig.commonMargin! * 0.3),
                    CustomText(
                      text: DateFormat('EEEE, MMMM dd, yyyy').format(
                          DateTime.parse(sampleData['date'] ?? DateTime.now().toString())
                      ),
                      size: SizeConfig.smallSubText,
                      weight: FontWeight.w400,
                      color: white.withOpacity(0.9),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Gap(SizeConfig.commonMargin! * 1.5),
          Container(
            height: 0.5,
            color: white.withOpacity(0.3),
          ),
          Gap(SizeConfig.commonMargin! * 1.5),
          Row(
            children: [
              Expanded(
                child: _buildInfoItem(
                  'Time Slot',
                  sampleData['time'] ?? 'N/A',
                  Icons.access_time,
                ),
              ),
              Container(
                width: 0.5,
                height: 40,
                color: white.withOpacity(0.3),
              ),
              Expanded(
                child: _buildInfoItem(
                  'Panel Type',
                  sampleData['panelType'] ?? 'N/A',
                  Icons.category,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: white.withOpacity(0.8), size: 20),
        Gap(SizeConfig.commonMargin! * 0.5),
        CustomText(
          text: label,
          size: SizeConfig.miniText,
          weight: FontWeight.w400,
          color: white.withOpacity(0.8),
        ),
        Gap(SizeConfig.commonMargin! * 0.3),
        CustomText(
          text: value,
          size: SizeConfig.smallSubText,
          weight: FontWeight.w700,
          color: white,
        ),
      ],
    );
  }

  Widget _buildMenuOption({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(SizeConfig.commonMargin! * 1.5),
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withOpacity(0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 55,
              height: 55,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: color,
                size: SizeConfig.medtitleText,
              ),
            ),
            Gap(SizeConfig.commonMargin! * 1.5),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: title,
                    size: SizeConfig.subText,
                    weight: FontWeight.w700,
                    color: TextColourBlk,
                  ),
                  Gap(SizeConfig.commonMargin! * 0.3),
                  CustomText(
                    text: subtitle,
                    size: SizeConfig.smallSubText,
                    weight: FontWeight.w400,
                    color: TextColourAsh,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: TextColourAsh,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHTPanel() {
    final htData = sampleData['htPanel'] as Map<String, dynamic>?;
    if (htData == null) return Center(child: CustomText(text: 'No HT data available', size: SizeConfig.subText));

    return SingleChildScrollView(
      padding: EdgeInsets.all(SizeConfig.commonMargin! * 1.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDateTimeHeader(),
          Gap(SizeConfig.commonMargin! * 1.5),
          _buildMainIncomingSupplyCard(htData),
          Gap(SizeConfig.commonMargin! * 1.5),
          CustomText(
            text: 'Outgoing Transformers',
            size: SizeConfig.subText,
            weight: FontWeight.w700,
            color: TextColourBlk,
          ),
          Gap(SizeConfig.commonMargin! * 1.5),
          _buildTransformerCard('TR-1 (2000 KVA)', htData['outgoingTr1']),
          Gap(SizeConfig.commonMargin! * 1.5),
          _buildTransformerCard('TR-2 (2000 KVA)', htData['outgoingTr2']),
          Gap(SizeConfig.commonMargin! * 1.5),
          _buildTransformerCard('TR-3 (2000 KVA)', htData['outgoingTr3']),
        ],
      ),
    );
  }

  Widget _buildLTPanel() {
    final ltData = sampleData['ltPanel'] as Map<String, dynamic>?;
    if (ltData == null) return Center(child: CustomText(text: 'No LT data available', size: SizeConfig.subText));

    return SingleChildScrollView(
      padding: EdgeInsets.all(SizeConfig.commonMargin! * 1.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDateTimeHeader(),
          Gap(SizeConfig.commonMargin! * 1.5),
          CustomText(
            text: 'Incomers',
            size: SizeConfig.subText,
            weight: FontWeight.w700,
            color: TextColourBlk,
          ),
          Gap(SizeConfig.commonMargin! * 1.5),
          _buildIncomerCard('Incomer 1 (From TR-1)', ltData['incomer1']),
          Gap(SizeConfig.commonMargin! * 1.5),
          _buildIncomerCard('Incomer 2 (From TR-2)', ltData['incomer2']),
          Gap(SizeConfig.commonMargin! * 1.5),
          _buildIncomerCard('Incomer 3 (From TR-3)', ltData['incomer3']),
        ],
      ),
    );
  }

  Widget _buildDateTimeHeader() {
    return Container(
      padding: EdgeInsets.all(SizeConfig.commonMargin! * 1.2),
      decoration: BoxDecoration(
        color: htltPanelLight,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: htltPanelPrimary.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.calendar_today, color: htltPanelPrimary, size: 18),
          Gap(SizeConfig.commonMargin!),
          CustomText(
            text: DateFormat('MMM dd, yyyy - HH:mm').format(
                DateTime.parse('${sampleData['date']} ${sampleData['time']}:00')
            ),
            size: SizeConfig.smallSubText,
            weight: FontWeight.w600,
            color: htltPanelPrimary,
          ),
        ],
      ),
    );
  }

  Widget _buildMainIncomingSupplyCard(Map<String, dynamic> htData) {
    final currentAmp = htData['currentAmp'] as Map<String, dynamic>?;
    final voltage = htData['voltageFromWreb'] as Map<String, dynamic>?;

    return Container(
      padding: EdgeInsets.all(SizeConfig.commonMargin! * 1.5),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: htltPanelPrimary.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: htltPanelPrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.flash_on,
                  color: htltPanelPrimary,
                  size: SizeConfig.medtitleText,
                ),
              ),
              Gap(SizeConfig.commonMargin! * 1),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: 'Main Incomer Supply',
                      size: SizeConfig.subText,
                      weight: FontWeight.w700,
                      color: TextColourBlk,
                    ),
                    Gap(SizeConfig.commonMargin! * 0.3),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.commonMargin! * 0.6,
                            vertical: SizeConfig.commonMargin! * 0.3,
                          ),
                          decoration: BoxDecoration(
                            color: statusActive.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: CustomText(
                            text: htData['icFromTneb'] ?? 'N/A',
                            size: SizeConfig.miniText,
                            weight: FontWeight.w700,
                            color: statusActive,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Gap(SizeConfig.commonMargin! * 1.5),
          Container(
            height: 0.5,
            color: Grey_Lit_Line,
          ),
          Gap(SizeConfig.commonMargin! * 1.5),
          CustomText(
            text: 'Voltage',
            size: SizeConfig.smallSubText,
            weight: FontWeight.w600,
            color: TextColourAsh,
          ),
          Gap(SizeConfig.commonMargin! * 1),
          _buildVoltageDisplay(voltage?['volt'] ?? 'N/A'),
          Gap(SizeConfig.commonMargin! * 1.5),
          CustomText(
            text: 'Current Amperage',
            size: SizeConfig.smallSubText,
            weight: FontWeight.w600,
            color: TextColourAsh,
          ),
          Gap(SizeConfig.commonMargin! * 1),
          _buildCurrentAmpRow(currentAmp),
          Gap(SizeConfig.commonMargin! * 1.5),
          Row(
            children: [
              Expanded(
                child: _buildMetricBox('Frequency', '${currentAmp?['hz'] ?? 'N/A'} Hz', Icons.analytics),
              ),
              Gap(SizeConfig.commonMargin!),
              Expanded(
                child: _buildMetricBox('Power Factor', currentAmp?['pf'] ?? 'N/A', Icons.power),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVoltageDisplay(String voltage) {
    return Container(
      padding: EdgeInsets.all(SizeConfig.commonMargin! * 1.2),
      decoration: BoxDecoration(
        color: htltPanelLight,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: htltPanelPrimary.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.electric_bolt, color: htltPanelPrimary, size: 28),
          Gap(SizeConfig.commonMargin!),
          CustomText(
            text: voltage,
            size: SizeConfig.medbigText,
            weight: FontWeight.w700,
            color: htltPanelPrimary,
          ),
          Gap(SizeConfig.commonMargin! * 0.5),
          CustomText(
            text: 'KV',
            size: SizeConfig.subText,
            weight: FontWeight.w600,
            color: TextColourAsh,
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentAmpRow(Map<String, dynamic>? currentAmp) {
    return Row(
      children: [
        Expanded(
          child: _buildPhaseBox('R', currentAmp?['r'] ?? 'N/A', Color(0xFFE63946)),
        ),
        Gap(SizeConfig.commonMargin!),
        Expanded(
          child: _buildPhaseBox('Y', currentAmp?['y'] ?? 'N/A', Color(0xFFF77F00)),
        ),
        Gap(SizeConfig.commonMargin!),
        Expanded(
          child: _buildPhaseBox('B', currentAmp?['b'] ?? 'N/A', Color(0xFF0077B6)),
        ),
      ],
    );
  }

  Widget _buildPhaseBox(String phase, String value, Color color) {
    return Container(
      padding: EdgeInsets.all(SizeConfig.commonMargin! * 1),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          CustomText(
            text: phase,
            size: SizeConfig.smallSubText,
            weight: FontWeight.w700,
            color: color,
          ),
          Gap(SizeConfig.commonMargin! * 0.5),
          CustomText(
            text: value,
            size: SizeConfig.medtitleText,
            weight: FontWeight.w700,
            color: TextColourBlk,
          ),
          Gap(SizeConfig.commonMargin! * 0.3),
          CustomText(
            text: 'A',
            size: SizeConfig.miniText,
            weight: FontWeight.w500,
            color: TextColourAsh,
          ),
        ],
      ),
    );
  }

  Widget _buildMetricBox(String label, String value, IconData icon) {
    return Container(
      padding: EdgeInsets.all(SizeConfig.commonMargin! * 1),
      decoration: BoxDecoration(
        color: surfaceDark,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, color: htltPanelPrimary, size: 20),
          Gap(SizeConfig.commonMargin! * 0.5),
          CustomText(
            text: label,
            size: SizeConfig.miniText,
            weight: FontWeight.w500,
            color: TextColourAsh,
            textAlign: TextAlign.center,
          ),
          Gap(SizeConfig.commonMargin! * 0.3),
          CustomText(
            text: value,
            size: SizeConfig.smallSubText,
            weight: FontWeight.w700,
            color: TextColourBlk,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTransformerCard(String title, Map<String, dynamic>? trData) {
    if (trData == null) return SizedBox();

    final currentAmp = trData['currentAmp'] as Map<String, dynamic>?;

    return Container(
      padding: EdgeInsets.all(SizeConfig.commonMargin! * 1.5),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: htltPanelPrimary.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: operatingLogPrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.device_hub,
                  color: operatingLogPrimary,
                  size: SizeConfig.medtitleText,
                ),
              ),
              Gap(SizeConfig.commonMargin! * 1),
              Expanded(
                child: CustomText(
                  text: title,
                  size: SizeConfig.subText,
                  weight: FontWeight.w700,
                  color: TextColourBlk,
                ),
              ),
            ],
          ),
          Gap(SizeConfig.commonMargin! * 1.5),
          Container(
            height: 0.5,
            color: Grey_Lit_Line,
          ),
          Gap(SizeConfig.commonMargin! * 1.5),
          CustomText(
            text: 'Current Amperage',
            size: SizeConfig.smallSubText,
            weight: FontWeight.w600,
            color: TextColourAsh,
          ),
          Gap(SizeConfig.commonMargin! * 1),
          _buildCurrentAmpRow(currentAmp),
          Gap(SizeConfig.commonMargin! * 1.5),
          Row(
            children: [
              Expanded(
                child: _buildTempBox('Oil Temp', '${trData['oilTemp'] ?? 'N/A'}°C', Icons.thermostat),
              ),
              Gap(SizeConfig.commonMargin!),
              Expanded(
                child: _buildTempBox('Winding Temp', '${trData['windingTemp'] ?? 'N/A'}°C', Icons.device_thermostat),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTempBox(String label, String value, IconData icon) {
    return Container(
      padding: EdgeInsets.all(SizeConfig.commonMargin! * 1),
      decoration: BoxDecoration(
        color: statusWarning.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: statusWarning.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: statusWarning, size: 20),
          Gap(SizeConfig.commonMargin! * 0.5),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: label,
                size: SizeConfig.miniText,
                weight: FontWeight.w500,
                color: TextColourAsh,
              ),
              CustomText(
                text: value,
                size: SizeConfig.smallSubText,
                weight: FontWeight.w700,
                color: TextColourBlk,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIncomerCard(String title, Map<String, dynamic>? incomerData) {
    if (incomerData == null) return SizedBox();

    final voltage = incomerData['voltage'] as Map<String, dynamic>?;
    final currentAmp = incomerData['currentAmp'] as Map<String, dynamic>?;

    return Container(
      padding: EdgeInsets.all(SizeConfig.commonMargin! * 1.5),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: operatingLogPrimary.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: operatingLogPrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.electrical_services,
                  color: operatingLogPrimary,
                  size: SizeConfig.medtitleText,
                ),
              ),
              Gap(SizeConfig.commonMargin! * 1),
              Expanded(
                child: CustomText(
                  text: title,
                  size: SizeConfig.subText,
                  weight: FontWeight.w700,
                  color: TextColourBlk,
                ),
              ),
            ],
          ),
          Gap(SizeConfig.commonMargin! * 1.5),
          Container(
            height: 0.5,
            color: Grey_Lit_Line,
          ),
          Gap(SizeConfig.commonMargin! * 1.5),
          Row(
            children: [
              Expanded(
                child: _buildMetricBox('KWH', incomerData['kwh'] ?? 'N/A', Icons.electric_meter),
              ),
              Gap(SizeConfig.commonMargin!),
              Expanded(
                child: _buildMetricBox('Tap No.', incomerData['tap'] ?? 'N/A', Icons.tune),
              ),
            ],
          ),
          Gap(SizeConfig.commonMargin! * 1.5),
          CustomText(
            text: 'Voltage',
            size: SizeConfig.smallSubText,
            weight: FontWeight.w600,
            color: TextColourAsh,
          ),
          Gap(SizeConfig.commonMargin! * 1),
          _buildVoltageRow(voltage),
          Gap(SizeConfig.commonMargin! * 1.5),
          CustomText(
            text: 'Current Amperage',
            size: SizeConfig.smallSubText,
            weight: FontWeight.w600,
            color: TextColourAsh,
          ),
          Gap(SizeConfig.commonMargin! * 1),
          _buildCurrentAmpRow(currentAmp),
        ],
      ),
    );
  }

  Widget _buildVoltageRow(Map<String, dynamic>? voltage) {
    return Row(
      children: [
        Expanded(
          child: _buildVoltagePhaseBox('BR', voltage?['br'] ?? 'N/A', Color(0xFF8B4513)),
        ),
        Gap(SizeConfig.commonMargin!),
        Expanded(
          child: _buildVoltagePhaseBox('RY', voltage?['ry'] ?? 'N/A', Color(0xFF1B6B3F)),
        ),
        Gap(SizeConfig.commonMargin!),
        Expanded(
          child: _buildVoltagePhaseBox('YB', voltage?['yb'] ?? 'N/A', Color(0xFF6B3FA0)),
        ),
      ],
    );
  }

  Widget _buildVoltagePhaseBox(String phase, String value, Color color) {
    return Container(
      padding: EdgeInsets.all(SizeConfig.commonMargin! * 1),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          CustomText(
            text: phase,
            size: SizeConfig.smallSubText,
            weight: FontWeight.w700,
            color: color,
          ),
          Gap(SizeConfig.commonMargin! * 0.5),
          CustomText(
            text: value,
            size: SizeConfig.medtitleText,
            weight: FontWeight.w700,
            color: TextColourBlk,
          ),
          Gap(SizeConfig.commonMargin! * 0.3),
          CustomText(
            text: 'V',
            size: SizeConfig.miniText,
            weight: FontWeight.w500,
            color: TextColourAsh,
          ),
        ],
      ),
    );
  }

  void _showPowerFailureDialog() {
    TimeOfDay? fromTime;
    TimeOfDay? toTime;
    final TextEditingController reasonController = TextEditingController();
    bool isFullDayFailure = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 10,
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.75,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(SizeConfig.commonMargin! * 2),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [statusError, statusError.withOpacity(0.8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: statusError.withOpacity(0.3),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                          color: white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.power_off, color: white, size: 24),
                      ),
                      Gap(SizeConfig.commonMargin! * 1.2),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: 'Power Failure Log',
                              size: SizeConfig.medtitleText,
                              weight: FontWeight.w700,
                              color: white,
                            ),
                            Gap(SizeConfig.commonMargin! * 0.3),
                            CustomText(
                              text: 'Record power outage details',
                              size: SizeConfig.miniText,
                              weight: FontWeight.w400,
                              color: white.withOpacity(0.9),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: white, size: 22),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.commonMargin! * 1.5,
                      vertical: SizeConfig.commonMargin! * 2,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setDialogState(() {
                              isFullDayFailure = !isFullDayFailure;
                              if (isFullDayFailure) {
                                fromTime = TimeOfDay(hour: 0, minute: 0);
                                toTime = TimeOfDay(hour: 23, minute: 59);
                              } else {
                                fromTime = null;
                                toTime = null;
                              }
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(SizeConfig.commonMargin! * 1.5),
                            decoration: BoxDecoration(
                              gradient: isFullDayFailure
                                  ? LinearGradient(
                                colors: [statusError.withOpacity(0.1), statusError.withOpacity(0.05)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                                  : null,
                              color: isFullDayFailure ? null : surfaceDark,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isFullDayFailure ? statusError.withOpacity(0.5) : borderColor,
                                width: isFullDayFailure ? 2 : 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: isFullDayFailure ? statusError : white,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isFullDayFailure ? statusError : borderColor,
                                      width: 2,
                                    ),
                                  ),
                                  child: isFullDayFailure
                                      ? Icon(Icons.check, color: white, size: 16)
                                      : null,
                                ),
                                Gap(SizeConfig.commonMargin! * 1.2),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      CustomText(
                                        text: 'Full Day Power Failure',
                                        size: SizeConfig.subText,
                                        weight: FontWeight.w700,
                                        color: TextColourBlk,
                                      ),
                                      Gap(SizeConfig.commonMargin! * 0.3),
                                      CustomText(
                                        text: '00:00 - 23:59 (Entire Day)',
                                        size: SizeConfig.smallSubText,
                                        weight: FontWeight.w400,
                                        color: TextColourAsh,
                                      ),
                                    ],
                                  ),
                                ),
                                if (isFullDayFailure)
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: SizeConfig.commonMargin! * 0.8,
                                      vertical: SizeConfig.commonMargin! * 0.4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: statusError,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: CustomText(
                                      text: 'ACTIVE',
                                      size: SizeConfig.miniText,
                                      weight: FontWeight.w700,
                                      color: white,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        Gap(SizeConfig.commonMargin! * 2),
                        if (!isFullDayFailure) ...[
                          Row(
                            children: [
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.schedule, color: statusError, size: 18),
                                        Gap(SizeConfig.commonMargin! * 0.5),
                                        CustomText(
                                          text: 'From Time',
                                          size: SizeConfig.smallSubText,
                                          weight: FontWeight.w700,
                                          color: TextColourBlk,
                                        ),
                                        Gap(SizeConfig.commonMargin! * 0.3),
                                        CustomText(
                                          text: '*',
                                          size: SizeConfig.smallSubText,
                                          weight: FontWeight.w700,
                                          color: statusError,
                                        ),
                                      ],
                                    ),
                                    Gap(SizeConfig.commonMargin! * 0.8),
                                    GestureDetector(
                                      onTap: () async {
                                        final time = await showTimePicker(
                                          context: context,
                                          initialTime: fromTime ?? TimeOfDay.now(),
                                          builder: (context, child) {
                                            return Theme(
                                              data: Theme.of(context).copyWith(
                                                colorScheme: ColorScheme.light(
                                                  primary: statusError,
                                                  onPrimary: white,
                                                  onSurface: TextColourBlk,
                                                ),
                                              ),
                                              child: child!,
                                            );
                                          },
                                        );
                                        if (time != null) {
                                          setDialogState(() {
                                            fromTime = time;
                                          });
                                        }
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(SizeConfig.commonMargin! * 1.2),
                                        decoration: BoxDecoration(
                                          color: white,
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(
                                            color: fromTime != null ? statusError.withOpacity(0.5) : borderColor,
                                            width: fromTime != null ? 2 : 1,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.05),
                                              blurRadius: 4,
                                              offset: Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.access_time,
                                              color: fromTime != null ? statusError : TextColourAsh,
                                              size: 20,
                                            ),
                                            Gap(SizeConfig.commonMargin! * 0.8),
                                            CustomText(
                                              text: fromTime != null ? fromTime!.format(context) : '--:--',
                                              size: SizeConfig.medtitleText,
                                              weight: FontWeight.w700,
                                              color: fromTime != null ? TextColourBlk : TextColourAsh,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Gap(SizeConfig.commonMargin!),
                              Container(
                                margin: EdgeInsets.only(top: SizeConfig.commonMargin! * 2.5),
                                child: Icon(Icons.arrow_forward, color: TextColourAsh, size: 20),
                              ),
                              Gap(SizeConfig.commonMargin!),
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.schedule, color: statusError, size: 18),
                                        Gap(SizeConfig.commonMargin! * 0.5),
                                        CustomText(
                                          text: 'To Time',
                                          size: SizeConfig.smallSubText,
                                          weight: FontWeight.w700,
                                          color: TextColourBlk,
                                        ),
                                        Gap(SizeConfig.commonMargin! * 0.3),
                                        CustomText(
                                          text: '*',
                                          size: SizeConfig.smallSubText,
                                          weight: FontWeight.w700,
                                          color: statusError,
                                        ),
                                      ],
                                    ),
                                    Gap(SizeConfig.commonMargin! * 0.8),
                                    GestureDetector(
                                      onTap: () async {
                                        final time = await showTimePicker(
                                          context: context,
                                          initialTime: toTime ?? TimeOfDay.now(),
                                          builder: (context, child) {
                                            return Theme(
                                              data: Theme.of(context).copyWith(
                                                colorScheme: ColorScheme.light(
                                                  primary: statusError,
                                                  onPrimary: white,
                                                  onSurface: TextColourBlk,
                                                ),
                                              ),
                                              child: child!,
                                            );
                                          },
                                        );
                                        if (time != null) {
                                          setDialogState(() {
                                            toTime = time;
                                          });
                                        }
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(SizeConfig.commonMargin! * 1.2),
                                        decoration: BoxDecoration(
                                          color: white,
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(
                                            color: toTime != null ? statusError.withOpacity(0.5) : borderColor,
                                            width: toTime != null ? 2 : 1,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.05),
                                              blurRadius: 4,
                                              offset: Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.access_time,
                                              color: toTime != null ? statusError : TextColourAsh,
                                              size: 20,
                                            ),
                                            Gap(SizeConfig.commonMargin! * 0.8),
                                            CustomText(
                                              text: toTime != null ? toTime!.format(context) : '--:--',
                                              size: SizeConfig.medtitleText,
                                              weight: FontWeight.w700,
                                              color: toTime != null ? TextColourBlk : TextColourAsh,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Gap(SizeConfig.commonMargin! * 2),
                        ],
                        Row(
                          children: [
                            Icon(Icons.description, color: statusWarning, size: 18),
                            Gap(SizeConfig.commonMargin! * 0.5),
                            CustomText(
                              text: 'Reason (Optional)',
                              size: SizeConfig.smallSubText,
                              weight: FontWeight.w700,
                              color: TextColourBlk,
                            ),
                          ],
                        ),
                        Gap(SizeConfig.commonMargin! * 0.8),
                        Container(
                          decoration: BoxDecoration(
                            color: white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: borderColor),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: reasonController,
                            maxLines: 3,
                            style: TextStyle(
                              fontSize: SizeConfig.smallSubText,
                              color: TextColourBlk,
                              fontFamily: 'Lato',
                            ),
                            decoration: InputDecoration(
                              hintText: 'Describe the reason for power failure...',
                              hintStyle: TextStyle(
                                color: TextColourAsh,
                                fontSize: SizeConfig.smallSubText,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(SizeConfig.commonMargin! * 1.2),
                            ),
                          ),
                        ),
                        Gap(SizeConfig.commonMargin! * 2),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => Navigator.pop(context),
                                style: OutlinedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(vertical: SizeConfig.commonMargin! * 1.5),
                                  side: BorderSide(color: borderColor, width: 1.5),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: CustomText(
                                  text: 'Cancel',
                                  size: SizeConfig.subText,
                                  weight: FontWeight.w700,
                                  color: TextColourAsh,
                                ),
                              ),
                            ),
                            Gap(SizeConfig.commonMargin! * 1.5),
                            Expanded(
                              flex: 2,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [statusActive, statusActive.withOpacity(0.8)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: statusActive.withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Row(
                                          children: [
                                            Icon(Icons.check_circle, color: white),
                                            Gap(SizeConfig.commonMargin!),
                                            Expanded(
                                              child: CustomText(
                                                text: 'Power failure entry added successfully',
                                                size: SizeConfig.smallSubText,
                                                color: white,
                                              ),
                                            ),
                                          ],
                                        ),
                                        backgroundColor: statusActive,
                                        behavior: SnackBarBehavior.floating,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    padding: EdgeInsets.symmetric(vertical: SizeConfig.commonMargin! * 1.5),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.add_circle_outline, color: white, size: 20),
                                      Gap(SizeConfig.commonMargin! * 0.8),
                                      CustomText(
                                        text: 'Add Entry',
                                        size: SizeConfig.subText,
                                        weight: FontWeight.w700,
                                        color: white,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Gap(SizeConfig.commonMargin! * 2),
                        Container(
                          padding: EdgeInsets.all(SizeConfig.commonMargin! * 1.8),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [surfaceDark, surfaceDark.withOpacity(0.5)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: borderColor.withOpacity(0.5),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.history, color: statusInfo, size: 20),
                                  Gap(SizeConfig.commonMargin! * 0.8),
                                  CustomText(
                                    text: 'Power Failure Entries',
                                    size: SizeConfig.subText,
                                    weight: FontWeight.w700,
                                    color: TextColourBlk,
                                  ),
                                  Gap(SizeConfig.commonMargin! * 0.8),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: SizeConfig.commonMargin! * 0.8,
                                      vertical: SizeConfig.commonMargin! * 0.3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: statusInfo.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: CustomText(
                                      text: '0/5',
                                      size: SizeConfig.miniText,
                                      weight: FontWeight.w700,
                                      color: statusInfo,
                                    ),
                                  ),
                                ],
                              ),
                              Gap(SizeConfig.commonMargin! * 1.5),
                              Container(
                                padding: EdgeInsets.all(SizeConfig.commonMargin! * 2),
                                decoration: BoxDecoration(
                                  color: white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  children: [
                                    Icon(Icons.event_busy, color: TextColourAsh.withOpacity(0.5), size: 40),
                                    Gap(SizeConfig.commonMargin! * 1),
                                    CustomText(
                                      text: 'No entries yet',
                                      size: SizeConfig.smallSubText,
                                      weight: FontWeight.w600,
                                      color: TextColourAsh,
                                      textAlign: TextAlign.center,
                                    ),
                                    Gap(SizeConfig.commonMargin! * 0.5),
                                    CustomText(
                                      text: 'Add your first power failure entry above',
                                      size: SizeConfig.miniText,
                                      weight: FontWeight.w400,
                                      color: TextColourAsh.withOpacity(0.7),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showRemarksDialog() {
    final TextEditingController remarksController = TextEditingController(
      text: sampleData['remarks'] ?? '',
    );

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: EdgeInsets.all(SizeConfig.commonMargin! * 1.5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.note_add, color: statusInfo, size: 24),
                  Gap(SizeConfig.commonMargin!),
                  Expanded(
                    child: CustomText(
                      text: 'Add Remarks',
                      size: SizeConfig.subText,
                      weight: FontWeight.w700,
                      color: TextColourBlk,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: TextColourAsh),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              Gap(SizeConfig.commonMargin! * 1.5),
              CustomText(
                text: 'Enter your remarks or observations',
                size: SizeConfig.smallSubText,
                weight: FontWeight.w400,
                color: TextColourAsh,
              ),
              Gap(SizeConfig.commonMargin! * 1),
              TextField(
                controller: remarksController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Type your remarks here...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: borderColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: borderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: statusInfo, width: 2),
                  ),
                ),
              ),
              Gap(SizeConfig.commonMargin! * 1.5),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: SizeConfig.commonMargin! * 1.2),
                        side: BorderSide(color: borderColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: CustomText(
                        text: 'Cancel',
                        size: SizeConfig.subText,
                        weight: FontWeight.w600,
                        color: TextColourAsh,
                      ),
                    ),
                  ),
                  Gap(SizeConfig.commonMargin!),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: CustomText(
                              text: 'Remarks saved successfully',
                              size: SizeConfig.smallSubText,
                              color: white,
                            ),
                            backgroundColor: statusActive,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: statusInfo,
                        padding: EdgeInsets.symmetric(vertical: SizeConfig.commonMargin! * 1.2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: CustomText(
                        text: 'Save Remarks',
                        size: SizeConfig.subText,
                        weight: FontWeight.w700,
                        color: white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showVerifyDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: EdgeInsets.all(SizeConfig.commonMargin! * 1.5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: statusActive.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.verified,
                  color: statusActive,
                  size: 30,
                ),
              ),
              Gap(SizeConfig.commonMargin! * 1.5),
              CustomText(
                text: 'Verify Logs',
                size: SizeConfig.medtitleText,
                weight: FontWeight.w700,
                color: TextColourBlk,
                textAlign: TextAlign.center,
              ),
              Gap(SizeConfig.commonMargin!),
              CustomText(
                text: 'Are you sure you want to verify all the logs? This action confirms that all entries are accurate and complete.',
                size: SizeConfig.smallSubText,
                weight: FontWeight.w400,
                color: TextColourAsh,
                textAlign: TextAlign.center,
              ),
              Gap(SizeConfig.commonMargin! * 2),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: SizeConfig.commonMargin! * 1.2),
                        side: BorderSide(color: borderColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: CustomText(
                        text: 'Cancel',
                        size: SizeConfig.subText,
                        weight: FontWeight.w600,
                        color: TextColourAsh,
                      ),
                    ),
                  ),
                  Gap(SizeConfig.commonMargin!),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: CustomText(
                              text: 'All logs verified successfully',
                              size: SizeConfig.smallSubText,
                              color: white,
                            ),
                            backgroundColor: statusActive,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: statusActive,
                        padding: EdgeInsets.symmetric(vertical: SizeConfig.commonMargin! * 1.2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: CustomText(
                        text: 'Verify',
                        size: SizeConfig.subText,
                        weight: FontWeight.w700,
                        color: white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}