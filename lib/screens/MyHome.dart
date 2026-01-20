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
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() {
      _usersFuture = UserServices().fetchuser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Softer background
      body: RefreshIndicator(
        onRefresh: _loadUsers,
        child: CustomScrollView(
          slivers: [
            const SliverAppBar(
              expandedHeight: 120.0,
              floating: true,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  'GitHub Users',
                  style: TextStyle(color: Colors.black87),
                ),
                centerTitle: true,
                background: DecoratedBox(
                  decoration: BoxDecoration(color: Colors.white),
                ),
              ),
              backgroundColor: Colors.white,
              elevation: 2,
              iconTheme: IconThemeData(color: Colors.black87),
            ),
            FutureBuilder<List<UserServices>>(
              future: _usersFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (snapshot.hasError) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline, size: 48, color: Colors.redAccent),
                          const SizedBox(height: 16),
                          Text('Oops! Something went wrong.\n${snapshot.error}', textAlign: TextAlign.center),
                          const SizedBox(height: 16),
                          ElevatedButton(onPressed: _loadUsers, child: const Text("Retry"))
                        ],
                      ),
                    ),
                  );
                }

                final users = snapshot.data!;

                if (users.isEmpty) {
                  return const SliverFillRemaining(child: Center(child: Text("No users found.")));
                }

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      return _buildUserCard(users[index]);
                    },
                    childCount: users.length,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserCard(UserServices user) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          // Tapping the whole card can also go to followers if you prefer
          onTap: () => _navigateToFollowers(user),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                // Avatar with Border
                Container(
                  padding: const EdgeInsets.all(2), // Border width
                  decoration: BoxDecoration(
                    color: Colors.blueAccent.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: NetworkImage(user.avatarUrl ?? ''),
                    onBackgroundImageError: (_, __) => const Icon(Icons.person),
                  ),
                ),
                const SizedBox(width: 16),

                // Text Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.username ?? 'Unknown',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.blueGrey[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'ID: ${user.id}',
                          style: TextStyle(fontSize: 12, color: Colors.blueGrey[700]),
                        ),
                      ),
                    ],
                  ),
                ),

                // Popup Menu
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, color: Colors.grey),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  onSelected: (value) {
                    if (value == 'Followers') {
                      _navigateToFollowers(user);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('$value selected for ${user.username}')),
                      );
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return [
                      _buildMenuItem('View Followers', Icons.people),
                      _buildMenuItem('Edit User', Icons.edit),
                      _buildMenuItem('Delete', Icons.delete, isDestructive: true),
                    ];
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToFollowers(UserServices user) {
    if(user.username != null) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => FollowersScreen(username: user.username!)));
    }
  }

  PopupMenuItem<String> _buildMenuItem(String text, IconData icon, {bool isDestructive = false}) {
    return PopupMenuItem<String>(
      value: text.contains('Followers') ? 'Followers' : text,
      child: Row(
        children: [
          Icon(icon, color: isDestructive ? Colors.red : Colors.grey[700], size: 20),
          const SizedBox(width: 12),
          Text(
            text,
            style: TextStyle(color: isDestructive ? Colors.red : Colors.black87),
          ),
        ],
      ),
    );
  }
}