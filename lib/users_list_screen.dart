import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UsersListScreen extends StatelessWidget {
  const UsersListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users List'),
        actions: [
          IconButton(
            onPressed: () => context.go('/search?q=users'),
            icon: const Icon(Icons.search),
            tooltip: 'Search Users',
          ),
        ],
      ),
      body: Column(
        children: [
          // Header section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nested Routes Example',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.blue.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'This demonstrates nested routing. Tap any user to see their details.',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.blue.shade600),
                ),
              ],
            ),
          ),

          // Users list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 20,
              itemBuilder: (context, index) {
                final userId = index + 1;
                final user = _generateMockUser(userId);

                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor:
                          Colors.primaries[index % Colors.primaries.length],
                      child: Text(
                        user.initials,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(user.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user.email),
                        Text(
                          user.role,
                          style: TextStyle(
                            fontSize: 12,
                            color: _getRoleColor(user.role),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // Navigate to nested route: /users/:id/details
                      context.go('/users/$userId/details');
                    },
                  ),
                );
              },
            ),
          ),

          // Bottom navigation examples
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  'Try different navigation methods:',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => context.goNamed('home'),
                        icon: const Icon(Icons.home, size: 18),
                        label: const Text('Home'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => context.goNamed('search'),
                        icon: const Icon(Icons.search, size: 18),
                        label: const Text('Search'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  MockUser _generateMockUser(int id) {
    final names = [
      'Alice Johnson',
      'Bob Smith',
      'Carol Davis',
      'David Wilson',
      'Emma Brown',
      'Frank Miller',
      'Grace Lee',
      'Henry Taylor',
      'Ivy Chen',
      'Jack Anderson',
      'Kate Thompson',
      'Liam Garcia',
      'Mia Rodriguez',
      'Noah Martinez',
      'Olivia Hernandez',
      'Paul Lopez',
      'Quinn Gonzalez',
      'Ruby Perez',
      'Sam Turner',
      'Tara White',
    ];

    final roles = ['User', 'Admin', 'Moderator', 'Editor'];

    final name = names[(id - 1) % names.length];
    final role = roles[(id - 1) % roles.length];

    return MockUser(
      id: id,
      name: name,
      email: '${name.toLowerCase().replaceAll(' ', '.')}@example.com',
      role: role,
    );
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'Admin':
        return Colors.red.shade600;
      case 'Moderator':
        return Colors.orange.shade600;
      case 'Editor':
        return Colors.green.shade600;
      default:
        return Colors.blue.shade600;
    }
  }
}

class MockUser {
  final int id;
  final String name;
  final String email;
  final String role;

  MockUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  String get initials {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }
}
