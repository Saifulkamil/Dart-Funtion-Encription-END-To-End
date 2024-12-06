import 'dart:convert';

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

  String base64Key = convertToBase64(randomAdminKey);
  return base64Key;
}

void main() {
  String keyPrivate = "asdfsdfgdfgdfgdfgdfgdfgdfsdf";
  String keyPrivate2 = "abdfsfsdfsdfgdfgdfgdfgdfgdfgdfgdfgddf";
  
  // key mod dan base harus lebih kecil dari key private
  String keybase = "bdfgdfgdfgdfgdfgdfg";
  String keyMod = "cdfgdfgdfgddfgdfgdfg";

  String keyResult = encryptionEndToEnd(keyPrivate, keybase, keyMod);
  String keyResult2 = encryptionEndToEnd(keyPrivate2, keybase, keyMod);

  print("ini keyResutl $keyResult");
  print("ini keyResutl $keyResult2");
  
  
}
