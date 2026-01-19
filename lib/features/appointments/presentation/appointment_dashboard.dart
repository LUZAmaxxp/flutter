import 'package:flutter/material.dart';
import 'appointment_controller.dart';
import 'widgets/book_appointment_sheet.dart';

class AppointmentDashboard extends StatefulWidget {
  const AppointmentDashboard({super.key});

  @override
  State<AppointmentDashboard> createState() => _AppointmentDashboardState();
}

class _AppointmentDashboardState extends State<AppointmentDashboard> {
  final AppointmentController _controller = AppointmentController();

  @override
  void initState() {
    super.initState();
    _controller.loadAppointments();
    _controller.loadDoctors();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      body: ListenableBuilder(
        listenable: _controller,
        builder: (context, child) {
          return CustomScrollView(
            slivers: [
              _buildAppBar(),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader('Find a Specialist', () {}),
                      const SizedBox(height: 16),
                      _buildDoctorList(),
                      const SizedBox(height: 32),
                      _buildSectionHeader('My Appointments', () {}),
                    ],
                  ),
                ),
              ),
              _buildAppointmentList(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 100.0,
      floating: true,
      pinned: true,
      backgroundColor: const Color(0xFFF8F9FE),
      elevation: 0,
      flexibleSpace: const FlexibleSpaceBar(
        titlePadding: EdgeInsets.only(left: 24, bottom: 16),
        title: Text('Hello, Patient!', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      actions: [
        IconButton(icon: const Icon(Icons.search, color: Colors.black), onPressed: () {}),
        const SizedBox(width: 12),
      ],
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback onSeeAll) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        TextButton(onPressed: onSeeAll, child: const Text('See All', style: TextStyle(color: Colors.deepPurple))),
      ],
    );
  }

  Widget _buildDoctorList() {
    if (_controller.isLoading && _controller.doctors.isEmpty) {
      return const SizedBox(height: 160, child: Center(child: CircularProgressIndicator()));
    }

    if (_controller.doctors.isEmpty) {
      return const SizedBox(height: 160, child: Center(child: Text('No doctors found')));
    }

    return SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _controller.doctors.length,
        itemBuilder: (context, index) {
          final doc = _controller.doctors[index];
          return GestureDetector(
            onTap: () => _showBookingSheet(context, doc['_id']),
            child: Container(
              width: 140,
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 25, 
                    backgroundImage: NetworkImage(doc['avatarUrl'] ?? 'https://ui-avatars.com/api/?name=${doc['name']}')
                  ),
                  const SizedBox(height: 12),
                  Text(doc['name'] ?? 'Unknown', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13), overflow: TextOverflow.ellipsis),
                  Text(doc['specialization'] ?? 'General', style: const TextStyle(color: Colors.grey, fontSize: 11)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.star, color: Colors.orange, size: 12),
                      Text(' ${doc['rating'] ?? "4.5"}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAppointmentList() {
    if (_controller.isLoading && _controller.appointments.isEmpty) {
      return const SliverFillRemaining(child: Center(child: CircularProgressIndicator()));
    }

    if (_controller.appointments.isEmpty) {
      return SliverFillRemaining(
        child: Center(child: Text('No upcoming sessions', style: TextStyle(color: Colors.grey[400]))),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => _buildModernAppointmentCard(_controller.appointments[index]),
          childCount: _controller.appointments.length,
        ),
      ),
    );
  }

  Widget _buildModernAppointmentCard(dynamic appointment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.deepPurple.withOpacity(0.08), shape: BoxShape.circle),
            child: const Icon(Icons.medical_information_outlined, color: Colors.deepPurple),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(appointment.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text('Status: ${appointment.status.toString().split('.').last}', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
        ],
      ),
    );
  }

  void _showBookingSheet(BuildContext context, String doctorId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BookAppointmentSheet(doctorId: doctorId),
    );
  }
}
