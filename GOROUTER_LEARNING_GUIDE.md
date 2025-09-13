# GoRouter Complete Learning Guide 🚀

A comprehensive step-by-step tutorial for mastering GoRouter in Flutter, from beginner to advanced level.

## Table of Contents
1. [What is GoRouter?](#what-is-gorouter)
2. [Basic Setup](#basic-setup)
3. [Basic Navigation](#basic-navigation)
4. [Route Parameters](#route-parameters)
5. [Query Parameters](#query-parameters)
6. [Named Routes](#named-routes)
7. [Navigation Methods](#navigation-methods)
8. [Nested Routes](#nested-routes)
9. [Shell Routes](#shell-routes)
10. [Route Guards & Redirects](#route-guards--redirects)
11. [Error Handling](#error-handling)
12. [State Management](#state-management)
13. [Advanced Features](#advanced-features)
14. [Best Practices](#best-practices)
15. [Common Patterns](#common-patterns)

---

## What is GoRouter?

**GoRouter** is a declarative routing package for Flutter that provides:
- **URL-based navigation** (important for web apps)
- **Type-safe routing** with compile-time route validation
- **Deep linking support** out of the box
- **Route guards** for authentication and authorization
- **Nested routing** for complex app structures
- **Better integration** with Flutter's Navigator 2.0

### Why choose GoRouter over Navigator?

| Feature | Navigator 1.0 | GoRouter |
|---------|---------------|----------|
| Web URL support | ❌ | ✅ |
| Deep linking | Manual setup | Built-in |
| Type safety | ❌ | ✅ |
| Route guards | Manual | Built-in |
| Nested routes | Complex | Simple |
| State management | Manual | Integrated |

---

## Basic Setup

### 1. Add Dependency

```yaml
# pubspec.yaml
dependencies:
  flutter:
    sdk: flutter
  go_router: ^16.2.1  # Latest version
```

### 2. Basic Configuration

```dart
// main.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'GoRouter Demo',
      routerConfig: _router,  // Pass the router configuration
    );
  }
}

// Define your routes
final GoRouter _router = GoRouter(
  initialLocation: '/',  // Starting route
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => HomeScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => ProfileScreen(),
    ),
  ],
);
```

### 3. Key Concepts

- **Path**: The URL pattern for the route (`/`, `/profile`, `/user/:id`)
- **Builder**: Function that returns the widget for this route
- **State**: Contains route information (parameters, query params, etc.)
- **Context**: Build context for the current route

---

## Basic Navigation

### Current Implementation Analysis
Looking at your current code, you're already using basic navigation:

```dart
// In your HomeScreen
ElevatedButton(
  onPressed: () {
    context.go('/profile');  // Navigate to profile
  },
  child: Text('Go to Profile'),
),
```

### Navigation Methods Overview

```dart
// 1. Replace current route (most common)
context.go('/profile');

// 2. Push new route (adds to stack)
context.push('/profile');

// 3. Pop current route
context.pop();

// 4. Go back to specific route
context.go('/');

// 5. Replace all routes
context.goNamed('home');
```

---

## Route Parameters

Route parameters allow you to pass data through the URL.

### 1. Path Parameters

```dart
// Route definition with parameter
GoRoute(
  path: '/user/:userId',  // :userId is a parameter
  builder: (context, state) {
    final userId = state.pathParameters['userId']!;
    return UserScreen(userId: userId);
  },
),

// Multiple parameters
GoRoute(
  path: '/user/:userId/post/:postId',
  builder: (context, state) {
    final userId = state.pathParameters['userId']!;
    final postId = state.pathParameters['postId']!;
    return PostScreen(userId: userId, postId: postId);
  },
),
```

### 2. Navigation with Parameters

```dart
// Navigate to user with ID
context.go('/user/123');

// Navigate to specific post
context.go('/user/123/post/456');
```

### 3. Example Implementation

```dart
// user_screen.dart
class UserScreen extends StatelessWidget {
  final String userId;
  
  const UserScreen({required this.userId, Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User $userId')),
      body: Center(
        child: Column(
          children: [
            Text('User ID: $userId'),
            ElevatedButton(
              onPressed: () => context.go('/user/$userId/posts'),
              child: Text('View Posts'),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## Query Parameters

Query parameters are optional parameters passed via URL query string.

### 1. Reading Query Parameters

```dart
GoRoute(
  path: '/search',
  builder: (context, state) {
    final query = state.uri.queryParameters['q'] ?? '';
    final page = int.tryParse(state.uri.queryParameters['page'] ?? '1') ?? 1;
    return SearchScreen(query: query, page: page);
  },
),
```

### 2. Navigation with Query Parameters

```dart
// Navigate with query parameters
context.go('/search?q=flutter&page=2');

// Or build programmatically
final uri = Uri(
  path: '/search',
  queryParameters: {
    'q': 'flutter',
    'page': '2',
    'category': 'mobile',
  },
);
context.go(uri.toString());
```

### 3. Example Search Screen

```dart
class SearchScreen extends StatelessWidget {
  final String query;
  final int page;
  
  const SearchScreen({
    required this.query,
    required this.page,
    Key? key,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search: $query')),
      body: Column(
        children: [
          Text('Query: $query'),
          Text('Page: $page'),
          ElevatedButton(
            onPressed: () {
              final nextPage = page + 1;
              context.go('/search?q=$query&page=$nextPage');
            },
            child: Text('Next Page'),
          ),
        ],
      ),
    );
  }
}
```

---

## Named Routes

Named routes provide a convenient way to navigate without hardcoding paths.

### 1. Define Named Routes

```dart
final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'home',  // Named route
      builder: (context, state) => HomeScreen(),
    ),
    GoRoute(
      path: '/profile',
      name: 'profile',
      builder: (context, state) => ProfileScreen(),
    ),
    GoRoute(
      path: '/user/:userId',
      name: 'user',
      builder: (context, state) {
        final userId = state.pathParameters['userId']!;
        return UserScreen(userId: userId);
      },
    ),
  ],
);
```

### 2. Navigate Using Names

```dart
// Navigate to named routes
context.goNamed('home');
context.goNamed('profile');

// Navigate with parameters
context.goNamed('user', pathParameters: {'userId': '123'});

// Navigate with query parameters
context.goNamed(
  'search',
  queryParameters: {'q': 'flutter', 'page': '1'},
);

// Push instead of go
context.pushNamed('profile');
```

### 3. Benefits of Named Routes

- **Type safety**: Compile-time checking
- **Refactoring**: Easy to change paths
- **Readability**: Clear intent
- **Maintenance**: Centralized route management

---

## Navigation Methods

Detailed overview of all navigation methods:

### 1. context.go()
Replaces the current route stack with the new route.

```dart
// Replace current route
context.go('/profile');

// With parameters
context.go('/user/123');

// With query parameters
context.go('/search?q=flutter');
```

### 2. context.push()
Adds a new route to the stack.

```dart
// Push new route
context.push('/profile');

// Push and await result
final result = await context.push('/edit-profile');
if (result == 'saved') {
  // Handle result
}
```

### 3. context.pop()
Removes the current route from the stack.

```dart
// Simple pop
context.pop();

// Pop with result
context.pop('saved');

// Pop until specific route
context.pop('/home');
```

### 4. context.replace()
Replaces the current route without changing the stack size.

```dart
// Replace current route
context.replace('/new-profile');
```

### 5. context.goNamed() / context.pushNamed()
Type-safe navigation using route names.

```dart
// Go to named route
context.goNamed('profile');

// Push named route
context.pushNamed('edit-profile');
```

### 6. Conditional Navigation

```dart
void navigateBasedOnUser(User? user) {
  if (user == null) {
    context.go('/login');
  } else if (user.isAdmin) {
    context.go('/admin');
  } else {
    context.go('/dashboard');
  }
}
```

---

## Nested Routes

Nested routes allow you to create hierarchical navigation structures.

### 1. Basic Nested Routes

```dart
final GoRouter _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => HomeScreen(),
    ),
    GoRoute(
      path: '/users',
      builder: (context, state) => UsersScreen(),
      routes: [  // Nested routes
        GoRoute(
          path: ':userId',  // Relative path: /users/:userId
          builder: (context, state) {
            final userId = state.pathParameters['userId']!;
            return UserDetailScreen(userId: userId);
          },
          routes: [
            GoRoute(
              path: 'posts',  // /users/:userId/posts
              builder: (context, state) {
                final userId = state.pathParameters['userId']!;
                return UserPostsScreen(userId: userId);
              },
            ),
          ],
        ),
      ],
    ),
  ],
);
```

### 2. Example Implementation

```dart
// users_screen.dart
class UsersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Users')),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('User ${index + 1}'),
            onTap: () => context.go('/users/${index + 1}'),
          );
        },
      ),
    );
  }
}

// user_detail_screen.dart
class UserDetailScreen extends StatelessWidget {
  final String userId;
  
  const UserDetailScreen({required this.userId});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User $userId')),
      body: Column(
        children: [
          Text('User Details for $userId'),
          ElevatedButton(
            onPressed: () => context.go('/users/$userId/posts'),
            child: Text('View Posts'),
          ),
        ],
      ),
    );
  }
}
```

### 3. Benefits of Nested Routes

- **Hierarchical structure**: Reflects app architecture
- **Shared layouts**: Common UI elements
- **Parameter inheritance**: Child routes access parent parameters
- **Better organization**: Logical grouping of related routes

---

## Shell Routes

Shell routes provide persistent UI elements across multiple routes.

### 1. Basic Shell Route

```dart
final GoRouter _router = GoRouter(
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return ScaffoldWithNavBar(child: child);  // Persistent UI
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => HomeScreen(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => ProfileScreen(),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => SettingsScreen(),
        ),
      ],
    ),
  ],
);
```

### 2. Shell Widget Implementation

```dart
class ScaffoldWithNavBar extends StatelessWidget {
  final Widget child;
  
