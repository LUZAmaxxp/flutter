import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/appointments/presentation/appointment_dashboard.dart';

void main() {
  runApp(const AppointmentApp());
}

class AppointmentApp extends StatelessWidget {
  const AppointmentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Appointment Pro',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const AppointmentDashboard(),
    );
  }
}
