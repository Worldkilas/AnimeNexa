import 'package:anime_nexa/shared/constants/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:giphy_flutter_sdk/dto/giphy_content_request.dart';
import 'package:giphy_flutter_sdk/dto/giphy_media_type.dart';
import 'package:giphy_flutter_sdk/giphy_grid_view.dart';

class GifScreen extends StatefulWidget {
  const GifScreen({super.key});

  @override
  State<GifScreen> createState() => _GifScreenState();
}

class _GifScreenState extends State<GifScreen> {
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          onTapOutside: (event) => FocusScope.of(context).unfocus(),
          decoration: InputDecoration(
            border: InputBorder.none,
            fillColor: Colors.white,
            hintText: "Search gif",
            hintStyle: AppTypography.textMedium.copyWith(color: Colors.grey),
          ),
          cursorHeight: 20,
          style: AppTypography.textMedium.copyWith(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: ValueListenableBuilder(
        valueListenable: _searchController,
        builder: (context, search, _) {
          return GiphyGridView(
            content: search.text.isEmpty
                ? GiphyContentRequest.trending(mediaType: GiphyMediaType.gif)
                : GiphyContentRequest.search(
                    mediaType: GiphyMediaType.gif,
                    searchQuery: search.text.trim()),
            onMediaSelect: (media) {
              Navigator.pop(context, media);
            },
          );
        },
      ),
    );
  }
}
