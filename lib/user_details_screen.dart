import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UserDetailsScreen extends StatelessWidget {
  final String userId;

  const UserDetailsScreen({required this.userId, super.key});

  @override
  Widget build(BuildContext context) {
    final user = _getMockUserDetails(userId);

    return Scaffold(
      appBar: AppBar(
        title: Text('${user.name} Details'),
        actions: [
          IconButton(
            onPressed: () => context.go('/search?q=${user.name}'),
            icon: const Icon(Icons.search),
            tooltip: 'Search for ${user.name}',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User header card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.blue.shade100,
                      child: Text(
                        user.initials,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.name,
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user.email,
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(color: Colors.grey.shade600),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: _getRoleColor(user.role).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: _getRoleColor(user.role),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              user.role,
                              style: TextStyle(
                                color: _getRoleColor(user.role),
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // User details
            _buildDetailSection(context, 'Personal Information', [
              _buildDetailRow('User ID', userId),
              _buildDetailRow('Full Name', user.name),
              _buildDetailRow('Email', user.email),
              _buildDetailRow('Phone', user.phone),
              _buildDetailRow('Department', user.department),
            ]),

            const SizedBox(height: 16),

            _buildDetailSection(context, 'Account Information', [
              _buildDetailRow('Role', user.role),
              _buildDetailRow('Join Date', user.joinDate),
              _buildDetailRow('Last Login', user.lastLogin),
              _buildDetailRow('Status', user.isActive ? 'Active' : 'Inactive'),
            ]),

            const SizedBox(height: 24),

            // Navigation examples for nested routes
            Card(
              color: Colors.amber.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nested Route Example',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.amber.shade800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Current URL: /users/$userId/details',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        color: Colors.amber.shade700,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'This screen demonstrates nested routing. The route structure is:',
                      style: TextStyle(color: Colors.amber.shade700),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '/users → Users List\n/users/:id/details → This screen',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        color: Colors.amber.shade700,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Action buttons
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton.icon(
                  onPressed: () => context.go('/users'),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Back to Users List'),
                ),

                const SizedBox(height: 12),

                ElevatedButton.icon(
                  onPressed: () => context.go('/user/$userId'),
                  icon: const Icon(Icons.person),
                  label: const Text('View User Profile (Different Route)'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),

                const SizedBox(height: 12),

                OutlinedButton.icon(
                  onPressed: () => context.goNamed('home'),
                  icon: const Icon(Icons.home),
                  label: const Text('Go to Home'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailSection(
    BuildContext context,
    String title,
    List<Widget> children,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  UserDetailModel _getMockUserDetails(String userId) {
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
    ];

    final departments = [
      'Engineering',
      'Marketing',
      'Sales',
      'HR',
      'Finance',
      'Operations',
      'Design',
      'Support',
      'Legal',
      'Research',
    ];

    final roles = ['User', 'Admin', 'Moderator', 'Editor'];

    final id = int.tryParse(userId) ?? 1;
    final name = names[(id - 1) % names.length];
    final department = departments[(id - 1) % departments.length];
    final role = roles[(id - 1) % roles.length];

    return UserDetailModel(
      id: userId,
      name: name,
      email: '${name.toLowerCase().replaceAll(' ', '.')}@example.com',
      phone: '+1 (555) ${100 + id}-${1000 + id}',
      department: department,
      role: role,
      joinDate: '202${(id % 4) + 1}-0${(id % 9) + 1}-15',
      lastLogin: '2024-01-${15 + (id % 15)} 10:30 AM',
      isActive: id % 3 != 0, // Make some users inactive
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

class UserDetailModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String department;
  final String role;
  final String joinDate;
  final String lastLogin;
  final bool isActive;

  UserDetailModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.department,
    required this.role,
    required this.joinDate,
    required this.lastLogin,
    required this.isActive,
  });

  String get initials {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }
}
