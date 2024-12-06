import 'dart:convert';
import 'dart:math';

BigInt modularExponentiation(BigInt keyBase, BigInt keyPrivate, BigInt keyMod) {
  return keyBase.modPow(keyPrivate, keyMod);
}

void main() {
  String adminPrivateKey = 'asdfsdfsdf';
  String userPrivateKey = 'abdfsfsdfsdf';
  String keyBaseString = 'b';
  String keyModString = 'c';

  // Mengubah key menjadi BigInt dengan cara mengubah ke UTF8 dan menjumlahkan nilai byte
  BigInt adminPrivateInt = BigInt.parse(utf8
      .encode(adminPrivateKey)
      .fold<int>(0, (previous, element) => previous + element)
      .toString());

  BigInt userPrivateInt = BigInt.parse(utf8
      .encode(userPrivateKey)
      .fold<int>(0, (previous, element) => previous + element)
      .toString());

  BigInt keyBaseInt = BigInt.parse(utf8
      .encode(keyBaseString)
      .fold<int>(0, (previous, element) => previous + element)
      .toString());

  BigInt keyModInt = BigInt.parse(utf8
      .encode(keyModString)
      .fold<int>(0, (previous, element) => previous + element)
      .toString());

  BigInt publicAdminKey =
      modularExponentiation(keyBaseInt, adminPrivateInt, keyModInt);
  BigInt publicUserKey =
      modularExponentiation(keyBaseInt, userPrivateInt, keyModInt);

  print("adminPrivateKey : $adminPrivateInt");
  print("userPrivateKey : $userPrivateInt");
  print("keyBaseInt : $keyBaseInt");
  print("keyModInt : $keyModInt");
  print("publicAdminKey : $publicAdminKey");
  print("publicUserKey : $publicUserKey");
}
