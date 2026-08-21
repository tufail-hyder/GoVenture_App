import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class PdfService {
  static Future<String> downloadAndCache(String url, String fileName) async {
    final dir = await getTemporaryDirectory();
    final filePath = '${dir.path}/$fileName';
    final file = File(filePath);

    if (await file.exists()) {
      return filePath;
    }

    final dio = Dio();
    await dio.download(url, filePath);
    return filePath;
  }

  static Future<String> downloadToDevice(String url, String fileName) async {
    Directory? dir;
    if (Platform.isAndroid) {
      dir = Directory('/storage/emulated/0/Download');
      if (!await dir.exists()) {
        dir = await getExternalStorageDirectory();
      }
    } else {
      dir = await getApplicationDocumentsDirectory();
    }

    final filePath = '${dir!.path}/$fileName';
    final dio = Dio();
    await dio.download(url, filePath);
    return filePath;
  }
}