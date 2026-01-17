import 'package:flutter/material.dart';
import '../data/appointment_model.dart';

class AppointmentDashboard extends StatelessWidget {
  const AppointmentDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Appointments'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Upcoming',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 5, // Placeholder
              itemBuilder: (context, index) {
                return _buildAppointmentCard();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: const Text('Book Appointment'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildAppointmentCard() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.deepPurple.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.calendar_today, color: Colors.deepPurple),
        ),
        title: const Text(
          'Dental Checkup',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: const Text('Tomorrow at 10:00 AM\nDr. Smith • General Clinic'),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
