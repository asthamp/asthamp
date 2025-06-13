import 'package:flutter/material.dart';

class ViewLogsScreen extends StatelessWidget {
  const ViewLogsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'View Logs',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
        ),
        centerTitle: true,
        foregroundColor: Colors.white,
        backgroundColor: Colors.indigo,

      ),
      body: Center(child: Text('View Logs \n\n Screen is in Progress !😊')),
    );
  }
}
