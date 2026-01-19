import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'appointment_controller.dart';
import '../../data/appointment_model.dart';

class DoctorDashboard extends StatefulWidget {
  const DoctorDashboard({super.key});

  @override
  State<DoctorDashboard> createState() => _DoctorDashboardState();
}

class _DoctorDashboardState extends State<DoctorDashboard> {
  final AppointmentController _controller = AppointmentController();

  @override
  void initState() {
    super.initState();
    _controller.loadAppointments();
  }

  Future<void> _updateStatus(String id, String newStatus) async {
    // We'll need to add this method to the controller/repository
    // For now, let's assume it exists or we'll add it next
    // await _controller.updateAppointmentStatus(id, newStatus);
    _controller.loadAppointments(); // Refresh
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 140.0,
            floating: false,
            pinned: true,
            backgroundColor: Colors.deepPurple,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('Doctor Portal', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              background: Container(color: Colors.deepPurple),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildWeeklySummary(),
                  const SizedBox(height: 32),
                  const Text('Incoming Appointments', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          ListenableBuilder(
            listenable: _controller,
            builder: (context, child) {
              if (_controller.isLoading) {
                return const SliverFillRemaining(child: Center(child: CircularProgressIndicator()));
              }

              if (_controller.appointments.isEmpty) {
                return const SliverFillRemaining(child: Center(child: Text('No appointments found')));
              }

              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final appointment = _controller.appointments[index];
                    return _buildDoctorAppointmentCard(appointment);
                  },
                  childCount: _controller.appointments.length,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklySummary() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _summaryItem('Total', '12', Icons.calendar_month, Colors.blue),
          _summaryItem('Pending', '5', Icons.pending_actions, Colors.orange),
          _summaryItem('Done', '7', Icons.check_circle, Colors.green),
        ],
      ),
    );
  }

  Widget _summaryItem(String label, String count, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color),
        const SizedBox(height: 8),
        Text(count, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }

  Widget _buildDoctorAppointmentCard(Appointment appointment) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat('MMM dd, hh:mm a').format(appointment.dateTime),
                style: const TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold),
              ),
              _buildStatusChip(appointment.status.toString().split('.').last),
            ],
          ),
          const SizedBox(height: 12),
          Text(appointment.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text('Patient: ${appointment.userId}', style: TextStyle(color: Colors.grey[600])),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _updateStatus(appointment.id, 'cancelled'),
                  style: OutlinedButton.styleFrom(foregroundColor: Colors.red, side: const BorderSide(color: Colors.red)),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _updateStatus(appointment.id, 'confirmed'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                  child: const Text('Confirm'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color = Colors.orange;
    if (status == 'confirmed') color = Colors.green;
    if (status == 'cancelled') color = Colors.red;
    if (status == 'done') color = Colors.blue;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
      child: Text(status.toUpperCase(), style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }
}
