import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager_ndef/nfc_manager_ndef.dart';
import 'package:nfc_manager/ndef_record.dart';
import '../helper/Colors.dart';
import '../helper/CustomText.dart';
import '../helper/size_config.dart';


class CommonNFCAuth extends StatefulWidget {
  final String topic;
  final String userName;
  final String building;
  final String authorizedId;
  final void Function(String scannedId) onAuthSuccess;

  const CommonNFCAuth({
    Key? key,
    required this.topic,
    required this.userName,
    required this.building,
    required this.authorizedId,
    required this.onAuthSuccess,
  }) : super(key: key);

  @override
  State<CommonNFCAuth> createState() => _CommonNFCAuthState();
}


enum _ScanStatus { idle, scanning, success, failed, nfcUnavailable }


class _CommonNFCAuthState extends State<CommonNFCAuth>
    with TickerProviderStateMixin {
  _ScanStatus _status = _ScanStatus.idle;
  bool _isNFCAvailable = false;
  bool _isProcessing = false;
  String _statusMessage = 'Hold your NFC card near the device';



  late AnimationController _pulseController;
  late AnimationController _rippleController;
  late AnimationController _resultController;

  late Animation<double> _pulseAnimation;
  late Animation<double> _ripple1Animation;
  late Animation<double> _ripple2Animation;
  late Animation<double> _ripple3Animation;
  late Animation<double> _resultScaleAnimation;
  late Animation<double> _resultFadeAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    // _checkAndStartNFC();
    _checkNFCAvailability();
  }

  void _initAnimations() {
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.92, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _rippleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
    _ripple1Animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _rippleController,
          curve: const Interval(0.0, 0.8, curve: Curves.easeOut)),
    );
    _ripple2Animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _rippleController,
          curve: const Interval(0.25, 1.0, curve: Curves.easeOut)),
    );
    _ripple3Animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _rippleController,
          curve: const Interval(0.5, 1.0, curve: Curves.easeOut)),
    );

    // Result icon pop-in
    _resultController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _resultScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _resultController, curve: Curves.elasticOut),
    );
    _resultFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _resultController, curve: Curves.easeIn),
    );
  }

  Future<void> _checkAndStartNFC() async {
    // Wait for the route transition to fully complete before starting NFC.
    // Without this, Android's system NFC dispatch fires during the transition
    // and shows the "New tag collected" popup.
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    try {
      final available = await NfcManager.instance.isAvailable();
      if (!mounted) return;
      setState(() => _isNFCAvailable = available);

      if (!available) {
        setState(() {
          _status = _ScanStatus.nfcUnavailable;
          _statusMessage = 'NFC is not available on this device';
        });
        _stopRipple();
        return;
      }

      _startNFCSession();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _status = _ScanStatus.nfcUnavailable;
        _statusMessage = 'Could not initialise NFC';
      });
    }
  }

  void _startNFCSession() {
    _isProcessing = false;

    NfcManager.instance.startSession(
      pollingOptions: {
        NfcPollingOption.iso14443,
        NfcPollingOption.iso15693,
        NfcPollingOption.iso18092,
      },
      noPlatformSoundsAndroid: true,
      onDiscovered: (NfcTag tag) async {
        if (!mounted || _isProcessing) return;
        _isProcessing = true;

        try {
          final ndef = Ndef.from(tag);
          if (ndef == null) {
            _handleResult(false, 'Tag format not supported');
            await _stopNFCSession();
            return;
          }

          final message = await ndef.read();
          if (message == null || message.records.isEmpty) {
            _handleResult(false, 'No data found on tag');
            await _stopNFCSession();
            return;
          }

          final scannedId = _parseNdefMessage(message).trim();
          await _stopNFCSession();

          if (scannedId == widget.authorizedId.trim()) {
            _handleResult(true, 'Access Granted');
            await Future.delayed(const Duration(milliseconds: 1200));
            if (mounted) widget.onAuthSuccess(scannedId);
          } else {
            _handleResult(false, 'Access Denied – Invalid Card');
          }
        } catch (e) {
          _handleResult(false, 'Error reading tag');
          await _stopNFCSession();
        }
      },
    );
  }

  void _handleResult(bool success, String message) {
    if (!mounted) return;
    _stopRipple();
    setState(() {
      _status = success ? _ScanStatus.success : _ScanStatus.failed;
      _statusMessage = message;
    });
    _resultController.forward(from: 0.0);
  }

  Future<void> _stopNFCSession() async {

  }

  void _stopRipple() {
    _rippleController.stop();
    _pulseController.stop();
  }

  Future<void> _checkNFCAvailability() async {
    try {
      final available = await NfcManager.instance.isAvailable();
      if (!mounted) return;
      setState(() => _isNFCAvailable = available);
      if (!available) {
        setState(() {
          _status = _ScanStatus.nfcUnavailable;
          _statusMessage = 'NFC is not available on this device';
        });
        _stopRipple();
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _status = _ScanStatus.nfcUnavailable;
        _statusMessage = 'Could not initialise NFC';
      });
    }
  }


  void _cancelScan() async {
    await _stopNFCSession();
    if (mounted) Navigator.of(context).pop();
  }

  void _retryNFCScan() {
    _rippleController.repeat();
    _pulseController.repeat(reverse: true);
    setState(() {
      _status = _ScanStatus.scanning;
      _statusMessage = 'Hold your NFC card near the device';
    });
    _startNFCSession();
  }

  String _parseNdefMessage(NdefMessage message) {
    for (var record in message.records) {
      try {
        if (record.typeNameFormat == TypeNameFormat.wellKnown) {
          final payload = record.payload;
          if (payload.isNotEmpty) {
            int langLen = payload[0] & 0x3F;
            if (payload.length > langLen + 1) {
              final text = String.fromCharCodes(payload.sublist(langLen + 1));
              if (text.isNotEmpty) return text;
            }
          }
        } else {
          final text = String.fromCharCodes(record.payload);
          if (text.isNotEmpty) return text;
        }
      } catch (_) {}
    }
    return '';
  }

  @override
  void dispose() {
    _stopNFCSession();
    _pulseController.dispose();
    _rippleController.dispose();
    _resultController.dispose();
    super.dispose();
  }

  // ── UI ─────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBackground,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: _buildBody()),
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: pro_primaryColor,
      elevation: 0,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: 'NFC Authentication',
            size: SizeConfig.subText,
            weight: FontWeight.w700,
            color: white,
          ),
          CustomText(
            text: widget.topic,
            size: SizeConfig.smallSubText,
            weight: FontWeight.w400,
            color: white,
          ),
        ],
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: borderColor),
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.commonMargin! * 2),
      child: Column(
        children: [
          Gap(SizeConfig.commonMargin! * 2),
          _buildInfoBanner(),
          Gap(SizeConfig.commonMargin! * 2),
          _buildNFCScanArea(),
          Gap(SizeConfig.commonMargin! * 2),
          _buildStatusCard(),
          Gap(SizeConfig.commonMargin! * 2),
        ],
      ),
    );
  }

  Widget _buildInfoBanner() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.commonMargin! * 1.5,
        vertical: SizeConfig.commonMargin! * 1.2,
      ),
      decoration: BoxDecoration(
        color: pro_primaryColor.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: pro_primaryColor.withOpacity(0.15)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: pro_primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.lock_outline_rounded,
                color: pro_primaryColor, size: 20),
          ),
          Gap(SizeConfig.commonMargin! * 1.2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: 'Access Required',
                  size: SizeConfig.smallSubText,
                  weight: FontWeight.w700,
                  color: pro_primaryColor,
                ),
                Gap(2),
                CustomText(
                  text: 'Scan your authorised NFC card to access ${widget.topic}',
                  size: SizeConfig.tinyText,
                  weight: FontWeight.w400,
                  color: TextColourAsh,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNFCScanArea() {
    return SizedBox(
      height: 260,
      child: Center(
        child: _status == _ScanStatus.idle
            ? _buildScanButton()
            : _status == _ScanStatus.scanning
            ? _buildRippleScanner()
            : _buildResultIcon(),
      ),
    );
  }

  Widget _buildScanButton() {
    return GestureDetector(
      onTap: () {
        if (!_isNFCAvailable) return;
        setState(() {
          _status = _ScanStatus.scanning;
          _statusMessage = 'Hold your NFC card near the device';
        });
        _rippleController.repeat();
        _pulseController.repeat(reverse: true);
        _startNFCSession(); // ← exact same as GuardTouringM button tap
      },
      child: Container(
        width: 130,
        height: 130,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: pro_primaryColor.withOpacity(0.08),
          border: Border.all(color: pro_primaryColor.withOpacity(0.3), width: 2),
          boxShadow: [
            BoxShadow(
              color: pro_primaryColor.withOpacity(0.15),
              blurRadius: 20,
              spreadRadius: 4,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.nfc_rounded, color: pro_primaryColor, size: 52),
            Gap(6),
            CustomText(
              text: 'Tap to Scan',
              size: SizeConfig.tinyText,
              weight: FontWeight.w600,
              color: pro_primaryColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRippleScanner() {
    final Color ringColor = pro_primaryColor;
    return AnimatedBuilder(
      animation: _rippleController,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Ring 3 (outermost)
            _buildRippleRing(_ripple3Animation.value, 130, ringColor, 0.04),
            // Ring 2
            _buildRippleRing(_ripple2Animation.value, 110, ringColor, 0.07),
            // Ring 1 (innermost)
            _buildRippleRing(_ripple1Animation.value, 90, ringColor, 0.10),
            // Centre icon
            ScaleTransition(
              scale: _pulseAnimation,
              child: _buildNFCCenterIcon(ringColor),
            ),
          ],
        );
      },
    );
  }

  Widget _buildRippleRing(
      double progress, double maxRadius, Color color, double opacity) {
    return Container(
      width: maxRadius * 2 * progress,
      height: maxRadius * 2 * progress,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: color.withOpacity(opacity * (1 - progress * 0.8)),
          width: 1.5,
        ),
      ),
    );
  }

  Widget _buildNFCCenterIcon(Color color) {
    return Container(
      width: 110,
      height: 110,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 24,
            spreadRadius: 4,
          ),
        ],
        border: Border.all(color: color.withOpacity(0.2), width: 1.5),
      ),
      child: Icon(Icons.nfc_rounded, color: color, size: 52),
    );
  }

  Widget _buildResultIcon() {
    final bool isSuccess = _status == _ScanStatus.success;
    final bool isUnavailable = _status == _ScanStatus.nfcUnavailable;

    final Color iconColor = isSuccess
        ? statusActive
        : isUnavailable
        ? statusWarning
        : statusError;
    final IconData iconData = isSuccess
        ? Icons.check_circle_rounded
        : isUnavailable
        ? Icons.nfc_rounded
        : Icons.cancel_rounded;

    return ScaleTransition(
      scale: _resultScaleAnimation,
      child: FadeTransition(
        opacity: _resultFadeAnimation,
        child: Container(
          width: 130,
          height: 130,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: iconColor.withOpacity(0.08),
            border: Border.all(color: iconColor.withOpacity(0.2), width: 2),
          ),
          child: Icon(iconData, color: iconColor, size: 64),
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    final Color statusColor = _status == _ScanStatus.success
        ? statusActive
        : _status == _ScanStatus.failed
        ? statusError
        : _status == _ScanStatus.nfcUnavailable
        ? statusWarning
        : pro_primaryColor;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: EdgeInsets.all(SizeConfig.commonMargin! * 1.5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: statusColor.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: statusColor.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _status == _ScanStatus.scanning
                      ? statusColor
                      : statusColor,
                ),
              ),
              Gap(8),
              CustomText(
                text: _status == _ScanStatus.scanning
                    ? 'Scanning…'
                    : _status == _ScanStatus.success
                    ? 'Access Granted'
                    : _status == _ScanStatus.nfcUnavailable
                    ? 'NFC Unavailable'
                    : 'Access Denied',
                size: SizeConfig.subText,
                weight: FontWeight.w700,
                color: statusColor,
              ),
            ],
          ),
          Gap(SizeConfig.commonMargin! * 0.8),
          CustomText(
            text: _statusMessage,
            size: SizeConfig.smallSubText,
            weight: FontWeight.w400,
            color: TextColourAsh,
            textAlign: TextAlign.center,
          ),
          if (_status == _ScanStatus.failed) ...[
            Gap(SizeConfig.commonMargin! * 1.2),
            GestureDetector(
              onTap: _retryNFCScan,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.commonMargin! * 2,
                  vertical: SizeConfig.commonMargin! * 0.8,
                ),
                decoration: BoxDecoration(
                  color: pro_primaryColor.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color: pro_primaryColor.withOpacity(0.2), width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.refresh_rounded,
                        color: pro_primaryColor, size: 16),
                    Gap(6),
                    CustomText(
                      text: 'Try Again',
                      size: SizeConfig.smallSubText,
                      weight: FontWeight.w600,
                      color: pro_primaryColor,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: EdgeInsets.fromLTRB(
        SizeConfig.commonMargin! * 2,
        SizeConfig.commonMargin! * 1.2,
        SizeConfig.commonMargin! * 2,
        SizeConfig.commonMargin! * 2.5,
      ),
      decoration:  BoxDecoration(
        color: pro_primaryColor,
        border: Border(top: BorderSide(color: borderColor, width: 1)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // User / building context strip
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.commonMargin!,
              vertical: SizeConfig.commonMargin! * 0.7,
            ),
            margin: EdgeInsets.only(bottom: SizeConfig.commonMargin! * 1.2),
            decoration: BoxDecoration(
              color: surfaceDark,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.person_outline_rounded,
                    size: 14, color: pro_primaryColor),
                Gap(6),
                CustomText(
                  text: widget.userName,
                  size: SizeConfig.tinyText,
                  weight: FontWeight.w500,
                  color: TextColourAsh,
                ),
                const Spacer(),
                Icon(Icons.business_outlined, size: 14, color: pro_primaryColor),
                Gap(6),
                CustomText(
                  text: widget.building,
                  size: SizeConfig.tinyText,
                  weight: FontWeight.w500,
                  color: TextColourAsh,
                ),
              ],
            ),
          ),

          // Cancel button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _cancelScan,
              icon: const Icon(Icons.close_rounded, size: 18),
              label: const Text('Cancel Scan'),
              style: OutlinedButton.styleFrom(
                foregroundColor: white,
                side: BorderSide(color: white.withOpacity(0.5), width: 1),
                padding: EdgeInsets.symmetric(
                    vertical: SizeConfig.commonMargin! * 1.4),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                textStyle: TextStyle(
                  fontFamily: 'Lato',
                  fontSize: SizeConfig.subText,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}