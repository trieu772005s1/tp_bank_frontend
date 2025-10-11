import 'package:tp_bank/core/models/user_model.dart';

class AuthResponse {
  final String token;
  final User user;

  AuthResponse({required this.token, required this.user});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['token'] ?? '',
      user: User.fromJson(json['user'] ?? {}), // THÊM DEFAULT VALUE
    );
  }

  // THÊM PHƯƠNG THỨC toJson() ĐỂ HOÀN CHỈNH
  Map<String, dynamic> toJson() {
    return {'token': token, 'user': user.toJson()};
  }
}
