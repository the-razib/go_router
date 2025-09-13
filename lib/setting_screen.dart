import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Card(
              color: Colors.purple.shade50,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Icon(
                      Icons.settings,
                      size: 48,
                      color: Colors.purple.shade600,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Settings Screen',
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.purple.shade700,
                                ),
                          ),
                          Text(
                            'Configure your app preferences',
                            style: TextStyle(color: Colors.purple.shade600),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Settings options
            Expanded(
              child: ListView(
                children: [
                  _buildSettingsGroup(context, 'Account', [
                    _buildSettingTile(
                      context,
                      'Profile',
                      'Manage your profile information',
                      Icons.person,
                      () => context.go('/profile'),
                    ),
                    _buildSettingTile(
                      context,
                      'Users',
                      'View all users in the system',
                      Icons.group,
                      () => context.go('/users'),
                    ),
                  ]),

                  _buildSettingsGroup(context, 'Navigation Examples', [
                    _buildSettingTile(
                      context,
                      'Search',
                      'Try search functionality',
                      Icons.search,
                      () => context.go('/search'),
                    ),
                    _buildSettingTile(
                      context,
                      'User Details',
                      'View specific user details',
                      Icons.info,
                      () => context.go('/user/1'),
                    ),
                  ]),

                  _buildSettingsGroup(context, 'Navigation', [
                    _buildSettingTile(
                      context,
                      'Home',
                      'Go back to main screen',
                      Icons.home,
                      () => context.goNamed('home'),
                    ),
                  ]),
                ],
              ),
            ),

            // Current route info
            Card(
              color: Colors.grey.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Route Info:',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Path: ${GoRouterState.of(context).uri.path}',
                      style: const TextStyle(fontFamily: 'monospace'),
                    ),
                    Text(
                      'Name: ${GoRouterState.of(context).name ?? 'unnamed'}',
                      style: const TextStyle(fontFamily: 'monospace'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsGroup(
    BuildContext context,
    String title,
    List<Widget> children,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
        ),
        Card(child: Column(children: children)),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildSettingTile(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon, color: Colors.purple.shade600),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
