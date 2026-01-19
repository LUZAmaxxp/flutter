import 'package:flutter/material.dart';
import '../data/appointment_model.dart';
import '../data/appointment_repository.dart';

class AppointmentController extends ChangeNotifier {
  final AppointmentRepository _repository = AppointmentRepository();
  
  List<Appointment> _appointments = [];
  Map<String, dynamic> _stats = {
    'total': 0,
    'pending': 0,
    'confirmed': 0,
    'done': 0,
    'cancelled': 0,
  };
  bool _isLoading = false;

  List<Appointment> get appointments => _appointments;
  Map<String, dynamic> get stats => _stats;
  bool get isLoading => _isLoading;

  List<dynamic> _doctors = [];
  List<dynamic> get doctors => _doctors;

  Future<void> loadDoctors() async {
    _isLoading = true;
    notifyListeners();
    _doctors = await _repository.getDoctors();
    _isLoading = false;
    notifyListeners();
  }


  Future<void> loadAppointments() async {
    _isLoading = true;
    notifyListeners();
    _appointments = await _repository.getAppointments();
    final newStats = await _repository.getStatsSummary();
    if (newStats != null) {
      _stats = newStats;
    }
    
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadStats() async {
    final newStats = await _repository.getStatsSummary();
    if (newStats != null) {
      _stats = newStats;
      notifyListeners();
    }
  }

  Future<bool> addAppointment(Appointment appointment) async {
    final success = await _repository.createAppointment(appointment);
    if (success) {
      await loadAppointments();
    }
    return success;
  }

  Future<bool> updateAppointmentStatus(String id, String status) async {
    final success = await _repository.updateStatus(id, status);
    if (success) {
      await loadAppointments();
    }
    return success;
  }
}
