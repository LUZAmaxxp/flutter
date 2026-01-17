import 'package:course101/services/FollowersServices.dart';
import 'package:flutter/material.dart';

class FollowersScreen extends StatefulWidget {
  final String username;

  const FollowersScreen({Key? key, required this.username}) : super(key: key);

  @override
  _FollowersScreenState createState() => _FollowersScreenState();
}

class _FollowersScreenState extends State<FollowersScreen> {
  late Future<List<Follower>> _followersFuture;

  @override
  void initState() {
    super.initState();
    _followersFuture = FollowersService().fetchFollowers(widget.username);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.username}\'s Followers'),
      ),
      body: FutureBuilder<List<Follower>>(
        future: _followersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final followers = snapshot.data!;

          return ListView.builder(
            itemCount: followers.length,
            itemBuilder: (context, index) {
              final follower = followers[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 3,
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(follower.avatarUrl),
                  ),
                  title: Text(follower.login, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('ID: ${follower.id}'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
