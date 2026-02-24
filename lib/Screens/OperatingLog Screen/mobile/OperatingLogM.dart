import 'package:atlanwa_bms/allImports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../model/OperationalLogModel.dart';
import '../bloc/operating_log_bloc.dart';

class OperatingLogM extends StatefulWidget {
  const OperatingLogM({super.key});

  @override
  State<OperatingLogM> createState() => _OperatingLogMState();
}

class _OperatingLogMState extends State<OperatingLogM> {
  late OperatingLogBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<OperatingLogBloc>(context);
    bloc.add(FetchOperatingLogEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OperatingLogBloc, OperatingLogState>(
      listener: (context, state) async {
        final prefs = await SharedPreferences.getInstance();

        Utilities.userName = prefs.getString('userName') ?? '';
        Utilities.buildings = prefs.getStringList('buildings') ?? [];
        // TODO: implement listener
      },
      child: BlocBuilder<OperatingLogBloc, OperatingLogState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: appBackground,
            appBar: AppBar(
              backgroundColor: operatingLogPrimary,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios_new, color: white, size: 20),
                onPressed: () {
                  context.go('/home');
                },
              ),
              title: CustomText(
                text: 'Operating Log',
                color: white,
                size: SizeConfig.titleText,
                weight: FontWeight.w700,
              ),
              actions: [
                GestureDetector(
                  onTap: () {
                    _showAddLogBottomSheet(context);
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
                        Icon(Icons.add, color: operatingLogPrimary, size: 18),
                        SizedBox(width: 5),
                        CustomText(
                          text: "Add Log",
                          color: operatingLogPrimary,
                          size: SizeConfig.medtitleText,
                          weight: FontWeight.w600,
                        ),
                      ],
                    ),
                  ),
                ),
                Gap(10),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Column(children: [Expanded(child: _buildLogsList(state))]),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLogsList(OperatingLogState state) {
    if (state is OperatingLogLoading) {
      return Center(child: CircularProgressIndicator(color: pro_primaryColor));
    } else if (state is OperatingLogLoaded) {
      if (state.logs.isEmpty) {
        return Center(
          child: CustomText(
            text: 'No logs available',
            color: TextColourAsh,
            size: SizeConfig.titleText,
          ),
        );
      }
      return ListView.builder(
        itemCount: state.logs.length,
        itemBuilder: (context, index) {
          return _buildLogCard(state.logs[index]);
        },
      );
    } else if (state is OperatingLogError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: statusError, size: 48),
            SizedBox(height: 10),
            CustomText(
              text: 'Error loading logs',
              color: statusError,
              size: SizeConfig.titleText,
              weight: FontWeight.w600,
            ),
            SizedBox(height: 5),
            CustomText(
              text: state.message,
              color: TextColourAsh,
              size: SizeConfig.subText,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
    return Container();
  }

  Widget _buildLogCard(OperationallogsModel log) {
    Color statusColor = log.status?.toLowerCase() == 'open'
        ? statusActive
        : statusInactive;

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: shadowColor.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header Section
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: operatingLogLight,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: operatingLogPrimary,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: CustomText(
                        text: '#${log.sno ?? 'N/A'}',
                        color: white,
                        size: SizeConfig.smallSubText,
                        weight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(width: 10),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: CustomText(
                        text: log.status?.toUpperCase() ?? 'N/A',
                        color: white,
                        size: SizeConfig.miniText,
                        weight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                // Date & Time
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    CustomText(
                      text: log.date ?? 'N/A',
                      color: TextColourBlk,
                      size: SizeConfig.smallSubText,
                      weight: FontWeight.w600,
                    ),
                    CustomText(
                      text: log.time ?? 'N/A',
                      color: TextColourAsh,
                      size: SizeConfig.miniText,
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Content Section
          Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Building
                Row(
                  children: [
                    Icon(Icons.business, size: 16, color: operatingLogPrimary),
                    SizedBox(width: 6),
                    Expanded(
                      child: CustomText(
                        text: log.building ?? 'N/A',
                        color: TextColourBlk,
                        size: SizeConfig.smallSubText,
                        weight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                // Nature of Call
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.category, size: 16, color: operatingLogPrimary),
                    SizedBox(width: 6),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: 'Nature of Call',
                            color: TextColourAsh,
                            size: SizeConfig.tinyText,
                          ),
                          CustomText(
                            text: log.natureOfCall ?? 'N/A',
                            color: TextColourBlk,
                            size: SizeConfig.smallSubText,
                            weight: FontWeight.w500,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                // Work Description
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.description,
                      size: 16,
                      color: operatingLogPrimary,
                    ),
                    SizedBox(width: 6),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: 'Work Description',
                            color: TextColourAsh,
                            size: SizeConfig.tinyText,
                          ),
                          CustomText(
                            text: log.workDescription ?? 'N/A',
                            color: TextColourBlk,
                            size: SizeConfig.smallSubText,
                            maxLines: 3,
                            textOverflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                // Username
                Row(
                  children: [
                    Icon(Icons.person, size: 16, color: operatingLogPrimary),
                    SizedBox(width: 6),
                    CustomText(
                      text: 'By: ',
                      color: TextColourAsh,
                      size: SizeConfig.tinyText,
                    ),
                    Expanded(
                      child: CustomText(
                        text: log.username ?? 'N/A',
                        color: TextColourBlk,
                        size: SizeConfig.smallSubText,
                        weight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Divider(color: dividerColor, height: 1),
                SizedBox(height: 8),
                // Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Edit log
                        _showAddLogBottomSheet(context, log: log);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: pro_primaryColorTooLit,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: pro_primaryColor),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 14, color: pro_primaryColor),
                            SizedBox(width: 4),
                            CustomText(
                              text: 'Edit',
                              color: pro_primaryColor,
                              size: SizeConfig.tinyText,
                              weight: FontWeight.w600,
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // View details
                        DeleteLogDetails(log);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red.shade100,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.red.shade400),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.delete,
                              size: 14,
                              color: Colors.red.shade400,
                            ),
                            SizedBox(width: 4),
                            CustomText(
                              text: 'Delete',
                              color: Colors.red.shade400,
                              size: SizeConfig.tinyText,
                              weight: FontWeight.w600,
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // View details
                        _showLogDetails(log);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: operatingLogLight,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: operatingLogPrimary),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.visibility,
                              size: 14,
                              color: operatingLogPrimary,
                            ),
                            SizedBox(width: 4),
                            CustomText(
                              text: 'View',
                              color: operatingLogPrimary,
                              size: SizeConfig.tinyText,
                              weight: FontWeight.w600,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showLogDetails(OperationallogsModel log) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: CustomText(
          text: 'Log Details - #${log.sno}',
          size: SizeConfig.titleText,
          weight: FontWeight.w700,
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _detailRow('Building', log.building ?? 'N/A'),
              _detailRow('Date', log.date ?? 'N/A'),
              _detailRow('Time', log.time ?? 'N/A'),
              _detailRow('Nature of Call', log.natureOfCall ?? 'N/A'),
              _detailRow('Work Description', log.workDescription ?? 'N/A'),
              _detailRow('Status', log.status ?? 'N/A'),
              _detailRow('Username', log.username ?? 'N/A'),
              if (log.lastUpdatedBy != null)
                _detailRow('Last Updated By', log.lastUpdatedBy!),
              if (log.lastUpdatedAt != null)
                _detailRow('Last Updated At', log.lastUpdatedAt!),
            ],
          ),
        ),
      ),
    );
  }

  void DeleteLogDetails(OperationallogsModel log) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: CustomText(
          text: 'Delete Log Details - #${log.sno}',
          size: SizeConfig.titleText,
          weight: FontWeight.w700,
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _detailRow('Building', log.building ?? 'N/A'),
              _detailRow('Date', log.date ?? 'N/A'),
              _detailRow('Time', log.time ?? 'N/A'),
              _detailRow('Nature of Call', log.natureOfCall ?? 'N/A'),
              _detailRow('Work Description', log.workDescription ?? 'N/A'),
              _detailRow('Status', log.status ?? 'N/A'),
              _detailRow('Username', log.username ?? 'N/A'),
              if (log.lastUpdatedBy != null)
                _detailRow('Last Updated By', log.lastUpdatedBy!),
              if (log.lastUpdatedAt != null)
                _detailRow('Last Updated At', log.lastUpdatedAt!),
              Center(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: Colors.red.shade400,
                    border: Border.all(color: Colors.red),
                  ),
                  child: CustomText(
                    text: "Delete",
                    color: white,
                    size: SizeConfig.subText,
                    weight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: label,
            color: pro_primaryColor,
            size: SizeConfig.tinyText,
            weight: FontWeight.bold,
          ),
          SizedBox(height: 2),
          CustomText(
            text: value,
            color: TextColourAsh,
            size: SizeConfig.smalltinyText,
            weight: FontWeight.bold,
          ),
        ],
      ),
    );
  }

