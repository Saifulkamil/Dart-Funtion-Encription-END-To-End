import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart'; // Pastikan menambahkan dependensi crypto

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

  print("ini publicKeyBigInt $publicKeyBigInt");

  String randomAdminKey = "${publicKeyBigInt}";

  // Hash hasil publicKeyBigInt dengan SHA-256 untuk mendapatkan 32 byte
  List<int> hashBytes = sha256.convert(utf8.encode(randomAdminKey)).bytes;

  // Ambil 16 byte pertama dari hash yang dihasilkan
  List<int> ivBytes = hashBytes.sublist(0, 16);

  // Konversi 16 byte pertama menjadi string Base64
  String base64Key = base64.encode(ivBytes);

  return base64Key; // 16 byte = 22 karakter Base64
}

void main() {
  String keyPrivate = "asdfsdfgdfgdfgdfgdfgddfgdfgfgdfsdf";
  String keyPrivate2 = "abdfsfsdfsdfgdfgdfgdfgdfgdfgdfgdfgddf";

  // key mod dan base harus lebih kecil dari key private
  String keybase = "bdfgdfgdfgdfgdfgdfg";
  String keyMod = "cdfgdfgdfgddfgdfgdfg";

  String keyResult = encryptionEndToEnd(keyPrivate, keybase, keyMod);
  String keyResult2 = encryptionEndToEnd(keyPrivate2, keybase, keyMod);

  print("ini keyResult $keyResult");
  print("ini keyResult2 $keyResult2");
}
