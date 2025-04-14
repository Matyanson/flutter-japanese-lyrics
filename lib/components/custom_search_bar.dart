import 'package:flutter/material.dart';

class CustomSearchBar extends StatefulWidget {
  const CustomSearchBar({super.key});

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  final _controller = TextEditingController();

  void _onSearch() {
    final query = _controller.text.trim();
    if (query.isNotEmpty) {
      print('Searching for: $query'); // zatím jen logujeme
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: 'Hledat písničku',
              border: OutlineInputBorder(),
            ),
            onSubmitted: (_) => _onSearch(),
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: _onSearch,
          child: const Text('Hledat'),
        ),
      ],
    );
  }
}
