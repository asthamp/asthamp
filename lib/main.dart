import 'package:flutter/material.dart';

import 'patient_dashboard/patient_dashboard_screen.dart';
import 'patient_dashboard/edit.dart';
import 'patient_dashboard/archive.dart';

import 'patient_dashboard/invite_Family_Member.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Care Connect',
    theme: ThemeData(primarySwatch: Colors.indigo),
    initialRoute: '/',
    home: PatientDashboardScreen(caregiverEmail: 'bartsimpson@example.com'),
    routes: {
      '/edit': (context) => EditScreen(),
      '/archive': (context) => ArchiveScreen(),
      '/invite_Family_Member': (context) => InviteFamilyMemberScreen(),
    },
  ));
}
