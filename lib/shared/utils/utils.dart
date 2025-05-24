//method to shorten wallet address
//e.g 3rLojDoVPUKBXnr2vybXJA3Lh3wKBxxDHx7fxJn8m3ZM to 3rLo...8m3ZM

import 'package:flutter/material.dart';

String shortenWalletAddress(String address,
    {int prefixLength = 5, int suffixLength = 3}) {
  if (address.length <= prefixLength + suffixLength) return address;

  final prefix = address.substring(0, prefixLength);
  final suffix = address.substring(address.length - suffixLength);
  return '$prefix...$suffix';
}

void utilitySnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 3),
    ),
  );
}

String timeAgo(DateTime date) {
  final now = DateTime.now();
  final diff = now.difference(date);

  if (diff.inSeconds < 60) return 'just now';
  if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
  if (diff.inHours < 24) return '${diff.inHours}h ago';
  if (diff.inDays < 7) return '${diff.inDays}d ago';
  if (diff.inDays < 30) return '${(diff.inDays / 7).floor()}w ago';
  if (diff.inDays < 365) return '${(diff.inDays / 30).floor()}mo ago';

  return '${(diff.inDays / 365).floor()}y ago';
}

String formatDuration(Duration pos, Duration dur) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  final minutes = twoDigits(pos.inMinutes.remainder(60));
  final seconds = twoDigits(pos.inSeconds.remainder(60));
  final totalMinutes = twoDigits(dur.inMinutes.remainder(60));
  final totalSeconds = twoDigits(dur.inSeconds.remainder(60));

  return '$minutes:$seconds / $totalMinutes:$totalSeconds';
}
