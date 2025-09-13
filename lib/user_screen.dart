import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UserScreen extends StatelessWidget {
  final String userId;

  const UserScreen({required this.userId, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User $userId')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'User Information',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text('User ID: $userId'),
                    Text('Name: User $userId'),
                    Text('Email: user$userId@example.com'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Navigation Examples
            Text(
              'Navigation Examples:',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10),

            // Navigate to search with query parameters
            ElevatedButton(
              onPressed: () {
                context.go('/search?q=user$userId&page=1');
              },
              child: const Text('Search for this user'),
            ),

            const SizedBox(height: 8),

            // Navigate using named route
            ElevatedButton(
              onPressed: () {
                context.goNamed(
                  'search',
                  queryParameters: {'q': 'posts by user $userId', 'page': '1'},
                );
              },
              child: const Text('Search user posts (Named Route)'),
            ),

            const SizedBox(height: 8),

            // Push navigation (adds to stack)
            ElevatedButton(
              onPressed: () {
                context.push('/users/$userId/details');
              },
              child: const Text('View Detailed Profile (Push)'),
            ),

            const SizedBox(height: 8),

            // Go back home
            ElevatedButton(
              onPressed: () {
                context.goNamed('home');
              },
              child: const Text('Go Home'),
            ),

            const SizedBox(height: 20),

            // Demonstration of different user IDs
            Text(
              'Try different users:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),

            Wrap(
              spacing: 8,
              children: [
                for (int i = 1; i <= 5; i++)
                  ElevatedButton(
                    onPressed: () => context.go('/user/$i'),
                    child: Text('User $i'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
