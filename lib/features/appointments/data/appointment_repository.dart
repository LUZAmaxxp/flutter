import '../../../core/services/network_service.dart';

import 'appointment_model.dart';

class AppointmentRepository {
  final NetworkService _networkService = NetworkService();

  Future<List<Appointment>> getAppointments() async {
    try {
      final List<dynamic> response = await _networkService.get('/appointments');
      return response.map((json) => Appointment.fromJson(json)).toList();
    } catch (e) {
      // Return empty list or handle error appropriately for UI
      return [];
    }
  }

  Future<bool> createAppointment(Appointment appointment) async {
    try {
      await _networkService.post('/appointments', appointment.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }
}