  const ScaffoldWithNavBar({required this.child});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _getCurrentIndex(context),
        onTap: (index) => _onTap(context, index),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
  
  int _getCurrentIndex(BuildContext context) {
    final location = GoRouterState.of(context).location;
    if (location == '/') return 0;
    if (location == '/profile') return 1;
    if (location == '/settings') return 2;
    return 0;
  }
  
  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0: context.go('/'); break;
      case 1: context.go('/profile'); break;
      case 2: context.go('/settings'); break;
    }
  }
}
```

### 3. Multiple Shell Routes

```dart
final GoRouter _router = GoRouter(
  routes: [
    // Main app shell
    ShellRoute(
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(path: '/', builder: (context, state) => HomeScreen()),
        GoRoute(path: '/profile', builder: (context, state) => ProfileScreen()),
      ],
    ),
    // Admin shell
    ShellRoute(
      builder: (context, state, child) => AdminShell(child: child),
      routes: [
        GoRoute(path: '/admin', builder: (context, state) => AdminScreen()),
        GoRoute(path: '/admin/users', builder: (context, state) => AdminUsersScreen()),
      ],
    ),
  ],
);
```

---

## Route Guards & Redirects

Route guards control access to routes based on conditions.

### 1. Global Redirect

```dart
final GoRouter _router = GoRouter(
  redirect: (context, state) {
    final isLoggedIn = AuthService.isLoggedIn;
    final isLoggingIn = state.location == '/login';
    
    // Redirect to login if not authenticated
    if (!isLoggedIn && !isLoggingIn) {
      return '/login';
    }
    
    // Redirect to home if already logged in and trying to access login
    if (isLoggedIn && isLoggingIn) {
      return '/';
    }
    
    return null;  // No redirect
  },
  routes: [
    // ... routes
  ],
);
```

### 2. Route-Specific Redirect

```dart
GoRoute(
  path: '/admin',
  redirect: (context, state) {
    final user = AuthService.currentUser;
    if (user == null || !user.isAdmin) {
      return '/unauthorized';
    }
    return null;  // Allow access
  },
  builder: (context, state) => AdminScreen(),
),
```

### 3. Authentication Guard Example

```dart
class AuthService {
  static bool get isLoggedIn => _currentUser != null;
  static User? get currentUser => _currentUser;
  static User? _currentUser;
  
