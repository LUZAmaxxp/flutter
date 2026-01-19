import '../../../core/services/network_service.dart';
<<<<<<< Updated upstream

=======
import '../../../core/services/auth_service.dart';
>>>>>>> Stashed changes
import 'appointment_model.dart';

class AppointmentRepository {
  final NetworkService _networkService = NetworkService();
  final AuthService _authService = AuthService();

  Future<List<Appointment>> getAppointments() async {
    try {
      final userId = _authService.userId;
      if (userId == null) return [];
      
      final List<dynamic> response = await _networkService.get('/appointments/$userId');
      return response.map((json) => Appointment.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<Map<String, dynamic>?> getStatsSummary() async {
    try {
      final dynamic response = await _networkService.get('/appointments/stats/summary');
      return response as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  Future<bool> createAppointment(Appointment appointment) async {
    try {
      final userId = _authService.userId;
      if (userId == null) return false;

      final appointmentData = appointment.toJson();
      appointmentData['userId'] = userId;

      await _networkService.post('/appointments', appointmentData);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateStatus(String appointmentId, String status) async {
    try {
      await _networkService.patch('/appointments/$appointmentId/status', {
        'status': status,
      });
      return true;
    } catch (e) {
      return false;
    }
  }
}
