import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class PdfService {
  static Future<String> downloadAndCache(String url, String fileName) async {
    final dir = await getTemporaryDirectory();
    final filePath = '${dir.path}/$fileName';
    final file = File(filePath);

    if (await file.exists()) {
      if (await _looksLikePdf(file)) {
        return filePath;
      }
      await file.delete();
    }

    await _download(url, filePath);
    return filePath;
  }

  static Future<String> downloadToDevice(String url, String fileName) async {
    Directory? dir;
    if (Platform.isAndroid) {
      dir = await getExternalStorageDirectory();
    } else {
      dir = await getApplicationDocumentsDirectory();
    }

    if (dir == null) {
      throw Exception('Could not access a storage directory on this device.');
    }

    final filePath = '${dir.path}/$fileName';
    await _download(url, filePath);
    return filePath;
  }

  static Future<bool> _looksLikePdf(File file) async {
    if (!await file.exists()) return false;
    final length = await file.length();
    if (length < 4) return false;
    final bytes = await file.openRead(0, 4).first;
    return String.fromCharCodes(bytes) == '%PDF';
  }

  static Future<void> _download(String url, String filePath) async {
    final dio = Dio();

    final response = await dio.download(
      url,
      filePath,
      options: Options(responseType: ResponseType.bytes),
    );

    final downloaded = File(filePath);
    if (!await downloaded.exists() || await downloaded.length() == 0) {
      throw Exception('Downloaded file is empty — check the PDF URL is valid and publicly accessible.');
    }

    if (!await _looksLikePdf(downloaded)) {
      final contentType = response.headers.value('content-type') ?? 'unknown';
      await downloaded.delete();
      throw Exception(
        'The server returned "$contentType" instead of a PDF. '
      );
    }
  }
}