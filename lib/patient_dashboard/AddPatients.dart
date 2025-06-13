import 'package:flutter/material.dart';

class AddPatientScreen extends StatelessWidget {
  const AddPatientScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text(
          'Add Patient',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
        ),
        centerTitle: true,
        foregroundColor: Colors.white,
        backgroundColor: Colors.indigo,

      ),

      body: Padding(
        padding: const EdgeInsets.only(bottom:420.0),

        child: Center(
          child: Text( 'This is Add Patient screen. \n Screen is in Progress !😊',
            style: TextStyle(fontSize: 20),
          textAlign: TextAlign.center ,
          ),


        ),
      ),
    );
  }
}
