
import 'dart:convert'; // For encoding data into JSON
import 'dart:math';    // For generating random numbers
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting dates
import 'package:http/http.dart' as http;
import 'package:xplor/utils/app_colors.dart';
import 'package:xplor/utils/common_top_header.dart';

import '../../../domain/entities/CreateAppointmentArgs.dart';
import 'package:intl/intl.dart';

class CreateAppointment extends StatefulWidget {
  final CreateAppointmentArgs? createAppointmentArgs;

  const CreateAppointment({super.key, required this.createAppointmentArgs});

  @override
  State<CreateAppointment> createState() => _CreateAppointmentState();
}

class _CreateAppointmentState extends State<CreateAppointment> {
  DateTime selectedDate = DateTime.now();
  String consultationType = '';
  String selectedTimeSlot = '';
  Set<String> disabledSlots = Set<String>(); // To track disabled slots

  List<String> _generateTimeSlots(TimeOfDay startTime, TimeOfDay endTime) {
    List<String> timeSlots = [];
    TimeOfDay currentTime = startTime;

    while (currentTime.hour < endTime.hour ||
        (currentTime.hour == endTime.hour && currentTime.minute < endTime.minute)) {
      timeSlots.add(currentTime.format(context));
      int newMinute = currentTime.minute + 30;
      int newHour = currentTime.hour;

      if (newMinute >= 60) {
        newMinute -= 60;
        newHour += 1;
      }

      currentTime = TimeOfDay(hour: newHour, minute: newMinute);
    }
    return timeSlots;
  }

  String _appointmentDetails = '';
  String convertTo24HourFormat(String time12Hour) {
    // Parse the 12-hour format time
    final format12 = DateFormat("h:mm a");
    final dateTime = format12.parse(time12Hour);

    // Convert it to 24-hour format
    final format24 = DateFormat("HH:mm");
    return format24.format(dateTime);
  }
  Future<void> _submitAppointment(BuildContext context) async {
    print('All the details.');
    var userData = widget.createAppointmentArgs?.userDataEntity;
    // print(userData);
    String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
    String selectedTime = convertTo24HourFormat(selectedTimeSlot);

    String timeFmt = selectedTime.replaceAll(":", "-");
    String appointment = "$formattedDate-$timeFmt";
    String appointmentDate = "$formattedDate $selectedTime";

    final appointmentData = {
      "abhaId": userData?.kyc?.provider.id,
      "patientName": userData?.kyc?.firstName,
      "link":
      "https://8x8.vc/vpaas-magic-cookie-cf5217ce8a4048d89baa3f88ab649551/${userData?.kyc?.firstName}-TeleConsultation-${appointment}",
      "appointmentDate": appointmentDate,
      "mobile": userData?.phoneNumber,
      "email": userData?.kyc?.email,
      "prescription": "",
      "doctorOsid": widget.createAppointmentArgs?.doctorOsid,
      "status": "new",
      "walletId": userData?.wallet
    };
    print(appointmentData);
    try {
      print("Sending data...");
      final response = await http.post(
        Uri.parse('https://testspar.dpgongcp.com/registry/api/v1/Appointment'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(appointmentData),
      );
      if (response.statusCode == 200) {
        setState(() {
          _appointmentDetails = 'Appointment successfully booked!';
        });
        Navigator.of(context).pop();
      } else {
        setState(() {
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
    TimeOfDay now = TimeOfDay.now();
    TimeOfDay morningStart = TimeOfDay(hour: 9, minute: 0);
    TimeOfDay morningEnd = TimeOfDay(hour: 11, minute: 0);
    TimeOfDay eveningStart = TimeOfDay(hour: 11, minute: 0);
    TimeOfDay eveningEnd = TimeOfDay(hour: 21, minute: 0);

    List<String> morningSlots = [];
    List<String> eveningSlots = [];

    // Generate available slots based on current time
    if (selectedDate.day == DateTime.now().day) {
      if (now.hour < morningEnd.hour || (now.hour == morningEnd.hour && now.minute < morningEnd.minute)) {
        morningSlots = _generateTimeSlots(now.hour >= morningStart.hour ? now : morningStart, morningEnd);
      }
      if (now.hour < eveningEnd.hour || (now.hour == eveningEnd.hour && now.minute < eveningEnd.minute)) {
        eveningSlots = _generateTimeSlots(now.hour >= eveningStart.hour ? now : eveningStart, eveningEnd);
      }
    } else {
      morningSlots = _generateTimeSlots(morningStart, morningEnd);
      eveningSlots = _generateTimeSlots(eveningStart, eveningEnd);
    }

    // Randomly disable two slots (excluding selected time)
    _disableRandomSlots(morningSlots);
    _disableRandomSlots(eveningSlots);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: CommonTopHeader(
          title: 'Book Appointment',
          isTitleOnly: false,
          dividerColor: Colors.grey,
          onBackButtonPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.0),

            ListTile(
              title: Text("Select Date"),
              subtitle: Text("${selectedDate.toLocal()}".split(' ')[0]),
              trailing: Icon(Icons.calendar_today),
              onTap: () => _selectDate(context),
            ),
            SizedBox(height: 16.0),
            Text("Select Morning Slot"),
            morningSlots.isNotEmpty
                ? Wrap(
              spacing: 8.0,
              children: morningSlots.map((String time) {
                return ChoiceChip(
                  label: Text(time, style: TextStyle(color: Colors.white)),
                  selected: selectedTimeSlot == time,
                  onSelected: disabledSlots.contains(time)
                      ? null
                      : (bool selected) {
                    setState(() {
                      selectedTimeSlot = time;
                    });
                  },
                  selectedColor: Colors.blue,
                  backgroundColor: Colors.blue,
                  disabledColor: Colors.grey,  // Disabled color
                );
              }).toList(),
            )
                : Text("No morning slots available"),
            SizedBox(height: 16.0),
            Text("Select Evening Slot"),
            eveningSlots.isNotEmpty
                ? Wrap(
              spacing: 8.0,
              children: eveningSlots.map((String time) {
                return ChoiceChip(
                  label: Text(time, style: TextStyle(color: Colors.white)),
                  selected: selectedTimeSlot == time,
                  onSelected: disabledSlots.contains(time)
                      ? null
                      : (bool selected) {
                    setState(() {
                      selectedTimeSlot = time;
                    });
                  },
                  selectedColor: Colors.blue,
                  backgroundColor: Colors.blue,
                  disabledColor: Colors.grey,  // Disabled color
                );
              }).toList(),
            )
                : Text("No evening slots available"),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _submitAppointment(context);
              },
              child: Text('Book Appointment'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,        // Text color
                backgroundColor: Colors.blue,        // Button background color
                minimumSize: Size(double.infinity, 50), // Full width with a height of 50
              ).copyWith(
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),  // No border radius
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _disableRandomSlots(List<String> slots) {
    // Exclude the selected time slot from being disabled
    List<String> availableSlots = slots.where((slot) => slot != selectedTimeSlot).toList();

    if (availableSlots.length > 2) {
      final random = Random();
      // Randomly select two slots from the available ones
      final index1 = random.nextInt(availableSlots.length) + 1;
      int index2 = random.nextInt(availableSlots.length) + 1;

      // Ensure both selected slots are different
      while (index2 == index1) {
        index2 = random.nextInt(availableSlots.length);
      }

      setState(() {
        disabledSlots.add(availableSlots[index1]);
        disabledSlots.add(availableSlots[index2]);
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }
}

