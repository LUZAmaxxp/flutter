import 'package:flutter/material.dart';
import 'widgets/book_appointment_sheet.dart';

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
            padding: EdgeInsets.all(24.0),
            child: Text(
              'Upcoming Schedule',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 3, // Placeholder
              itemBuilder: (context, index) {
                return _buildAppointmentCard();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            builder: (context) => const BookAppointmentSheet(),
          );
        },
        label: const Text('New Appointment'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildAppointmentCard() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.deepPurple.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.calendar_month, color: Colors.deepPurple),
        ),
        title: const Text(
          'Therapy Session',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: const Text('Oct 25, 2023 at 02:30 PM\nWellness Center'),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.green[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            'Confirmed',
            style: TextStyle(color: Colors.green[700], fontSize: 12),
          ),
        ),
      ),
    );
  }
}