  static void login(User user) {
    _currentUser = user;
  }
  
  static void logout() {
    _currentUser = null;
  }
}

// Usage in router
final GoRouter _router = GoRouter(
  redirect: (context, state) {
    final isLoggedIn = AuthService.isLoggedIn;
    final isOnLoginPage = state.location == '/login';
    
    if (!isLoggedIn && !isOnLoginPage) {
      return '/login';
    }
    
    if (isLoggedIn && isOnLoginPage) {
      return '/';
    }
    
    return null;
  },
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => LoginScreen(),
    ),
    GoRoute(
      path: '/',
      builder: (context, state) => HomeScreen(),
    ),
    // Protected routes
    GoRoute(
      path: '/profile',
      builder: (context, state) => ProfileScreen(),
    ),
  ],
);
```

### 4. Role-Based Access

```dart
enum UserRole { user, admin, moderator }

class User {
  final String id;
  final String name;
  final UserRole role;
  
  User({required this.id, required this.name, required this.role});
}

// Route guard for admin routes
GoRoute(
  path: '/admin',
  redirect: (context, state) {
    final user = AuthService.currentUser;
    if (user?.role != UserRole.admin) {
      return '/unauthorized';
    }
    return null;
  },
  builder: (context, state) => AdminPanel(),
  routes: [
    GoRoute(
      path: 'users',
      builder: (context, state) => UserManagement(),
    ),
  ],
),
```

---

## Error Handling

Proper error handling ensures a smooth user experience.

### 1. Custom Error Page

```dart
final GoRouter _router = GoRouter(
  errorBuilder: (context, state) => ErrorScreen(error: state.error),
  routes: [
    // ... your routes
  ],
);

