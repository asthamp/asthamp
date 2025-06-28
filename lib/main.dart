
/* Caregiver Dashboard

*/



import 'package:flutter/material.dart';

import 'Caregiver_dashboard/patient_dashboard_screen.dart';
import 'Caregiver_dashboard/edit.dart';
import 'Caregiver_dashboard/archive.dart';
import 'Caregiver_dashboard/invite_Family_Member.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  runApp(const CareConnectApp());
}

class CareConnectApp extends StatelessWidget {
  const CareConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Care Connect',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const PatientDashboardScreen(
        caregiverEmail: 'jane.malala@example.com',
      ),

      routes: {
        '/edit': (context) => EditScreen(),
        '/archive': (context) => ArchiveScreen(),
        '/invite_Family_Member': (context) => InviteFamilyMemberScreen(),
      },
    );
  }
}






/*
 //for patient dashboard

import 'package:flutter/material.dart';

import 'PatientDashboard/patient_main_screen.dart';





void main() {
  runApp(const CareConnectPatientApp());
}

class CareConnectPatientApp extends StatelessWidget {
  const CareConnectPatientApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Care Connect - Patient',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const PatientDashboard(), // This line will Launches the full patient screen i.e patient_main_screen
    );
  }
}


*/

