import 'package:flutter/material.dart';
import 'package:go_route/home_screen.dart';
import 'package:go_route/profile_screen.dart';
import 'package:go_route/setting_screen.dart';
import 'package:go_route/user_screen.dart';
import 'package:go_route/search_screen.dart';
import 'package:go_route/error_screen.dart';
import 'package:go_route/users_list_screen.dart';
import 'package:go_route/user_details_screen.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Go Route',
      theme: ThemeData(
        appBarTheme: appBarTheme(),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }

  AppBarTheme appBarTheme() {
    return AppBarTheme(
      centerTitle: true,
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
    );
  }
}

final GoRouter router = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: true, // Enable for debugging
  // Custom error page
  errorBuilder: (context, state) => ErrorScreen(error: state.error),

  // Global redirect for demonstration (optional)
  redirect: (context, state) {
    // Example: Redirect old routes to new ones
    if (state.uri.path == '/old-profile') {
      return '/profile';
    }
    return null; // No redirect needed
  },

  routes: [
    // Home route with name
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),

    // Profile route with name
    GoRoute(
      path: '/profile',
      name: 'profile',
      builder: (context, state) => const ProfileScreen(),
    ),

    // Settings route with name
    GoRoute(
      path: '/settings',
      name: 'settings',
      builder: (context, state) => const SettingScreen(),
    ),

    // User route with path parameter
    GoRoute(
      path: '/user/:userId',
      name: 'user',
      builder: (context, state) {
        final userId = state.pathParameters['userId']!;
        return UserScreen(userId: userId);
      },
    ),

    // Search route with query parameters
    GoRoute(
      path: '/search',
      name: 'search',
      builder: (context, state) {
        final query = state.uri.queryParameters['q'] ?? '';
        final page =
            int.tryParse(state.uri.queryParameters['page'] ?? '1') ?? 1;
        return SearchScreen(query: query, page: page);
      },
    ),

    // Nested routes example
    GoRoute(
      path: '/users',
      name: 'users',
      builder: (context, state) => const UsersListScreen(),
      routes: [
        GoRoute(
          path: ':id/details',
          name: 'user-details',
          builder: (context, state) {
            final userId = state.pathParameters['id']!;
            return UserDetailsScreen(userId: userId);
          },
        ),
      ],
    ),
  ],
);
