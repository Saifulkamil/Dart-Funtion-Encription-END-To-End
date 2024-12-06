import 'dart:convert';
import 'package:crypto/crypto.dart';

BigInt modularExponentiation(BigInt keyBase, BigInt keyPrivate, BigInt keyMod) {
  return keyBase.modPow(keyPrivate, keyMod);
}

String convertToBase64(String input) {
  List<int> bytes = utf8.encode(input); // Mengubah string menjadi bytes
  return base64.encode(bytes); // Mengubah bytes menjadi Base64
}

// Mengubah key menjadi BigInt dengan cara mengubah ke UTF8 dan menjumlahkan nilai byte
BigInt convertKeyToBigInt(String keyPrivate) {
  BigInt key = BigInt.parse(utf8
      .encode(keyPrivate)
      .fold<int>(0, (previous, element) => previous + element)
      .toString());
  return key;
}

String encryptionEndToEnd(String keyPrivate, String keybase, String keyMod) {
  BigInt keyPrivateConvert = convertKeyToBigInt(keyPrivate);
  BigInt keybaseConvert = convertKeyToBigInt(keybase);
  BigInt keyModConvert = convertKeyToBigInt(keyMod);

  BigInt publicKeyBigInt =
      modularExponentiation(keybaseConvert, keyPrivateConvert, keyModConvert);

  print("ini publicKeyBigIntfd $publicKeyBigInt");
  print("ini hashBytesdf $publicKeyBigInt");

  String randomAdminKey = "${publicKeyBigInt}";

  // Hash hasil publicKeyBigInt dan keybase dengan SHA-256 untuk mendapatkan 32 byte
  List<int> hashBytes = sha256.convert(utf8.encode("$publicKeyBigInt")).bytes;

  // Ambil 16 byte pertama dari hash yang dihasilkan
  List<int> ivBytes = hashBytes.sublist(0, 16);

  // Konversi 16 byte pertama menjadi string Base64
  String base64Key = base64.encode(ivBytes);

  return base64Key; // 16 byte = 22 karakter Base64
}

void main() {
  String keyPrivate = "175jIbPZQIIt0ZW8yGzKQQ==";
  String keyPrivate2 = "lrspOqozDvMH7gBESLkrdQ==";

  // key mod dan base harus lebih kecil dari key private
  String keybase = "JtIoZSoS0Wz5WHyg==";
  String keyMod = "JtIoZj8TqIWSoS0Wz5WHyg==";

  String keyResult = encryptionEndToEnd(keyPrivate, keybase, keyMod);
  String keyResult2 = encryptionEndToEnd(keyPrivate2, keybase, keyMod);

  print("ini keyResutl $keyResult");
  print("ini keyResutl $keyResult2");
}
