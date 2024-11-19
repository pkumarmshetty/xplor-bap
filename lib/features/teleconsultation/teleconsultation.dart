import 'package:flutter/material.dart';
import 'package:xplor/features/teleconsultation/schedule_appointment_screen.dart';

class Teleconsultation extends StatelessWidget {
  const Teleconsultation({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Teleconsultation Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ScheduleAppointmentScreen(),
    );
  }
}
