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
