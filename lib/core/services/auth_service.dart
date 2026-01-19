class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  String? userId;
  String? userName;
  String? userEmail;
  String? role;

  void setUser(Map<String, dynamic> userData) {
    userId = userData['id'];
    userName = userData['name'];
    userEmail = userData['email'];
    role = userData['role'];
  }

  bool get isLoggedIn => userId != null;
  bool get isDoctor => role == 'doctor';

  void logout() {
    userId = null;
    userName = null;
    userEmail = null;
    role = null;
  }
}
