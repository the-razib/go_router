import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GoRouter Demo Home')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Welcome card
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Icon(Icons.home, size: 64, color: Colors.blue.shade600),
                    const SizedBox(height: 16),
                    Text(
                      'Welcome to GoRouter Demo!',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade700,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Explore different navigation patterns and features',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.blue.shade600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Basic Navigation Section
            _buildSection(
              context,
              'Basic Navigation',
              'Simple page-to-page navigation using context.go()',
              [
                _buildNavigationButton(
                  context,
                  'Profile Screen',
                  Icons.person,
                  () => context.go('/profile'),
                  'Navigate to profile using path',
                ),
                _buildNavigationButton(
                  context,
                  'Settings Screen',
                  Icons.settings,
                  () => context.goNamed('settings'),
                  'Navigate using named route',
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Route Parameters Section
            _buildSection(
              context,
              'Route Parameters',
              'Navigate to screens with dynamic parameters',
              [
                _buildNavigationButton(
                  context,
                  'View User 1',
                  Icons.person_outline,
                  () => context.go('/user/1'),
                  'Path parameter: /user/1',
                ),
                _buildNavigationButton(
                  context,
                  'View User 5',
                  Icons.person_outline,
                  () =>
                      context.goNamed('user', pathParameters: {'userId': '5'}),
                  'Named route with parameters',
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Query Parameters Section
            _buildSection(
              context,
              'Query Parameters',
              'Navigate with URL query parameters',
              [
                _buildNavigationButton(
                  context,
                  'Search "Flutter"',
                  Icons.search,
                  () => context.go('/search?q=Flutter&page=1'),
                  'Query params: ?q=Flutter&page=1',
                ),
                _buildNavigationButton(
                  context,
                  'Search "GoRouter"',
                  Icons.search,
                  () => context.goNamed(
                    'search',
                    queryParameters: {'q': 'GoRouter', 'page': '2'},
                  ),
                  'Named route with query params',
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Nested Routes Section
            _buildSection(
              context,
              'Nested Routes',
              'Hierarchical navigation structures',
              [
                _buildNavigationButton(
                  context,
                  'Users List',
                  Icons.group,
                  () => context.go('/users'),
                  'Parent route: /users',
                ),
                _buildNavigationButton(
                  context,
                  'User 3 Details',
                  Icons.info,
                  () => context.go('/users/3/details'),
                  'Nested route: /users/3/details',
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Push vs Go Section
            _buildSection(
              context,
              'Push vs Go Navigation',
              'Understanding the difference between push and go',
              [
                _buildNavigationButton(
                  context,
                  'Push Profile (Stack)',
                  Icons.layers,
                  () => context.push('/profile'),
                  'Adds to navigation stack',
                ),
                _buildNavigationButton(
                  context,
                  'Go to Profile (Replace)',
                  Icons.swap_horiz,
                  () => context.go('/profile'),
                  'Replaces current route',
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Quick tips card
            Card(
              color: Colors.green.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.lightbulb, color: Colors.green.shade600),
                        const SizedBox(width: 8),
                        Text(
                          'Quick Tips',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.green.shade700,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '• Check the URL bar to see how routes change\n'
                      '• Use browser back/forward buttons\n'
                      '• Try refreshing pages to test deep linking\n'
                      '• Explore the learning guide for detailed explanations',
                      style: TextStyle(color: Colors.green.shade700),
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

  Widget _buildSection(
    BuildContext context,
    String title,
    String description,
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
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationButton(
    BuildContext context,
    String label,
    IconData icon,
    VoidCallback onPressed,
    String description,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 20),
        label: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    description,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
        style: ElevatedButton.styleFrom(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }
}
