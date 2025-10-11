import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiClient {
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
  };
  static String getToken() {
    return _authToken ?? '';
  }

  static String? _authToken;
  static void setAuthToken(String token) => _authToken = token;
  static void clearAuthToken() => _authToken = null;

  static Map<String, String> _mergeHeaders(Map<String, String>? headers) {
    final Map<String, String> h = {...defaultHeaders};
    if (_authToken != null) {
      h['Authorization'] = 'Bearer $_authToken';
    }
    if (headers != null) h.addAll(headers);
    return h;
  }

  static Future<http.Response> post(
    String url,
    Map<String, dynamic> body, {
    Map<String, String>? headers,
  }) async {
    final uri = Uri.parse(url);
    try {
      final response = await http
          .post(uri, headers: _mergeHeaders(headers), body: jsonEncode(body))
          .timeout(const Duration(seconds: 15));
      return response;
    } on SocketException {
      throw Exception('Không có kết nối mạng');
    } on HttpException {
      throw Exception('Lỗi HTTP');
    } on FormatException {
      throw Exception('Dữ liệu trả về không hợp lệ');
    } on Exception {
      rethrow;
    }
  }

  static Future<http.Response> get(
    String url, {
    Map<String, String>? headers,
  }) async {
    final uri = Uri.parse(url);
    try {
      final response = await http
          .get(uri, headers: _mergeHeaders(headers))
          .timeout(const Duration(seconds: 15));
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // THÊM PHƯƠNG THỨC PUT VÀ DELETE ĐỂ HOÀN CHỈNH
  static Future<http.Response> put(
    String url,
    Map<String, dynamic> body, {
    Map<String, String>? headers,
  }) async {
    final uri = Uri.parse(url);
    try {
      final response = await http
          .put(uri, headers: _mergeHeaders(headers), body: jsonEncode(body))
          .timeout(const Duration(seconds: 15));
      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future<http.Response> delete(
    String url, {
    Map<String, String>? headers,
  }) async {
    final uri = Uri.parse(url);
    try {
      final response = await http
          .delete(uri, headers: _mergeHeaders(headers))
          .timeout(const Duration(seconds: 15));
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
