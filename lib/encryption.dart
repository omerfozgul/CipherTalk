import 'dart:convert';
import 'dart:typed_data';
import 'package:pointycastle/export.dart';

class EncryptionService {
  // AES şifrelemesi için kullanılacak anahtar ve IV (Initialization Vector)
  static final _key =
      Uint8List.fromList(List.generate(16, (i) => i)); // Örnek bir anahtar
  static final _iv =
      Uint8List.fromList(List.generate(16, (i) => i)); // Örnek bir IV

  // Metni AES ile şifreleme
  static String encryptAES(String plainText) {
    final cipher = _initCipher(true);
    final input = Uint8List.fromList(
        utf8.encode(plainText)); // Metni byte dizisine dönüştür
    final encrypted = cipher.process(input); // Şifreleme işlemini gerçekleştir
    return base64.encode(encrypted); // Base64 formatına dönüştür
  }

  // Şifrelenmiş metni AES ile şifresini çözme
  static String decryptAES(String encryptedText) {
    final cipher = _initCipher(false);
    final encrypted =
        base64.decode(encryptedText); // Base64'ten byte dizisine dönüştür
    final decrypted = cipher.process(encrypted); // Şifresini çöz
    return utf8.decode(decrypted); // Byte dizisini metne dönüştür
  }

  // Cipher nesnesini başlatma (şifreleme veya şifresini çözme için)
  static PaddedBlockCipher _initCipher(bool forEncryption) {
    final keyParam = KeyParameter(_key); // AES anahtarı
    final ivParam =
        ParametersWithIV(keyParam, _iv); // IV ile birlikte anahtar parametresi

    final cipher =
        PaddedBlockCipher('AES/CBC/PKCS7'); // AES, CBC modu ve PKCS7 padding
    cipher.init(forEncryption, ivParam); // Şifreleyiciyi başlat
    return cipher;
  }
}
