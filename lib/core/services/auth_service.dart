import 'package:tp_bank/core/network/api_client.dart';
import 'package:tp_bank/core/network/api_constants.dart'; // THIẾU IMPORT NÀY
import 'package:tp_bank/core/models/auth_response.dart'; // SỬA IMPORT
import 'dart:convert'; // THIẾU IMPORT NÀY

class AuthService {
  static Future<AuthResponse?> login(String phone, String password) async {
    try {
      final response = await ApiClient.post(
        ApiConstants.baseUrl + ApiConstants.login, // SỬA URL
        {'phone': phone, 'password': password},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(
          response.body,
        ); // THIẾU PARSE JSON
        return AuthResponse.fromJson(data);
      }
      return null;
    } catch (e) {
      print("Login error: $e");
      return null;
    }
  }
}
