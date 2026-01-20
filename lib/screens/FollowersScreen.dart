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
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black, // Makes back button black
        title: const Text("Followers", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Header Section
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            width: double.infinity,
            color: Colors.grey[50],
            child: Column(
              children: [
                Text(
                  "Viewing followers for",
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  "@${widget.username}",
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.blueAccent
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // List Section
          Expanded(
            child: FutureBuilder<List<Follower>>(
              future: _followersFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text('Error loading followers: ${snapshot.error}', textAlign: TextAlign.center),
                    ),
                  );
                }

                final followers = snapshot.data!;

                if (followers.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.person_off_outlined, size: 60, color: Colors.grey[300]),
                        const SizedBox(height: 10),
                        Text("No followers found", style: TextStyle(color: Colors.grey[500])),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  itemCount: followers.length,
                  separatorBuilder: (context, index) => Divider(indent: 70, color: Colors.grey[200]),
                  itemBuilder: (context, index) {
                    final follower = followers[index];
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                      leading: Hero(
                        tag: follower.id, // Simple animation tag if you navigate later
                        child: CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.blue[100],
                          backgroundImage: NetworkImage(follower.avatarUrl),
                          onBackgroundImageError: (_,__) => const Icon(Icons.person),
                        ),
                      ),
                      title: Text(
                        follower.login,
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                      subtitle: Text(
                        'ID: ${follower.id}',
                        style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey[300]),
                      onTap: () {
                        // Action when tapping a follower (e.g. go to their profile)
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}