class ErrorScreen extends StatelessWidget {
  final GoException? error;
  
  const ErrorScreen({this.error});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Error')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red),
            SizedBox(height: 16),
            Text(
              'Page Not Found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 8),
            Text(error?.toString() ?? 'Unknown error occurred'),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
}
```

### 2. 404 Handling

```dart
final GoRouter _router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => HomeScreen()),
    GoRoute(path: '/profile', builder: (context, state) => ProfileScreen()),
    
    // Catch-all route for 404
    GoRoute(
      path: '/404',
      builder: (context, state) => NotFoundScreen(),
    ),
  ],
  errorBuilder: (context, state) => NotFoundScreen(),
);
```

### 3. Error Boundaries

```dart
class ErrorBoundary extends StatelessWidget {
  final Widget child;
  final Widget? errorWidget;
  
  const ErrorBoundary({
    required this.child,
    this.errorWidget,
  });
  
  @override
  Widget build(BuildContext context) {
    return ErrorWidget.builder = (FlutterErrorDetails details) {
      return errorWidget ?? ErrorScreen(error: details.exception);
    };
    return child;
  }
}

// Usage
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ErrorBoundary(
      child: MaterialApp.router(
        routerConfig: _router,
      ),
    );
  }
}
```

---

## State Management

Integrating GoRouter with state management solutions.

### 1. Using Provider

```dart
// main.dart
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _createRouter(context),
    );
  }
  
  GoRouter _createRouter(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    return GoRouter(
      refreshListenable: authProvider,  // Rebuild router when auth changes
      redirect: (context, state) {
        final isLoggedIn = authProvider.isLoggedIn;
        final isLoggingIn = state.location == '/login';
        
        if (!isLoggedIn && !isLoggingIn) return '/login';
        if (isLoggedIn && isLoggingIn) return '/';
        
        return null;
      },
      routes: [
        // ... routes
      ],
    );
  }
}
```

### 2. Using Riverpod

```dart
// providers.dart
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

