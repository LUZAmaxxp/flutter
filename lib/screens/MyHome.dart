import 'package:course101/screens/FollowersScreen.dart';
import 'package:course101/services/UserServices.dart';
import 'package:flutter/material.dart';

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  Future<List<UserServices>>? _usersFuture;

  @override
  void initState() {
    super.initState();
    _usersFuture = UserServices().fetchuser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GitHub Users'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<UserServices>>(
        future: _usersFuture,
        builder: (context, snapshot) {
          // Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Error
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          // Data
          final users = snapshot.data!;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              return _buildUserCard(users[index]);
            },
          );
        },
      ),
    );
  }

  Widget _buildUserCard(UserServices user) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3,
      child: ListTile(
        leading: CircleAvatar(
          radius: 25,
          backgroundImage: NetworkImage(user.avatarUrl ?? ''),
        ),
        title: Text(
          user.username ?? 'No username',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('User ID: ${user.id}'),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'Followers') {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => FollowersScreen(username: user.username!)));
            } else {
              print('Selected: $value for user ${user.id}');
            }
          },
          itemBuilder: (BuildContext context) {
            return {'Edit', 'Delete', 'Followers'}.map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Text(choice),
              );
            }).toList();
          },
        ),
      ),
    );
  }
}
