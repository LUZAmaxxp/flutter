import 'package:flutter/material.dart';
import '../data/appointment_model.dart';
import '../data/appointment_repository.dart';

class AppointmentController extends ChangeNotifier {
  final AppointmentRepository _repository = AppointmentRepository();
  
  List<Appointment> _appointments = [];
  bool _isLoading = false;

  List<Appointment> get appointments => _appointments;
  bool get isLoading => _isLoading;

  Future<void> loadAppointments() async {
    _isLoading = true;
    notifyListeners();
    _appointments = await _repository.getAppointments();
    
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> addAppointment(Appointment appointment) async {
    final success = await _repository.createAppointment(appointment);
    if (success) {
      await loadAppointments(); // Refresh list
    }
    return success;
  }
}