  void _showAddLogBottomSheet(
    BuildContext context, {
    OperationallogsModel? log,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => BlocProvider.value(
        value: bloc,
        child: _LogFormSheet(bloc: bloc, log: log),
      ),
    );
  }
}

class _LogFormSheet extends StatefulWidget {
  final OperatingLogBloc bloc;
  final OperationallogsModel? log;

  const _LogFormSheet({required this.bloc, this.log});

  @override
  State<_LogFormSheet> createState() => _LogFormSheetState();
}

class _LogFormSheetState extends State<_LogFormSheet> {
  late bool isEditMode;
  late bool isBuildingLocked;
  late TextEditingController buildingController;
  late TextEditingController natureOfCallController;
  String? selectedBuilding;
  String? selectedNatureOfCall;
  String selectedStatus = 'open';

  final List<String> natureOfCallOptions = [
    'Client call - oral',
    'Client call - mail/portal',
    'Non routine activity',
    'Routine activity',
    'AMC call',
  ];

  @override
  void initState() {
    super.initState();
    isEditMode = widget.log != null;

    buildingController = TextEditingController(
      text: widget.log?.building ?? '',
    );
    natureOfCallController = TextEditingController(
      text: widget.log?.natureOfCall ?? '',
    );

    if (isEditMode) {
      isBuildingLocked = true;
      selectedBuilding = widget.log!.building;
      selectedNatureOfCall = widget.log!.natureOfCall;
      selectedStatus = widget.log!.status ?? 'open';
      widget.bloc.workDescriptionController.text =
          widget.log!.workDescription ?? '';
    } else {
      // Check if selectedBuilding matches one in buildings list
      final match = Utilities.buildings.contains(Utilities.selectedBuilding);
      if (match && Utilities.selectedBuilding.isNotEmpty) {
        isBuildingLocked = true;
        selectedBuilding = Utilities.selectedBuilding;
        buildingController.text = Utilities.selectedBuilding;
      } else {
        isBuildingLocked = false;
        selectedBuilding = null;
      }
      selectedNatureOfCall = null;
      selectedStatus = 'open';
      widget.bloc.workDescriptionController.text = '';
    }
  }

