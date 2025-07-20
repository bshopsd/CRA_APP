import 'dart:convert';
import 'dart:typed_data';

class ImageHelper {
  static Uint8List? tryDecodeImage(String base64Str) {
    try {
      // Fix common issues with padding
      String cleaned = base64Str.trim().replaceAll(RegExp(r'\s+'), '');
      int remainder = cleaned.length % 4;
      if (remainder != 0) {
        cleaned += '=' * (4 - remainder); // Add missing padding
      }

      return base64Decode(cleaned);
    } catch (e) {
      print("Base64 decode failed: $e");
      return null;
    }
  }
}
