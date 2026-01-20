import 'package:course101/screens/FollowersScreen.dart';
import 'package:course101/services/UserServices.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

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
    final theme = Theme.of(context);
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _loadUsers,
        color: theme.colorScheme.primary,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 120.0,
              floating: false,
              pinned: true,
              backgroundColor: theme.scaffoldBackgroundColor,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Text(
                  'GitHub Users',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: theme.colorScheme.onBackground,
                  ),
                ),
              ),
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
                          Icon(Icons.cloud_off_outlined, size: 48, color: theme.colorScheme.secondary),
                          const SizedBox(height: 16),
                          Text('Oops! Something went wrong.', style: theme.textTheme.titleMedium),
                          const SizedBox(height: 8),
                          Text(
                            'Please check your connection and try again.',
                            style: theme.textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: _loadUsers,
                            child: const Text("Retry"),
                          )
                        ],
                      ),
                    ),
                  );
                }

                final users = snapshot.data!;

                if (users.isEmpty) {
                  return const SliverFillRemaining(
                    child: Center(child: Text("No users found.")),
                  );
                }

                return AnimationLimiter(
                  child: SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (context, index) {
                        return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(milliseconds: 375),
                          child: SlideAnimation(
                            verticalOffset: 50.0,
                            child: FadeInAnimation(
                              child: _buildUserCard(users[index]),
                            ),
                          ),
                        );
                      },
                      childCount: users.length,
                    ),
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
    final theme = Theme.of(context);
    return Card(
      child: InkWell(
        onTap: () => _navigateToFollowers(user),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Avatar
              Hero(
                tag: 'avatar_${user.username}',
                child: CircleAvatar(
                  radius: 32,
                  backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                  backgroundImage: NetworkImage(user.avatarUrl ?? ''),
                  onBackgroundImageError: (_, __) {}, // Gracefully handle error
                  child: user.avatarUrl == null
                      ? Icon(Icons.person, color: theme.colorScheme.primary)
                      : null,
                ),
              ),
              const SizedBox(width: 16),

              // Text Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.username ?? 'Unknown User',
                      style: theme.textTheme.titleMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'ID: ${user.id}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),

              // Action Button
              Icon(Icons.arrow_forward_ios_rounded, color: theme.colorScheme.secondary.withOpacity(0.5)),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToFollowers(UserServices user) {
    if (user.username != null) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => FollowersScreen(username: user.username!),
      ));
    }
  }
}
