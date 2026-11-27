import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';

class CompanyImageHelper {
  CompanyImageHelper._();

  static Future<Uint8List?> compressToBytes({
    required File file,
    int minWidth = 1080,
    int minHeight = 1080,
    int quality = 75,
  }) async {
    final Uint8List? result = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      minWidth: minWidth,
      minHeight: minHeight,
      quality: quality,
      format: CompressFormat.jpeg,
    );
    return result;
  }
}