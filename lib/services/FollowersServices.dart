import 'dart:convert';

import 'package:http/http.dart' as http;

class Follower {
  final String login;
  final String avatarUrl;
  final int id;

  Follower({required this.login, required this.avatarUrl, required this.id});

  factory Follower.fromJson(Map<String, dynamic> json) {
    return Follower(
      login: json['login'],
      avatarUrl: json['avatar_url'],
      id: json['id'],
    );
  }
}

class FollowersService {
  Future<List<Follower>> fetchFollowers(String username) async {
    final response = await http.get(Uri.parse('https://api.github.com/users/$username/followers'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => Follower.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load followers for $username');
    }
  }
}