final routerProvider = Provider<GoRouter>((ref) {
  final authNotifier = ref.read(authProvider.notifier);
  
  return GoRouter(
    refreshListenable: authNotifier,
    redirect: (context, state) {
      final authState = ref.read(authProvider);
      // ... redirect logic
    },
    routes: [
      // ... routes
    ],
  );
});

// main.dart
void main() {
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    
    return MaterialApp.router(
      routerConfig: router,
    );
  }
}
```

### 3. Using Bloc

```dart
class AppRouter {
  final AuthBloc _authBloc;
  late final GoRouter _router;
  
  AppRouter(this._authBloc) {
    _router = GoRouter(
      refreshListenable: GoRouterRefreshStream(_authBloc.stream),
      redirect: (context, state) {
        final authState = _authBloc.state;
        
        if (authState is AuthUnauthenticated && 
            state.location != '/login') {
          return '/login';
        }
        
        if (authState is AuthAuthenticated && 
            state.location == '/login') {
          return '/';
        }
        
        return null;
      },
      routes: [
        // ... routes
      ],
    );
  }
  
  GoRouter get router => _router;
}

// Helper class for Bloc integration
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) {
      notifyListeners();
    });
  }
  
  late final StreamSubscription _subscription;
  
  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
```

---

## Advanced Features

### 1. Custom Transitions

```dart
GoRoute(
  path: '/profile',
  pageBuilder: (context, state) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      child: ProfileScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: animation.drive(
            Tween(begin: Offset(1.0, 0.0), end: Offset.zero).chain(
              CurveTween(curve: Curves.ease),
            ),
          ),
          child: child,
        );
      },
    );
  },
),
```

### 2. Route Matching

```dart
// Custom route matching
final GoRouter _router = GoRouter(
  routes: [
    // Exact match
    GoRoute(path: '/users', builder: (context, state) => UsersScreen()),
    
    // Parameter match
    GoRoute(path: '/user/:id', builder: (context, state) => UserScreen()),
    
    // Wildcard match
    GoRoute(path: '/files/*', builder: (context, state) => FileExplorer()),
    
    // Regex match (custom implementation)
    GoRoute(
      path: '/post/:slug',
      builder: (context, state) {
        final slug = state.pathParameters['slug']!;
        if (!RegExp(r'^[a-z0-9-]+$').hasMatch(slug)) {
          throw Exception('Invalid slug format');
        }
        return PostScreen(slug: slug);
      },
    ),
  ],
);
```

### 3. Preloading Routes

```dart
class RoutePreloader {
  static void preloadRoutes(GoRouter router) {
    // Preload commonly accessed routes
    Future.delayed(Duration.zero, () {
      router.routerDelegate.setNewRoutePath('/profile');
      router.routerDelegate.setNewRoutePath('/settings');
    });
  }
}
```

### 4. Deep Link Handling

```dart
final GoRouter _router = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: true,  // Enable for debugging
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => HomeScreen(),
    ),
    GoRoute(
      path: '/share/:type/:id',
      builder: (context, state) {
        final type = state.pathParameters['type']!;
        final id = state.pathParameters['id']!;
        final from = state.uri.queryParameters['from'];
        
        return SharedContentScreen(
          type: type,
          id: id,
          source: from,
        );
      },
    ),
  ],
);

// Handle incoming deep links
class SharedContentScreen extends StatelessWidget {
  final String type;
  final String id;
  final String? source;
  
  const SharedContentScreen({
    required this.type,
    required this.id,
    this.source,
  });
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Shared $type')),
      body: Column(
        children: [
          Text('Type: $type'),
          Text('ID: $id'),
          if (source != null) Text('Source: $source'),
        ],
      ),
    );
  }
}
```

---

## Best Practices

### 1. Route Organization

```dart
// routes/app_routes.dart
class AppRoutes {
  static const home = '/';
  static const profile = '/profile';
  static const settings = '/settings';
  static const user = '/user/:id';
  static const admin = '/admin';
  
