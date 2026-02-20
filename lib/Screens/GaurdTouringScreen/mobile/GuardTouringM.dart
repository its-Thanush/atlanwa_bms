import 'package:atlanwa_bms/allImports.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager_ndef/nfc_manager_ndef.dart';
import 'package:nfc_manager/ndef_record.dart';

import '../../../model/GuardEntryModel.dart';
import '../../../network/ApiService.dart';

class GuardTouringM extends StatefulWidget {
  const GuardTouringM({super.key});

  @override
  State<GuardTouringM> createState() => _GuardTouringMState();
}

class _GuardTouringMState extends State<GuardTouringM>
    with TickerProviderStateMixin {
  // Animation Controllers
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _pulseController;
  late AnimationController _scanController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _scanScaleAnimation;

  // NFC State
  bool _isNFCAvailable = false;
  bool _isScanning = false;
  String? _guardUsername = 'Security Guard';
  String _building = 'PRESTIGE POLYGON';
  // NfcSession? _currentSession;

  // Touring Data
  List<Map<String, dynamic>> scannedTours = [];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _checkNFCAvailability();
  }

  void _initializeAnimations() {
    // Fade animation
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );
    _fadeController.forward();

    // Slide animation
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOut),
        );
    _slideController.forward();

    // Pulse animation for NFC button
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Scan scale animation
    _scanController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _scanScaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scanController, curve: Curves.elasticOut),
    );
  }

  Future<void> _checkNFCAvailability() async {
    try {
      bool isAvailable = await NfcManager.instance.isAvailable();
      if (mounted) {
        setState(() {
          _isNFCAvailable = isAvailable;
        });
      }
    } catch (e) {
      _showSnackBar('NFC check failed: $e', isError: true);
    }
  }

  void _startNFCScanning() {
    if (!_isNFCAvailable) {
      _showSnackBar('NFC is not available on this device', isError: true);
      return;
    }

    if (_isScanning) {
      _showSnackBar('Scanning already in progress', isError: true);
      return;
    }

    setState(() {
      _isScanning = true;
    });
    _scanController.forward(from: 0.0);

    NfcManager.instance.startSession(
      pollingOptions: {
        NfcPollingOption.iso14443,
        NfcPollingOption.iso15693,
        NfcPollingOption.iso18092,
      },
      onDiscovered: (NfcTag tag) async {
        if (!mounted) return;

        try {
          var ndef = Ndef.from(tag);
          if (ndef == null) {
            _showSnackBar('Tag is not NDEF formatted', isError: true);
            setState(() => _isScanning = false);
            await _stopNFCSession();
            return;
          }

          NdefMessage? message = await ndef.read();
          if (message == null || message.records.isEmpty) {
            _showSnackBar('No data found on tag', isError: true);
            setState(() => _isScanning = false);
            await _stopNFCSession();
            return;
          }

          String tagId = _parseNdefMessage(message);

          if (!mounted) return;

          await _submitGuardEntry(tagId);

          await _stopNFCSession();

          await Future.delayed(const Duration(seconds: 2));
          if (mounted) {
            _resetForNextScan();
          }
        } catch (e) {
          debugPrint('Error reading NFC: $e');
          _showSnackBar('Error reading NFC: $e', isError: true);
          setState(() => _isScanning = false);
          await _stopNFCSession();
        }
      },
    );
  }

  Future<void> _submitGuardEntry(String tagId) async {
    try {
      final request = GuardEntryRQ(
        tagId: tagId,
        username: _guardUsername,
        building: _building,
      );

      final response = await ApiServices.GuardEntry(request);

      if (response.success == true) {
        final now = DateTime.now();
        setState(() {
          scannedTours.add({
            'location': response.location ?? tagId.trim(),
            'floor': response.floor ?? 'N/A',
            'checkpoint': 'CP-${scannedTours.length + 1}',
            'guardName': _guardUsername,
            'timestamp': now,
            'status': 'Completed',
            'remarks': response.message ?? 'NFC scanned successfully',
          });
          _isScanning = false;
        });

        _showSnackBar('✓ ${response.message ?? "Location scanned successfully"}');
      } else {
        _showSnackBar(response.message ?? 'Failed to submit entry', isError: true);
        setState(() => _isScanning = false);
      }
    } catch (e) {
      debugPrint('API Error: $e');
      _showSnackBar('Failed to submit entry: $e', isError: true);
      setState(() => _isScanning = false);
    }
  }

  /// Parse NDEF message and extract location data
  String _parseNdefMessage(NdefMessage message) {
    String location = '';

    for (var record in message.records) {
      try {
        if (record.typeNameFormat == TypeNameFormat.wellKnown) {
          var payload = record.payload;
          if (payload.isNotEmpty) {
            int langCodeLength = payload[0] & 0x3F;
            if (payload.length > langCodeLength + 1) {
              location = String.fromCharCodes(
                  payload.sublist(langCodeLength + 1));
            }
          }
        } else {
          location = String.fromCharCodes(record.payload);
        }

        if (location.isNotEmpty) break;
      } catch (e) {
        try {
          location = String.fromCharCodes(record.payload);
        } catch (parseError) {
          continue;
        }
      }
    }

    return location;
  }

  /// Properly stop NFC session - THIS PREVENTS SYSTEM DIALOGS
  Future<void> _stopNFCSession() async {
    // try {
    //   await NfcManager.instance.stopSession(
    //     errorMessageIos: '',
    //     errorMessageAndroid: '',
    //   );
    //   _currentSession = null;
    // } catch (e) {
    //   debugPrint('Error stopping NFC session: $e');
    // }
  }

  void _resetForNextScan() {
    setState(() {
      _isScanning = false;
    });
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: CustomText(
          text: message,
          color: white,
          size: SizeConfig.subText,
        ),
        backgroundColor: isError ? statusError : statusActive,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showTourDetails(Map<String, dynamic> tour) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildDetailsBottomSheet(tour),
    );
  }

  Widget _buildDetailsBottomSheet(Map<String, dynamic> tour) {
    return Container(
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      padding: EdgeInsets.all(SizeConfig.commonMargin! * 2),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: 'Scan Details',
                  size: SizeConfig.medtitleText,
                  weight: FontWeight.w700,
                  color: TextColourBlk,
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.close, color: TextColourAsh),
                ),
              ],
            ),
            Gap(SizeConfig.commonMargin! * 1.5),

            // Location Card
            Container(
              decoration: BoxDecoration(
                color: guardTouringLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: guardTouringPrimary.withOpacity(0.2),
                  width: 1,
                ),
              ),
              padding: EdgeInsets.all(SizeConfig.commonMargin! * 1.5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: tour['location'],
                    size: SizeConfig.medtitleText,
                    weight: FontWeight.w700,
                    color: guardTouringPrimary,
                  ),
                  Gap(SizeConfig.commonMargin! * 0.5),
                  Row(
                    children: [
                      Icon(Icons.location_on,
                          size: SizeConfig.tinyText, color: guardTouringPrimary),
                      Gap(SizeConfig.commonMargin! * 0.5),
                      CustomText(
                        text: 'Checkpoint: ${tour['checkpoint']}',
                        size: SizeConfig.smallSubText,
                        weight: FontWeight.w500,
                        color: TextColourAsh,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Gap(SizeConfig.commonMargin! * 2),

            // Guard Name
            _buildDetailRow(
              icon: Icons.person,
              label: 'Guard Name',
              value: tour['guardName'],
              valueColor: TextColourBlk,
            ),
            Gap(SizeConfig.commonMargin! * 1.5),

            // Scan Time
            _buildDetailRow(
              icon: Icons.access_time,
              label: 'Scan Time',
              value: DateFormat('dd/MM/yyyy HH:mm:ss').format(tour['timestamp']),
              valueColor: TextColourBlk,
            ),
            Gap(SizeConfig.commonMargin! * 1.5),

            // Status
            _buildDetailRow(
              icon: Icons.check_circle,
              label: 'Status',
              value: tour['status'],
              valueColor: statusActive,
            ),
            Gap(SizeConfig.commonMargin! * 1.5),

            // Remarks
            CustomText(
              text: 'Remarks',
              size: SizeConfig.smallTitleText,
              weight: FontWeight.w600,
              color: TextColourBlk,
            ),
            Gap(SizeConfig.commonMargin! * 0.8),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: GreyColourAsh,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.all(SizeConfig.commonMargin! * 1),
              child: CustomText(
                text: tour['remarks'] ?? 'No remarks',
                size: SizeConfig.smallSubText,
                weight: FontWeight.w400,
                color: TextColourAsh,
              ),
            ),
            Gap(SizeConfig.commonMargin! * 2),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    required Color valueColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: SizeConfig.medtitleText, color: guardTouringPrimary),
        Gap(SizeConfig.commonMargin! * 1),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: label,
                size: SizeConfig.tinyText,
                weight: FontWeight.w500,
                color: TextColourAsh,
              ),
              Gap(SizeConfig.commonMargin! * 0.5),
              CustomText(
                text: value,
                size: SizeConfig.subText,
                weight: FontWeight.w600,
                color: valueColor,
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _stopNFCSession();
    _fadeController.dispose();
    _slideController.dispose();
    _pulseController.dispose();
    _scanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Background,
      appBar: _buildAppBar(),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: _buildBody(),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: guardTouringPrimary,
      leading: IconButton(
        onPressed: () {
          _stopNFCSession();
          context.go('/home');
        },
        icon: Icon(Icons.arrow_back, color: white),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomText(
            text: 'Guard Touring',
            size: SizeConfig.medtitleText,
            weight: FontWeight.w700,
            color: white,
            letterSpacing: 0.5,
          ),
          CustomText(
            text: 'NFC Security Checkpoints',
            size: SizeConfig.tinyText,
            weight: FontWeight.w400,
            color: white.withOpacity(0.8),
            letterSpacing: 0.2,
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {
            setState(() {
              scannedTours.clear();
            });
            _showSnackBar('All scans cleared');
          },
          icon: Icon(Icons.delete_outline, color: white),
          tooltip: 'Clear All',
        ),
      ],
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(SizeConfig.commonMargin! * 1.5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(SizeConfig.commonMargin! * 3.5),
            _buildGuardInfoCard(),
            Gap(SizeConfig.commonMargin! * 2),

            // NFC Scanning Section
            if (scannedTours.isEmpty)
              _buildNFCScanningSection()
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Statistics
                  _buildStatisticsCard(),
                  Gap(SizeConfig.commonMargin! * 2),

                  // Scanned Locations Title
                  CustomText(
                    text: 'Scanned Locations',
                    size: SizeConfig.medtitleText,
                    weight: FontWeight.w700,
                    color: TextColourBlk,
                  ),
                  Gap(SizeConfig.commonMargin! * 1.5),

                  // Scanned Tours List
                  _buildScannedToursList(),
                  Gap(SizeConfig.commonMargin! * 2),

                  // Scan Again Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _isScanning ? null : _startNFCScanning,
                      icon: _isScanning
                          ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              white),
                        ),
                      )
                          : Icon(Icons.nfc,color: white,),
                      label: CustomText(
                        text: _isScanning
                            ? 'Scanning Location...'
                            : 'Scan Next Location',
                        size: SizeConfig.subText,
                        weight: FontWeight.w600,
                        color: white,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: guardTouringPrimary,
                        padding: EdgeInsets.symmetric(
                          vertical: SizeConfig.commonMargin! * 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuardInfoCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [guardTouringPrimary, guardTouringPrimary.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: guardTouringPrimary.withOpacity(0.2),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.all(SizeConfig.commonMargin! * 1.5),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: white.withOpacity(0.2),
            ),
            child: Icon(
              Icons.person,
              color: white,
              size: SizeConfig.medtitleText,
            ),
          ),
          Gap(SizeConfig.commonMargin! * 1.5),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: 'Guard',
                  size: SizeConfig.tinyText,
                  weight: FontWeight.w500,
                  color: white.withOpacity(0.8),
                ),
                Gap(SizeConfig.commonMargin! * 0.3),
                CustomText(
                  text: Utilities.userName,
                  size: SizeConfig.subText,
                  weight: FontWeight.w700,
                  color: white,
                ),
              ],
            ),
          ),
          Icon(Icons.verified_user, color: statusActive, size: 24),
        ],
      ),
    );
  }

  Widget _buildNFCScanningSection() {
    return Column(
      children: [
        Gap(SizeConfig.commonMargin! * 3),
        CustomText(
          text: _isNFCAvailable ? 'Ready to Scan' : 'NFC Not Available',
          size: SizeConfig.medtitleText,
          weight: FontWeight.w700,
          color: _isNFCAvailable ? guardTouringPrimary : statusError,
          textAlign: TextAlign.center,
        ),
        Gap(SizeConfig.commonMargin! * 3),

        // NFC Animation Circle
        Center(
          child: ScaleTransition(
            scale: _scanController.isAnimating ? _scanScaleAnimation : AlwaysStoppedAnimation(1.0),
            child: Container(
              width: SizeConfig.screenWidth! * 0.5,
              height: SizeConfig.screenWidth! * 0.5,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _isScanning
                    ? guardTouringPrimary.withOpacity(0.1)
                    : guardTouringPrimary.withOpacity(0.05),
                border: Border.all(
                  color: guardTouringPrimary.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ScaleTransition(
                    scale: _pulseAnimation,
                    child: Icon(
                      Icons.nfc,
                      size: SizeConfig.maxHeightAndWidth! * 3,
                      color: _isScanning ? guardTouringPrimary : guardTouringPrimary.withOpacity(0.6),
                    ),
                  ),
                  Gap(SizeConfig.commonMargin! * 1.5),
                  if (_isScanning)
                    SizedBox(
                      width: 30,
                      height: 30,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                            guardTouringPrimary),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),

        Gap(SizeConfig.commonMargin! * 3),
        CustomText(
          text: _isScanning
              ? 'Scanning NFC Tag...\nBring your device closer'
              : 'Tap below to scan NFC tag\nat each checkpoint',
          size: SizeConfig.subText,
          weight: FontWeight.w500,
          color: TextColourAsh,
          textAlign: TextAlign.center,
        ),
        Gap(SizeConfig.commonMargin! * 3),

        // Scan Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _isScanning || !_isNFCAvailable ? null : _startNFCScanning,
            icon: Icon(Icons.nfc, color: white),
            label: CustomText(
              text: _isScanning ? 'Scanning...' : 'Start NFC Scan',
              size: SizeConfig.subText,
              weight: FontWeight.w600,
              color: white,
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: guardTouringPrimary,
              disabledBackgroundColor: TextColourAsh,
              padding: EdgeInsets.symmetric(
                vertical: SizeConfig.commonMargin! * 1.5,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),

        Gap(SizeConfig.commonMargin! * 2),
        CustomText(
          text: _isNFCAvailable
              ? 'NFC is available on your device'
              : 'NFC is not available on this device',
          size: SizeConfig.smallSubText,
          weight: FontWeight.w400,
          color: _isNFCAvailable ? statusActive : statusError,
          textAlign: TextAlign.center,
        ),
        Gap(SizeConfig.commonMargin! * 5),
      ],
    );
  }

  Widget _buildStatisticsCard() {
    return Container(
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: guardTouringPrimary.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: guardTouringPrimary.withOpacity(0.08),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.all(SizeConfig.commonMargin! * 1.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: 'Locations Scanned',
                size: SizeConfig.smallSubText,
                weight: FontWeight.w500,
                color: TextColourAsh,
              ),
              Gap(SizeConfig.commonMargin! * 0.5),
              CustomText(
                text: '${scannedTours.length}',
                size: SizeConfig.medbigText,
                weight: FontWeight.w700,
                color: guardTouringPrimary,
              ),
            ],
          ),
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: guardTouringPrimary.withOpacity(0.1),
            ),
            child: Icon(
              Icons.location_on,
              color: guardTouringPrimary,
              size: SizeConfig.medtitleText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScannedToursList() {
    return Column(
      children: List.generate(
        scannedTours.length,
            (index) {
          final tour = scannedTours[index];
          return GestureDetector(
            onTap: () => _showTourDetails(tour),
            child: Container(
              margin: EdgeInsets.only(bottom: SizeConfig.commonMargin! * 1.5),
              decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: guardTouringPrimary.withOpacity(0.15),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              padding: EdgeInsets.all(SizeConfig.commonMargin! * 1.5),
              child: Column(
                children: [
                  // Header Row
                  Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: statusActive.withOpacity(0.1),
                        ),
                        child: Icon(
                          Icons.check_circle,
                          color: statusActive,
                          size: SizeConfig.medtitleText,
                        ),
                      ),
                      Gap(SizeConfig.commonMargin! * 1),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: tour['location'],
                              size: SizeConfig.subText,
                              weight: FontWeight.w700,
                              color: TextColourBlk,
                            ),
                            Gap(SizeConfig.commonMargin! * 0.3),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  size: 14,
                                  color: TextColourAsh,
                                ),
                                Gap(SizeConfig.commonMargin! * 0.3),
                                CustomText(
                                  text: '${tour['checkpoint']} • Floor: ${tour['floor'] ?? 'N/A'}',
                                  size: SizeConfig.smallSubText,
                                  weight: FontWeight.w400,
                                  color: TextColourAsh,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.commonMargin! * 0.8,
                          vertical: SizeConfig.commonMargin! * 0.4,
                        ),
                        decoration: BoxDecoration(
                          color: statusActive.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: CustomText(
                          text: '${index + 1}',
                          size: SizeConfig.smallSubText,
                          weight: FontWeight.w700,
                          color: statusActive,
                        ),
                      ),
                    ],
                  ),
                  Gap(SizeConfig.commonMargin! * 1),

                  // Divider
                  Container(
                    height: 0.8,
                    color: TextColourAsh.withOpacity(0.1),
                  ),
                  Gap(SizeConfig.commonMargin! * 1),

                  // Footer Row
                  Row(
                    children: [
                      Icon(
                        Icons.person_outline,
                        size: 16,
                        color: guardTouringPrimary,
                      ),
                      Gap(SizeConfig.commonMargin! * 0.5),
                      Expanded(
                        child: CustomText(
                          text: tour['guardName'],
                          size: SizeConfig.smallSubText,
                          weight: FontWeight.w500,
                          color: TextColourAsh,
                        ),
                      ),
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: guardTouringPrimary,
                      ),
                      Gap(SizeConfig.commonMargin! * 0.5),
                      CustomText(
                        text: DateFormat('HH:mm:ss').format(tour['timestamp']),
                        size: SizeConfig.smallSubText,
                        weight: FontWeight.w500,
                        color: TextColourAsh,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}