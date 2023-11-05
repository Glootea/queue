import 'dart:convert';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart';

import 'package:queue/secret.dart';

class Encryption {
  static final _encrypter = Encrypter(AES(Key.fromBase64(ENCRIPTION_KEY)));
  static final _iv = IV.fromBase64(ENCRIPTION_KEY.substring(0, 4));

  static String encryct(String data) {
    final output = _encrypter
        .encrypt(
          data,
          iv: _iv,
        )
        .base64;
    return output;
  }

  static String _decrypt(String data) {
    return _encrypter
        .decrypt(Encrypted(Uint8List.fromList(base64.decode(data))), iv: _iv);
  }

  static String decrypt(String data) {
    return _encrypter
        .decrypt(Encrypted(Uint8List.fromList(base64.decode(data))), iv: _iv);
  }
}