  // Route builders
  static String userRoute(String id) => '/user/$id';
  static String postRoute(String userId, String postId) => 
      '/user/$userId/post/$postId';
}

// routes/route_config.dart
final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  routes: [
    _homeRoutes,
    _userRoutes,
    _adminRoutes,
  ],
);

final List<RouteBase> _homeRoutes = [
  GoRoute(
    path: AppRoutes.home,
    name: 'home',
    builder: (context, state) => HomeScreen(),
  ),
];

final List<RouteBase> _userRoutes = [
  GoRoute(
    path: AppRoutes.profile,
    name: 'profile',
    builder: (context, state) => ProfileScreen(),
  ),
  GoRoute(
    path: AppRoutes.user,
    name: 'user',
    builder: (context, state) {
      final id = state.pathParameters['id']!;
      return UserScreen(id: id);
    },
  ),
];
```

### 2. Type-Safe Navigation

```dart
// navigation/app_navigator.dart
class AppNavigator {
  static void goHome(BuildContext context) {
    context.goNamed('home');
  }
  
  static void goToUser(BuildContext context, String userId) {
    context.goNamed('user', pathParameters: {'id': userId});
  }
  
  static Future<T?> pushProfile<T extends Object?>(BuildContext context) {
    return context.pushNamed<T>('profile');
  }
  
  static void goToSearch(
    BuildContext context, {
    required String query,
    int page = 1,
    String? category,
  }) {
    final queryParams = <String, String>{
      'q': query,
      'page': page.toString(),
    };
    
    if (category != null) {
      queryParams['category'] = category;
    }
    
    context.goNamed('search', queryParameters: queryParams);
  }
}

// Usage
AppNavigator.goToUser(context, '123');
AppNavigator.goToSearch(context, query: 'flutter', page: 2);
```

### 3. Error Handling Best Practices

```dart
// utils/route_utils.dart
class RouteUtils {
  static void safeNavigate(
    BuildContext context,
    String path, {
    Map<String, String>? queryParameters,
  }) {
    try {
      if (queryParameters != null) {
        final uri = Uri(path: path, queryParameters: queryParameters);
        context.go(uri.toString());
      } else {
        context.go(path);
      }
    } catch (e) {
      // Log error and show fallback
      debugPrint('Navigation error: $e');
      _showNavigationError(context);
    }
  }
  
  static void _showNavigationError(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Navigation failed. Please try again.'),
        action: SnackBarAction(
          label: 'Home',
          onPressed: () => context.go('/'),
        ),
      ),
    );
  }
}
```

### 4. Performance Optimization

```dart
// Lazy loading of screens
final GoRouter _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => HomeScreen(),
    ),
    GoRoute(
      path: '/heavy-screen',
      builder: (context, state) {
        // Lazy load heavy dependencies
        return FutureBuilder(
          future: _loadHeavyDependencies(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return LoadingScreen();
            }
            return HeavyScreen(data: snapshot.data);
          },
        );
      },
    ),
  ],
);

Future<HeavyData> _loadHeavyDependencies() async {
  // Load heavy resources asynchronously
  await Future.delayed(Duration(seconds: 2));
  return HeavyData();
}
```

### 5. Testing Routes

```dart
// test/routing_test.dart
void main() {
  group('GoRouter Tests', () {
    testWidgets('should navigate to profile screen', (tester) async {
      final router = GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => HomeScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => ProfileScreen(),
          ),
        ],
      );
      
      await tester.pumpWidget(
        MaterialApp.router(routerConfig: router),
      );
      
      // Find and tap the profile button
      final profileButton = find.text('Go to Profile');
      await tester.tap(profileButton);
      await tester.pumpAndSettle();
      
      // Verify we're on the profile screen
      expect(find.text('Profile Screen'), findsOneWidget);
      expect(router.routerDelegate.currentConfiguration.location, '/profile');
    });
    
    testWidgets('should handle invalid routes', (tester) async {
      final router = GoRouter(
        routes: [
          GoRoute(path: '/', builder: (context, state) => HomeScreen()),
        ],
        errorBuilder: (context, state) => ErrorScreen(),
      );
      
      // Navigate to invalid route
      router.go('/invalid-route');
      await tester.pumpAndSettle();
      
      // Should show error screen
      expect(find.byType(ErrorScreen), findsOneWidget);
    });
  });
}
```

---

## Common Patterns

### 1. Bottom Navigation with Persistent State

```dart
class MainShell extends StatefulWidget {
  final Widget child;
  const MainShell({required this.child});
  
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;
  