  @override
  void dispose() {
    buildingController.dispose();
    natureOfCallController.dispose();
    super.dispose();
  }

  InputDecoration _fieldDecoration(
    String hint, {
    IconData? prefixIcon,
    bool enabled = true,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: Colors.grey.shade400,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      prefixIcon: prefixIcon != null
          ? Icon(
              prefixIcon,
              color: enabled ? operatingLogPrimary : Colors.grey.shade400,
              size: 20,
            )
          : null,
      filled: true,
      fillColor: enabled ? Colors.white : Colors.grey.shade100,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: operatingLogPrimary, width: 1.5),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
    );
  }

  Widget _sectionLabel(String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: operatingLogPrimary),
          const SizedBox(width: 6),
          CustomText(
            text: text,
            size: SizeConfig.smallSubText,
            weight: FontWeight.w600,
            color: TextColourBlk,
          ),
        ],
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'open':
        return statusActive;
      case 'closed':
        return statusError;
      case 'in-progress':
        return statusWarning;
      default:
        return statusInactive;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OperatingLogBloc, OperatingLogState>(
      listener: (context, state) {
        if (state is OpSubmitSuccessState) {
          Navigator.pop(context);
          widget.bloc.add(FetchOperatingLogEvent());
        } else if (state is OpSubmitFailedState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                isEditMode ? 'Failed to update log' : 'Failed to create log',
              ),
              backgroundColor: statusError,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Drag handle
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 12),
                  height: 4,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              /// Header with accent bar
              Container(
                margin: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: operatingLogLight,
                  border: Border(
                    bottom: BorderSide(
                      color: operatingLogPrimary.withOpacity(0.15),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: operatingLogPrimary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        isEditMode
                            ? Icons.edit_note_rounded
                            : Icons.add_task_rounded,
                        color: white,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: isEditMode ? "Edit Log" : "New Log Entry",
                            size: SizeConfig.titleText,
                            weight: FontWeight.w700,
                            color: operatingLogPrimary,
                          ),
                          const SizedBox(height: 2),
                          CustomText(
                            text: isEditMode
                                ? "Update work description or status"
                                : "Fill in the details to create a log",
                            size: SizeConfig.miniText,
                            color: TextColourAsh,
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.close,
                          size: 18,
                          color: TextColourAsh,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              /// Form body
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Building
                    _sectionLabel("Building", Icons.business_rounded),
                    isBuildingLocked
                        ? Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              color: operatingLogLight,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: operatingLogPrimary.withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: CustomText(
                                    text: (selectedBuilding ?? '')
                                        .toUpperCase(),
                                    size: SizeConfig.subText,
                                    weight: FontWeight.w600,
                                    color: TextColourBlk,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: operatingLogPrimary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.lock,
                                        size: 12,
                                        color: operatingLogPrimary,
                                      ),
                                      const SizedBox(width: 3),
                                      CustomText(
                                        text: "Locked",
                                        size: SizeConfig.miniText,
                                        weight: FontWeight.w500,
                                        color: operatingLogPrimary,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : DropdownButtonFormField<String>(
                            value: selectedBuilding,
                            decoration: _fieldDecoration(
                              "Select building",
                              prefixIcon: Icons.business_rounded,
                            ),
                            icon: Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: operatingLogPrimary,
                            ),
                            dropdownColor: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            items: Utilities.buildings
                                .map(
                                  (b) => DropdownMenuItem(
                                    value: b,
                                    child: CustomText(
                                      text: b.toUpperCase(),
                                      size: SizeConfig.subText,
                                      weight: FontWeight.w500,
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (v) {
                              setState(() {
                                selectedBuilding = v;
                              });
                            },
                          ),

                    const SizedBox(height: 20),

                    /// Nature of Call
                    _sectionLabel("Nature of Call", Icons.category_rounded),
                    isEditMode
                        ? Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              color: operatingLogLight,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: operatingLogPrimary.withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: CustomText(
                                    text: widget.log?.natureOfCall ?? 'N/A',
                                    size: SizeConfig.subText,
                                    weight: FontWeight.w500,
                                    color: TextColourBlk,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: operatingLogPrimary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.lock,
                                        size: 12,
                                        color: operatingLogPrimary,
                                      ),
                                      const SizedBox(width: 3),
                                      CustomText(
                                        text: "Locked",
                                        size: SizeConfig.miniText,
                                        weight: FontWeight.w500,
                                        color: operatingLogPrimary,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : DropdownButtonFormField<String>(
                            value: selectedNatureOfCall,
                            decoration: _fieldDecoration(
                              "Select nature of call",
                            ),
                            icon: Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: operatingLogPrimary,
                            ),
                            dropdownColor: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            items: natureOfCallOptions
                                .map(
                                  (n) => DropdownMenuItem(
                                    value: n,
                                    child: CustomText(
                                      text: n,
                                      size: SizeConfig.subText,
                                      weight: FontWeight.w500,
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (v) {
                              setState(() {
                                selectedNatureOfCall = v;
                              });
                            },
                          ),

                    const SizedBox(height: 20),

                    /// Work Description
                    _sectionLabel(
                      "Work Description",
                      Icons.description_rounded,
                    ),
                    TextField(
                      controller: widget.bloc.workDescriptionController,
                      maxLines: 4,
                      style: TextStyle(fontSize: 14, color: TextColourBlk),
                      decoration: _fieldDecoration(
                        "Describe the work performed...",
                        prefixIcon: null,
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// Status
                    _sectionLabel("Status", Icons.flag_rounded),
                    isEditMode
                        ? DropdownButtonFormField<String>(
                            value: selectedStatus,
                            decoration: _fieldDecoration(
                              "Select status",
                            ),
                            dropdownColor: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            items: ['open', 'closed', 'in-progress']
                                .map(
                                  (s) => DropdownMenuItem(
                                    value: s,
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 8,
                                          height: 8,
                                          decoration: BoxDecoration(
                                            color: _statusColor(s),
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        CustomText(
                                          text: s.toUpperCase(),
                                          size: SizeConfig.subText,
                                          weight: FontWeight.w600,
                                          color: _statusColor(s),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (v) {
                              setState(() {
                                selectedStatus = v ?? 'open';
                              });
                            },
                          )
                        : Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              color: statusActive.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: statusActive.withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: statusActive,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: CustomText(
                                    text: "OPEN",
                                    size: SizeConfig.subText,
                                    weight: FontWeight.w600,
                                    color: statusActive,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: statusActive.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: CustomText(
                                    text: "Default",
                                    size: SizeConfig.miniText,
                                    weight: FontWeight.w500,
                                    color: statusActive,
                                  ),
                                ),
                              ],
                            ),
                          ),

                    const SizedBox(height: 28),

                    /// Buttons
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade300),
                                color: Colors.grey.shade50,
                              ),
                              child: Center(
                                child: CustomText(
                                  text: "Cancel",
                                  size: SizeConfig.subText,
                                  weight: FontWeight.w600,
                                  color: TextColourAsh,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          flex: 2,
                          child: GestureDetector(
                            onTap: () {
                              if (isEditMode) {
                                widget.bloc.add(
                                  EditOpLogEvent(
                                    logId: widget.log!.id!,
                                    building: widget.log!.building ?? '',
                                    natureOfCall:
                                        widget.log!.natureOfCall ?? '',
                                    workDescription: widget
                                        .bloc
                                        .workDescriptionController
                                        .text,
                                    status: selectedStatus,
                                  ),
                                );
                              } else {
                                widget.bloc.add(
                                  CreateOpLogEvent(
                                    natureOfCall: selectedNatureOfCall ?? '',
                                  ),
                                );
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                gradient: LinearGradient(
                                  colors: [
                                    operatingLogPrimary,
                                    const Color(0xFF2A9D5C),
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: operatingLogPrimary.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    isEditMode
                                        ? Icons.save_rounded
                                        : Icons.add_circle_outline_rounded,
                                    color: white,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  CustomText(
                                    text: isEditMode
                                        ? "Update Log"
                                        : "Create Log",
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
