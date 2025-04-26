// Reusable Search Bar widget
import 'package:flutter/material.dart';

import '../constants/app_typography.dart';

class ReusableSearchBar extends StatefulWidget {
  final String hintText;
  final void Function(String) onSearchSubmitted;

  const ReusableSearchBar({
    super.key,
    this.hintText = 'Search',
    required this.onSearchSubmitted,
  });

  @override
  State<ReusableSearchBar> createState() => _ReusableSearchBarState();
}

class _ReusableSearchBarState extends State<ReusableSearchBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.grey),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _controller,
              style: AppTypography.linkXSmall.copyWith(fontSize: 14),
              decoration: InputDecoration(
                hintText: widget.hintText,
                border: InputBorder.none,
                hintStyle:
                    AppTypography.textMedium.copyWith(color: Colors.grey),
              ),
              onSubmitted: (value) {
                widget.onSearchSubmitted(value);
              },
              onChanged: (value) {
                setState(() {}); // Update UI to show/hide clear button
              },
            ),
          ),
          if (_controller.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear, color: Colors.grey),
              onPressed: () {
                _controller.clear();
                setState(() {});
              },
            ),
        ],
      ),
    );
  }
}
