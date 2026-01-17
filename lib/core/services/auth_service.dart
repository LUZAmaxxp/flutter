import '../models/user_model.dart';

class AuthService {
  // Singleton pattern for global access
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  String? userId;
  String? userName;
  String? userEmail;

  void setUser(Map<String, dynamic> userData) {
    userId = userData['id'];
    userName = userData['name'];
    userEmail = userData['email'];
  }

  void logout() {
    userId = null;
    userName = null;
    userEmail = null;
  }
}