  static const _tabs = [
    ('/home', 'Home', Icons.home),
    ('/search', 'Search', Icons.search),
    ('/profile', 'Profile', Icons.person),
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() => _selectedIndex = index);
          context.go(_tabs[index].$1);
        },
        items: _tabs.map((tab) => BottomNavigationBarItem(
          icon: Icon(tab.$3),
          label: tab.$2,
        )).toList(),
      ),
    );
  }
}
```

### 2. Wizard/Multi-Step Flow

```dart
class WizardFlow {
  static const steps = [
    '/wizard/step1',
    '/wizard/step2',
    '/wizard/step3',
    '/wizard/complete',
  ];
  
  static String getNextStep(String currentStep) {
    final currentIndex = steps.indexOf(currentStep);
    if (currentIndex == -1 || currentIndex >= steps.length - 1) {
      return steps.last;
    }
    return steps[currentIndex + 1];
  }
  
  static String getPreviousStep(String currentStep) {
    final currentIndex = steps.indexOf(currentStep);
    if (currentIndex <= 0) {
      return steps.first;
    }
    return steps[currentIndex - 1];
  }
}

// Wizard routes
final _wizardRoutes = [
  GoRoute(
    path: '/wizard',
    redirect: (context, state) => '/wizard/step1',
  ),
  GoRoute(
    path: '/wizard/step1',
    builder: (context, state) => WizardStep1(),
  ),
  GoRoute(
    path: '/wizard/step2',
    builder: (context, state) => WizardStep2(),
  ),
  GoRoute(
    path: '/wizard/step3',
    builder: (context, state) => WizardStep3(),
  ),
  GoRoute(
    path: '/wizard/complete',
    builder: (context, state) => WizardComplete(),
  ),
];
```

### 3. Modal/Dialog Navigation

```dart
// Modal route configuration
GoRoute(
  path: '/user/:id/edit',
  parentNavigatorKey: _rootNavigatorKey,  // Show as modal
  builder: (context, state) {
    final userId = state.pathParameters['id']!;
    return EditUserModal(userId: userId);
  },
),

// Usage
void showEditUserModal(BuildContext context, String userId) {
  context.push('/user/$userId/edit');
}
```

---

## Conclusion

This guide covers everything you need to know about GoRouter, from basic setup to advanced patterns. Here's a quick recap of key concepts:

### ✅ Key Takeaways

1. **Start Simple**: Begin with basic routes and gradually add complexity
2. **Use Named Routes**: For better maintainability and type safety
3. **Handle Errors**: Always provide error screens and proper error handling
4. **Guard Routes**: Implement authentication and authorization properly
5. **Organize Routes**: Structure your routes logically and use constants
6. **Test Navigation**: Write tests for your routing logic
7. **Performance**: Use lazy loading for heavy screens
8. **State Management**: Integrate properly with your chosen state management solution

### 🚀 Next Steps

1. Start with your current basic setup
2. Add route parameters and query parameters
3. Implement authentication guards
4. Add error handling
5. Create nested routes for complex flows
6. Add shell routes for persistent UI elements
7. Optimize performance and add tests

### 📚 Additional Resources

- [GoRouter Documentation](https://pub.dev/packages/go_router)
- [Flutter Navigation 2.0](https://flutter.dev/docs/development/ui/navigation)
- [GoRouter Examples](https://github.com/flutter/packages/tree/main/packages/go_router/example)

Happy coding! 🎉
