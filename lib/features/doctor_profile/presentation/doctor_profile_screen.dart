import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../appointments/presentation/widgets/book_appointment_sheet.dart';

class DoctorProfileScreen extends StatelessWidget {
  final Map<String, dynamic> doctor;

  const DoctorProfileScreen({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      // The background color is now handled by the global theme
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250.0,
            floating: false,
            pinned: true,
            backgroundColor: theme.colorScheme.surface,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: theme.colorScheme.primary),
              onPressed: () => Navigator.of(context).pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: _buildHeader(context),
            ),
          ),
          SliverToBoxAdapter(child: _buildDetails(context)),
        ],
      ),
      bottomNavigationBar: _buildBookingButton(context),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 60, 24, 24), // Adjust top padding for app bar
        child: Row(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage('https://i.pravatar.cc/300?u=${doctor['_id']}'),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Dr. ${doctor['name']}',
                    style: textTheme.titleLarge?.copyWith(color: colorScheme.onSurface),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    doctor['specialization'] ?? 'General Specialist',
                    style: textTheme.bodyLarge?.copyWith(color: colorScheme.secondary),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.star_rounded, color: Colors.amber, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        '4.8 (234 reviews)',
                        style: textTheme.bodyMedium?.copyWith(color: colorScheme.secondary),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetails(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    
    // Using AnimationLimiter to wrap all animated children
    return AnimationLimiter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: AnimationConfiguration.toStaggeredList(
            duration: const Duration(milliseconds: 375),
            childAnimationBuilder: (widget) => SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: widget,
              ),
            ),
            children: [
              _buildInfoCard(
                context,
                title: 'About Doctor',
                child: Text(
                  'A dedicated and compassionate doctor with over 10 years of experience in providing quality healthcare. Known for a patient-centric approach and commitment to medical excellence.',
                  style: textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                    height: 1.5,
                  ),
                ),
              ),
              _buildInfoCard(
                context,
                title: 'Qualifications',
                child: Column(
                  children: [
                    _buildQualificationItem(context, 'MBBS from King\'s College, London (2010 M.D.)'),
                    _buildQualificationItem(context, 'FRCS from Royal College of Surgeons (2015)'),
                  ],
                ),
              ),
              _buildInfoCard(
                context,
                title: 'Patient Reviews',
                child: Column(
                  children: [
                    _buildReviewItem(context, 'Alice', 'Very professional and caring. Highly recommended!'),
                    _buildReviewItem(context, 'Bob', 'Great experience, the doctor was very thorough.'),
                  ],
                ),
              ),
              const SizedBox(height: 24), // Spacer for the bottom
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildInfoCard(BuildContext context, {required String title, required Widget child}) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Card(
      // Card properties are now inherited from the global CardTheme
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: textTheme.titleMedium),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildQualificationItem(BuildContext context, String text) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        children: [
          Icon(Icons.check_circle_outline_rounded, color: colorScheme.primary, size: 20),
          const SizedBox(width: 16),
          Expanded(child: Text(text, style: theme.textTheme.bodyLarge)),
        ],
      ),
    );
  }

  Widget _buildReviewItem(BuildContext context, String name, String review) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor, // A slightly different background for contrast
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: textTheme.titleSmall),
          const SizedBox(height: 6),
          Text(review, style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface.withOpacity(0.7))),
        ],
      ),
    );
  }

  Widget _buildBookingButton(BuildContext context) {
    // The button now uses the style from ElevatedButtonThemeData
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      child: ElevatedButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent, // Sheet has its own themeing
            builder: (context) => BookAppointmentSheet(doctorId: doctor['_id']),
          );
        },
        // The style is now inherited, but we can add specific text
        child: const Text('Book an Appointment'),
      ),
    );
  }
}