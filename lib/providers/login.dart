import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Login with ChangeNotifier {
  final storage = const FlutterSecureStorage();
  Future<void> storeTokenAndData(User? userCredentials) async {
    await storage.write(
        key: 'token', value: userCredentials!.getIdToken().toString());
    await storage.write(key: 'user', value: userCredentials.toString());
  }

  Future<String?> getToken() async {
    
    return await storage.read(key: 'token');
  }
}
