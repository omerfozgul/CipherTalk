import 'dart:io';
import 'dart:convert';
import 'package:flash_chat/encryption.dart'; // EncryptionService sınıfınızın bulunduğu dosya

class LocalStorage {
  final String user;
  File? _file;

  LocalStorage({required this.user});

  // Yerel dosya yolunu al
  Future<String> get _localPath async {
    final directory =
        await Directory.systemTemp.createTemp(); // Geçici bir klasör oluştur
    return directory.path;
  }

  // Yerel dosyayı al (veya oluştur)
  Future<File> get _localFile async {
    final path = await _localPath;
    _file ??= File('$path/chat_${user}.json');
    return _file!;
  }

  // Chat verilerini yükle ve şifresini çöz
  Future<List<Map<String, String>>> loadChat() async {
    try {
      final file = await _localFile;
      if (await file.exists()) {
        final contents = await file.readAsString();
        final decryptedContents =
            EncryptionService.decryptAES(contents); // Şifresini çöz
        final List<dynamic> jsonData = jsonDecode(decryptedContents);
        return jsonData.map((item) => Map<String, String>.from(item)).toList();
      }
    } catch (e) {
      print('An error occurred while reading from the file: $e');
    }
    return [];
  }

  // Chat verilerini şifrele ve kaydet
  Future<void> saveChat(List<Map<String, String>> chat) async {
    try {
      final file = await _localFile;
      final String contents = jsonEncode(chat);
      final encryptedContents =
          EncryptionService.encryptAES(contents); // Şifrele
      await file.writeAsString(encryptedContents);
    } catch (e) {
      print('An error occurred while saving to the file: $e');
    }
  }
}
