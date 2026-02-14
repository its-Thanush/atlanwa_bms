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
  TextEditingController workDescriptionController = TextEditingController();

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
                onTap: (){
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
            child: Column(
              children: [
                Expanded(
                  child: _buildLogsList(state),
                ),
              ],
            ),
          ),
        );
      },
    ),
);
  }

  Widget _buildLogsList(OperatingLogState state) {
    if (state is OperatingLogLoading) {
      return Center(
        child: CircularProgressIndicator(color: pro_primaryColor),
      );
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
    Color statusColor = log.status?.toLowerCase() == 'open' ? statusActive : statusInactive;

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
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                    Icon(Icons.description, size: 16, color: operatingLogPrimary),
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
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // View details
                        _showLogDetails(log);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: operatingLogLight,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: operatingLogPrimary),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.visibility, size: 14, color: operatingLogPrimary),
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

  void _showAddLogBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildLogForm(context),
    );
  }

  Widget _buildLogForm(BuildContext context, {OperationallogsModel? log}) {
    final TextEditingController buildingController =
    TextEditingController(text: log?.building ?? '');

    final TextEditingController natureOfCallController =
    TextEditingController(text: log?.natureOfCall ?? '');


    final TextEditingController statusController =
    TextEditingController(text: log?.status ?? 'open');

    InputDecoration fieldDecoration(String hint) {
      return InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
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
          borderSide: BorderSide(color: pro_primaryColor, width: 1.2),
        ),
      );
    }

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Drag handle
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
              const SizedBox(height: 18),

              /// Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: "Create Log",
                    size: SizeConfig.titleText,
                    weight: FontWeight.w700,
                    color: pro_primaryColor,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              ),

              const SizedBox(height: 20),

              /// Building
              CustomText(
                text: "Building",
                size: SizeConfig.smallSubText,
                weight: FontWeight.w600,
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                value:
                buildingController.text.isEmpty ? null : buildingController.text,
                decoration: fieldDecoration("Select building"),
                items: Utilities.buildings
                    .map((b) => DropdownMenuItem(value: b, child: CustomText(text: b.toUpperCase(), size: SizeConfig.subText,weight: FontWeight.bold,),))
                    .toList(),
                onChanged: (v) => buildingController.text = v ?? '',
              ),

              const SizedBox(height: 18),

              /// Nature of Call
              CustomText(
                text: "Nature of Call",
                size: SizeConfig.smallSubText,
                weight: FontWeight.w600,
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                value: natureOfCallController.text.isEmpty
                    ? null
                    : natureOfCallController.text,
                decoration: fieldDecoration("Select nature of call"),
                items: [
                  'Client call - oral',
                  'Client call - mail/portal',
                  'Non routine activity',
                  'Routine activity',
                  'AMC call'
                ]
                    .map((n) => DropdownMenuItem(value: n, child: CustomText(text: n, size: SizeConfig.subText,weight: FontWeight.bold,),))
                    .toList(),
                onChanged: (v) => natureOfCallController.text = v ?? '',
              ),

              const SizedBox(height: 18),

              /// Work Description
              CustomText(
                text: "Work Description",
                size: SizeConfig.smallSubText,
                weight: FontWeight.w600,
              ),
              const SizedBox(height: 6),
              TextField(
                controller: workDescriptionController,
                maxLines: 4,
                decoration: fieldDecoration("Enter description"),
              ),

              const SizedBox(height: 18),

              /// Status
              CustomText(
                text: "Status",
                size: SizeConfig.smallSubText,
                weight: FontWeight.w600,
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                value: statusController.text,
                decoration: fieldDecoration("Select status"),
                items: ['open', 'closed', 'in-progress']
                    .map((s) => DropdownMenuItem(
                  value: s,
                  child: CustomText(text: s.toUpperCase(), size: SizeConfig.subText,weight: FontWeight.bold,),
                ))
                    .toList(),
                onChanged: (v) => statusController.text = v ?? 'open',
              ),

              const SizedBox(height: 26),

              /// Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(

                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child:  CustomText(text: "Cancel",color: SecondaryColor,),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: SecondaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {},
                      child: CustomText(text: "Create Log",color: white,),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

}