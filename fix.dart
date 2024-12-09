import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';

BigInt modularExponentiation(BigInt base, BigInt exponent, BigInt modulus) {
  return base.modPow(exponent, modulus);
}

// Improved string to BigInt conversion using base64 decoding
BigInt convertKeyToBigInt(String key) {
  // Decode base64 string to bytes
  Uint8List bytes = base64.decode(key);

  // Convert bytes to BigInt
  BigInt result = BigInt.zero;
  for (int byte in bytes) {
    result = (result << 8) | BigInt.from(byte);
  }
  return result;
}

String encryptionEndToEnd(String keyPrivate, String keybase, String keyMod) {
  BigInt privateKey = convertKeyToBigInt(keyPrivate);
  BigInt base = convertKeyToBigInt(keybase);
  BigInt modulus = convertKeyToBigInt(keyMod);

  BigInt publicKey = modularExponentiation(base, privateKey, modulus);
  print("Public Key: $publicKey");
  // Hash hasil publicKeyBigInt dan keybase dengan SHA-256 untuk mendapatkan 32 byte
  List<int> hashBytes = sha256.convert(utf8.encode("$publicKey")).bytes;

  // Ambil 16 byte pertama dari hash yang dihasilkan
  List<int> ivBytes = hashBytes.sublist(0, 16);

  // Konversi 16 byte pertama menjadi string Base64
  String base64Key = base64.encode(ivBytes);
  print("ini key base64 $base64Key");

  return publicKey.toString();
}

String decryptionEndToEnd(String keyPublic, String keyPrivate, String keyMod) {
  // Convert public key from string to BigInt directly since it's already a number string
  BigInt publicKey = BigInt.parse(keyPublic);
  BigInt privateKey = convertKeyToBigInt(keyPrivate);
  BigInt modulus = convertKeyToBigInt(keyMod);

  BigInt sharedSecret = modularExponentiation(publicKey, privateKey, modulus);
  print("Shared Secret: $sharedSecret");

  List<int> hashBytes = sha256.convert(utf8.encode("$sharedSecret")).bytes;

  // Ambil 16 byte pertama dari hash yang dihasilkan
  List<int> ivBytes = hashBytes.sublist(0, 16);

  // Konversi 16 byte pertama menjadi string Base64
  String base64Key = base64.encode(ivBytes);
  print("ini key decrip $base64Key");
  return sharedSecret.toString();
}

void main() {
  var random = Random.secure();
  var privateKey1 = List<int>.generate(16, (i) => random.nextInt(256));
  var privateKey2 = List<int>.generate(16, (i) => random.nextInt(256));
  var baseKey = List<int>.generate(12, (i) => random.nextInt(256));
  var modKey = List<int>.generate(20, (i) => random.nextInt(256));

  // Convert to Base64
  String keyPrivate1 = base64.encode(privateKey1);
  String keyPrivate2 = base64.encode(privateKey2);
//   String keybase = base64.encode(baseKey);
//   String keyMod = base64.encode(modKey);

//   String keyPrivate1 = "lvnwCHfGs1IOiNKNOHsYyA==";
//   String keyPrivate2 = "QcTNWGCegj9nGBI+9anI1Q==";
  String keybase = "iTdJKCGgA+1cT0CUspLYzg==";
  String keyMod = "9Fq+eGqcxRiBJMnc+YQa8g==";

  print('Private Key 1: $keyPrivate1');
  print('Private Key 2: $keyPrivate2');
  print('Base Key: $keybase');
  print('Mod Key: $keyMod');

  // Generate public keys
  String publicKey1 = encryptionEndToEnd(keyPrivate1, keybase, keyMod);
  String publicKey2 = encryptionEndToEnd(keyPrivate2, keybase, keyMod);

  // Generate shared secrets
  String sharedSecret1 = decryptionEndToEnd(publicKey2, keyPrivate1, keyMod);
  String sharedSecret2 = decryptionEndToEnd(publicKey1, keyPrivate2, keyMod);

  // Verify if shared secrets match
  print("\nShared secrets match: ${sharedSecret1 == sharedSecret2}");
}




// import 'dart:convert';
// import 'dart:math';
// import 'dart:typed_data';
// import 'package:crypto/crypto.dart';

// // Modular Exponentiation
// BigInt modularExponentiation(BigInt base, BigInt exponent, BigInt modulus) {
//   return base.modPow(exponent, modulus);
// }

// // Convert Base64 String to BigInt
// BigInt convertKeyToBigInt(String key) {
//   Uint8List bytes = base64.decode(key);
//   BigInt result = BigInt.zero;
//   for (int byte in bytes) {
//     result = (result << 8) | BigInt.from(byte);
//   }
//   return result;
// }

// // Convert BigInt to Base64 String
// String convertBigIntToBase64(BigInt value) {
//   List<int> bytes = [];
//   while (value > BigInt.zero) {
//     bytes.insert(0, (value & BigInt.from(0xff)).toInt());
//     value = value >> 8;
//   }
//   return base64.encode(Uint8List.fromList(bytes));
// }

// // Encryption End-to-End
// String encryptionEndToEnd(String keyPrivate, String keyBase, String keyMod) {
//   BigInt privateKey = convertKeyToBigInt(keyPrivate);
//   BigInt base = convertKeyToBigInt(keyBase);
//   BigInt modulus = convertKeyToBigInt(keyMod);

//   BigInt publicKey = modularExponentiation(base, privateKey, modulus);
//   return convertBigIntToBase64(publicKey);
// }

// // Decryption End-to-End
// String decryptionEndToEnd(String keyPublic, String keyPrivate, String keyMod) {
//   BigInt publicKey = convertKeyToBigInt(keyPublic);
//   BigInt privateKey = convertKeyToBigInt(keyPrivate);
//   BigInt modulus = convertKeyToBigInt(keyMod);

//   BigInt sharedSecret = modularExponentiation(publicKey, privateKey, modulus);
//   return convertBigIntToBase64(sharedSecret);
// }

// void main() {
//   var random = Random.secure();
//   var privateKey1 = List<int>.generate(16, (i) => random.nextInt(256));
//   var privateKey2 = List<int>.generate(16, (i) => random.nextInt(256));
//   var baseKey = List<int>.generate(12, (i) => random.nextInt(256));
//   var modKey = List<int>.generate(20, (i) => random.nextInt(256));

//   // Convert to Base64
//   String keyPrivate1 = base64.encode(privateKey1);
//   String keyPrivate2 = base64.encode(privateKey2);
//   String keyBase = base64.encode(baseKey);
//   String keyMod = base64.encode(modKey);

//   print('Private Key 1: $keyPrivate1');
//   print('Private Key 2: $keyPrivate2');
//   print('Base Key: $keyBase');
//   print('Mod Key: $keyMod');

//   // Generate public keys
//   String publicKey1 = encryptionEndToEnd(keyPrivate1, keyBase, keyMod);
//   String publicKey2 = encryptionEndToEnd(keyPrivate2, keyBase, keyMod);

//   print('Public Key 1: $publicKey1');
//   print('Public Key 2: $publicKey2');

//   // Generate shared secrets
//   String sharedSecret1 = decryptionEndToEnd(publicKey2, keyPrivate1, keyMod);
//   String sharedSecret2 = decryptionEndToEnd(publicKey1, keyPrivate2, keyMod);

//   // Verify if shared secrets match
//   print('\nShared Secret 1: $sharedSecret1');
//   print('Shared Secret 2: $sharedSecret2');
//   print('\nShared secrets match: ${sharedSecret1 == sharedSecret2}');
// }

