import 'package:flutter/material.dart';
import 'package:tp_bank/core/services/auth_service.dart';
import 'package:tp_bank/core/network/api_client.dart';
import 'package:tp_bank/core/models/user_model.dart';
import 'package:tp_bank/screens/home_screen.dart'; // Import class User
// Import HomeScreen - điều chỉnh đường dẫn cho đúng

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;

  Future<void> _login() async {
    // 🔥 TẠM THỜI: TEST VỚI USER GIẢ - COMMENT LẠI SAU KHI TEST
    final testUser = User(
      id: "1",
      name: "TRẦN TUẤN TRIỆU",
      phone: "077 998 7705",
      stk: "0643 7082 701",
      balance: 1840367.0,
    );

    _navigateToHome(testUser);
    return;
    // 🔥 NHỚ COMMENT LẠI PHẦN NÀY SAU KHI TEST

    /*
  // PHẦN LOGIN THẬT - COMMENT TẠM
  if (_phoneController.text.isEmpty || _passwordController.text.isEmpty) {
    _showErrorDialog('Vui lòng nhập đầy đủ thông tin');
    return;
  }

  setState(() {
    _isLoading = true;
  });

  try {
    final authResponse = await AuthService.login(
      _phoneController.text,
      _passwordController.text,
    );

    setState(() {
      _isLoading = false;
    });

    if (authResponse != null) {
      ApiClient.setAuthToken(authResponse.token);
      _navigateToHome(authResponse.user);
    } else {
      _showErrorDialog('Đăng nhập thất bại. Vui lòng thử lại.');
    }
  } catch (e) {
    setState(() {
      _isLoading = false;
    });
    _showErrorDialog('Lỗi: $e');
  }
  */
  }

  void _navigateToHome(User user) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(user: user), // THAY HomeScreen CỦA BẠN
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Thông báo'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 109, 50, 211),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // HEADER (giữ nguyên như trước)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 109, 50, 211),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    const Text(
                      'TPBank',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Chúc bạn một ngày tốt lành',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'TRẦN TUẤN TRIỆU',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),

              // FORM ĐĂNG NHẬP
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                    bottomLeft: Radius.circular(24),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Đăng nhập',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 125, 75, 210),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Số điện thoại
                    TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: 'Số điện thoại',
                        labelStyle: TextStyle(color: Colors.grey[600]),
                        prefixIcon: Icon(Icons.phone, color: Color(0xFF7E57C2)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Color(0xFF7E57C2)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Mật khẩu
                    TextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Mật khẩu',
                        labelStyle: TextStyle(color: Colors.grey[600]),
                        prefixIcon: Icon(Icons.lock, color: Color(0xFF7E57C2)),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Color(0xFF7E57C2)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Nút đăng nhập
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 125, 75, 210),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : const Text(
                                'ĐĂNG NHẬP',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),

                    // ... (PHẦN CÒN LẠI GIỮ NGUYÊN)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
