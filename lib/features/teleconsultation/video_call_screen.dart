import 'package:flutter/material.dart';
class VideoCallScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Video Call')),
      body: Center(
        child: Text(
          'Video Call Simulation in Progress...',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
