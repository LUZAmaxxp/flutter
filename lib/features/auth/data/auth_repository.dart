import '../../../core/services/network_service.dart';

class AuthRepository {
  final NetworkService _networkService = NetworkService();

  Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      // Endpoint for Better Auth login
      final response = await _networkService.post('/auth/login', {
        'email': email,
        'password': password,
      });
      return response;
    } catch (e) {
      return null;
    }
  }

  Future<bool> register(String email, String password, String name) async {
    try {
      await _networkService.post('/auth/register', {
        'email': email,
        'password': password,
        'name': name,
      });
      return true;
    } catch (e) {
      return false;
    }
  }
}
