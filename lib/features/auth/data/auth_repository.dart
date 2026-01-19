import '../../../core/services/network_service.dart';

class AuthRepository {
  final NetworkService _networkService = NetworkService();
  Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      final response = await _networkService.post('/auth/login', {
        'email': email,
        'password': password,
      });
      return response;
    } catch (e) {
      return null;
    }
  }

  Future<bool> register(String email, String password, String name, {String role = 'client'}) async {
    try {
      await _networkService.post('/auth/register', {
        'email': email,
        'password': password,
        'name': name,
        'role': role,
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> verifyEmail(String email, String code) async {
    try {
      await _networkService.post('/auth/verify', {
        'email': email,
        'code': code,
      });
      return true;
    } catch (e) {
      return false;
    }
  }
}
