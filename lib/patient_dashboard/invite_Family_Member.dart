import 'package:flutter/material.dart';

class InviteFamilyMemberScreen extends StatelessWidget {
  const InviteFamilyMemberScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Invite Family Member',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
        ),
        centerTitle: true,
        foregroundColor: Colors.white,
        backgroundColor: Colors.indigo,

      ),
      body: Center(child: Text('Invite Family Member Screen \n Screen is in Progress !😊')),
    );
  }
}
