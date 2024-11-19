import 'package:flutter/material.dart';
import 'health_record_search.dart';
import 'health_record_search.dart';

class HealthRecord extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ABDM Health Records',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HealthRecordSearchScreen(),
    );
  }
}