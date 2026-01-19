import 'dart:convert';
import 'package:http/http.dart' as http;


class UserServices {
  final String? username;
  final String? avatarUrl;
  final int? id;
  UserServices({
     this.username,
     this.avatarUrl,
     this.id,
  });
  factory UserServices.fromJson(Map<String, dynamic> json) {
    return UserServices(
      username: json['login'],
      avatarUrl: json['avatar_url'],
      id: json['id'],
    );
  }


  Future<List<UserServices>> fetchuser() async{
    final response = await http.get(Uri.parse('https://api.github.com/users'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => UserServices.fromJson(e)).toList();
      } else {
      throw Exception('Failed to load GitHub users');
    }

  }


}
