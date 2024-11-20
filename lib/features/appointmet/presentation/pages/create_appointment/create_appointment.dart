import 'dart:convert'; // For encoding data into JSON
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart'; // For formatting dates
import 'package:http/http.dart' as http;
import 'package:xplor/features/wallet/presentation/widgets/date_picker_widget.dart';
import 'package:xplor/utils/app_colors.dart';
import 'package:xplor/utils/app_dimensions.dart';
import 'package:xplor/utils/common_top_header.dart';
import 'package:xplor/utils/extensions/padding.dart';
import 'package:xplor/utils/extensions/string_to_string.dart';
import 'package:xplor/utils/widgets/build_button.dart';
import 'package:xplor/utils/widgets/custom_text_form_fields.dart';

import '../../../../multi_lang/domain/mappers/profile/profile_keys.dart';
import '../../../../on_boarding/domain/entities/user_data_entity.dart';
import '../../../../../utils/widgets/app_background_widget.dart'; // For HTTP requests

/// A screen widget to edit user profile details.
class CreateAppointment extends StatefulWidget {
  /// The user data entity containing profile details.
  final UserDataEntity? userData;

  /// Constructor for SeekerEditProfile.
  const CreateAppointment({super.key, required this.userData});

  @override
  State<CreateAppointment> createState() => _CreateAppointmentState();
}

class _CreateAppointmentState extends State<CreateAppointment> {
  final TextEditingController _abhaIdController = TextEditingController();
  final TextEditingController _patientNameController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _prescriptionController = TextEditingController();
  DateTime? _selectedDate;

  String _appointmentDetails = ''; // To show confirmation after submission

  // Function to pick a date
  Future<void> _pickDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2025),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  // Function to send appointment data to the API
  Future<void> _submitAppointment() async {
    if (_abhaIdController.text.isEmpty ||
        _patientNameController.text.isEmpty ||
        _linkController.text.isEmpty ||
        _mobileController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _prescriptionController.text.isEmpty ||
        _selectedDate == null) {
      print('Please fill in all the details.');
      return;
    }
    print(' all the details.');
    // Prepare the data to send in the request body
    final appointmentData = {
      "abhaId": _abhaIdController.text,
      "patientName": _patientNameController.text,
      "link": _linkController.text,
      "appointmentDate": DateFormat('yyyy-MM-dd').format(_selectedDate!),
      "mobile": _mobileController.text,
      "email": _emailController.text,
      "prescription": _prescriptionController.text,
    };

    try {
      // Send the data as a POST request
      final response = await http.post(
        Uri.parse('https://testfr.dpgongcp.com/registry/api/v1/Appointment'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(appointmentData),
      );
      if (response.statusCode == 200) {

        setState(() {
          _appointmentDetails = 'Appointment successfully booked!';
        });

        // Optionally, reset the form after submission
        _abhaIdController.clear();
        _patientNameController.clear();
        _linkController.clear();
        _mobileController.clear();
        _emailController.clear();
        _prescriptionController.clear();
        setState(() {
          _selectedDate = null;
        });
      } else {
        setState(() {
          _appointmentDetails =
              'Failed to book appointment. Please try again later.';
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        _appointmentDetails = 'Error occurred: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackgroundDecoration(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
                child: Column(
              children: [
                CommonTopHeader(
                  title: ProfileKeys.createAppointment.stringToString,
                  isTitleOnly: false,
                  dividerColor: AppColors.checkBoxDisableColor,
                  onBackButtonPressed: () => Navigator.of(context).pop(),
                ),
                _buildProfileBody(),
                ButtonWidget(
                  onPressed: _submitAppointment,
                  title: ProfileKeys.saveChanges.stringToString,
                  isValid: true,
                ).symmetricPadding(horizontal: AppDimensions.medium),
              ],
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileBody() {
    return Column(children: [
      // Name input field, read-only.
      CustomTextFormField(
        controller: _abhaIdController,
        label: "ABHA ID",
      ),
      CustomTextFormField(
        controller: _patientNameController,
        label: "Name",
      ),
      CustomTextFormField(
        controller: _linkController,
        label: "Link",
      ),
      CustomTextFormField(
        controller: _mobileController,
        label: "Mobile",
      ),
      CustomTextFormField(
        controller: _emailController,
        label: "Email",
      ),
      CustomTextFormField(
        controller: _prescriptionController,
        label: "Prescription",
      ),
      DatePickerWidget(
          onDateTimeChanged: (DateTime date) {
            setState(() {
              _selectedDate = date;
            });
          },
          selectedDate: DateTime.now().add(const Duration(minutes: 5)),
          minimumDate: DateTime.now(),
          mode: CupertinoDatePickerMode.dateAndTime,
          showActionButtons: false,
          onOkPressed: () {

          }),
      AppDimensions.small.verticalSpace, // Add vertical space.
    ]).paddingAll(padding: AppDimensions.medium); // Add padding to the form.
  }

  Widget build1(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointment Booking'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter your details:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // ABHA ID
            TextField(
              controller: _abhaIdController,
              decoration: const InputDecoration(labelText: 'ABHA ID'),
            ),
            const SizedBox(height: 16),
            // Patient Name
            TextField(
              controller: _patientNameController,
              decoration: const InputDecoration(labelText: 'Patient Name'),
            ),
            const SizedBox(height: 16),
            // Link
            TextField(
              controller: _linkController,
              decoration: const InputDecoration(labelText: 'Link'),
            ),
            const SizedBox(height: 16),
            // Mobile
            TextField(
              controller: _mobileController,
              decoration: const InputDecoration(labelText: 'Mobile'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            // Email
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            // Prescription
            TextField(
              controller: _prescriptionController,
              decoration: const InputDecoration(labelText: 'Prescription'),
            ),
            const SizedBox(height: 16),
            // Date Picker
            Row(
              children: [
                Text(
                  _selectedDate == null
                      ? 'Select Appointment Date'
                      : 'Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate!)}',
                  style: const TextStyle(fontSize: 16),
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => _pickDate(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Submit Button
            ElevatedButton(
              onPressed: _submitAppointment,
              child: const Text('Submit Appointment'),
            ),
            const SizedBox(height: 16),
            // Display appointment details or error messages
            if (_appointmentDetails.isNotEmpty) ...[
              const Divider(),
              Text(_appointmentDetails, style: const TextStyle(fontSize: 16)),
            ]
          ],
        ),
      ),
    );
  }
}
