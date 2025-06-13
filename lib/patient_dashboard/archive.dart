import 'package:flutter/material.dart';

class ArchiveScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text(
          'Archive Patient ',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
        ),
        centerTitle: true,
        foregroundColor: Colors.white,
        backgroundColor: Colors.indigo,

      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom:420.0),
      child: Center(
          child: Text('Archive Screen \n\n Screen is in Progress !😊',
          style: TextStyle(fontSize: 25),
      ),
      ),
      ),
    );

  }
}


