import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xplor/features/teleconsultation/video_call_screen.dart';
class AppointmentDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> appointment;

  AppointmentDetailsScreen(this.appointment, {super.key});

  void _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    await launchUrl(launchUri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Appointment Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Patient Name: ${appointment['name']}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Description: ${appointment['description']}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text(
              'Scheduled Time: ${DateFormat('dd MMM yyyy, hh:mm a').format(appointment['dateTime'])}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => VideoCallScreen()),
                );
              },
              child: Text('Start Video Call'),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                _makePhoneCall('123456789'); // Replace with a dummy phone number
              },
              child: Text('Make Phone Call'),
            ),
          ],
        ),
      ),
    );
  }
}
