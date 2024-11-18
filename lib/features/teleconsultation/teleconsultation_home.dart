import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:xplor/features/teleconsultation/appointment_details_screen.dart';
import 'package:xplor/features/teleconsultation/schedule_appointment_screen.dart';

class TeleconsultationHomeScreen extends StatefulWidget {
  const TeleconsultationHomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<TeleconsultationHomeScreen> {
  List<Map<String, dynamic>> appointments = [];

  void addAppointment(Map<String, dynamic> appointment) {
    setState(() {
      appointments.add(appointment);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Teleconsultation')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ScheduleAppointmentScreen()),
              );
              if (result != null) {
                addAppointment(result);
              }
            },
            child: Text('Schedule Appointment'),
          ),
          Expanded(
            child: appointments.isEmpty
                ? Center(child: Text('No appointments scheduled.'))
                : ListView.builder(
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                final appointment = appointments[index];
                return ListTile(
                  title: Text(appointment['name']),
                  subtitle: Text(DateFormat('dd MMM yyyy, hh:mm a')
                      .format(appointment['dateTime'])),
                  trailing: Text(appointment['status']),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AppointmentDetailsScreen(appointment),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
