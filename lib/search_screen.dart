import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SearchScreen extends StatefulWidget {
  final String query;
  final int page;

  const SearchScreen({required this.query, required this.page, super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.query);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search input
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Query',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _performSearch,
                ),
              ),
              onSubmitted: (_) => _performSearch(),
            ),

            const SizedBox(height: 20),

            // Current search info
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Search:',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text('Query: "${widget.query}"'),
                    Text('Page: ${widget.page}'),
                    if (widget.query.isEmpty)
                      const Text(
                        'Enter a search query above',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Search results (mock)
            if (widget.query.isNotEmpty) ...[
              Text(
                'Search Results for "${widget.query}":',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 10),

              Expanded(
                child: ListView.builder(
                  itemCount: 10, // Mock results
                  itemBuilder: (context, index) {
                    final resultIndex = (widget.page - 1) * 10 + index + 1;
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(child: Text('$resultIndex')),
                        title: Text(
                          'Result $resultIndex for "${widget.query}"',
                        ),
                        subtitle: Text(
                          'Page ${widget.page} • Result ${index + 1}',
                        ),
                        onTap: () {
                          // Navigate to user screen with the result ID
                          context.go('/user/$resultIndex');
                        },
                      ),
                    );
                  },
                ),
              ),

              // Pagination controls
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: widget.page > 1
                        ? () => _changePage(widget.page - 1)
                        : null,
                    child: const Text('Previous'),
                  ),
                  Text('Page ${widget.page}'),
                  ElevatedButton(
                    onPressed: widget.page < 5
                        ? () => _changePage(widget.page + 1)
                        : null,
                    child: const Text('Next'),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 20),

            // Quick search examples
            Text(
              'Quick Search Examples:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildQuickSearchChip('Flutter'),
                _buildQuickSearchChip('Dart'),
                _buildQuickSearchChip('GoRouter'),
                _buildQuickSearchChip('Navigation'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickSearchChip(String query) {
    return ActionChip(
      label: Text(query),
      onPressed: () {
        context.go('/search?q=$query&page=1');
      },
    );
  }

  void _performSearch() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      context.go('/search?q=$query&page=1');
    }
  }

  void _changePage(int newPage) {
    final query = widget.query;
    context.go('/search?q=$query&page=$newPage');
  }
}
