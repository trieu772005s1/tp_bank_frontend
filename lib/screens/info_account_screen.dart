import 'package:flutter/material.dart';
import 'package:tp_bank/core/models/user_model.dart';

class InfoAccountScreen extends StatelessWidget {
  final User user;

  const InfoAccountScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color(0xFF7E57C2);
    final Color cardColor = Colors.white;
    final Color accentColor = const Color.fromARGB(225, 184, 73, 232);

    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Color(0xFF6D32D3),
        iconTheme: const IconThemeData(
          color: Colors.white, // đổi mũi tên back thành màu trắng
        ),
        title: const Text(
          'Thông tin tài khoản',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // HEADER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    primaryColor,
                    Color.fromARGB(255, 170, 63, 203),
                    Color.fromARGB(255, 91, 18, 217),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.person, color: Colors.white, size: 40),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Số TK: ${user.stk}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Số dư: ${_formatCurrency(user.balance)} VND',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // INFO CARDS
            _buildInfoCard(
              icon: Icons.phone,
              label: 'Số điện thoại',
              value: user.phone,
              cardColor: cardColor,
              accentColor: accentColor,
            ),
            _buildInfoCard(
              icon: Icons.credit_card,
              label: 'Số tài khoản',
              value: user.stk,
              cardColor: cardColor,
              accentColor: accentColor,
            ),
            _buildInfoCard(
              icon: Icons.person,
              label: 'Họ tên',
              value: user.name,
              cardColor: cardColor,
              accentColor: accentColor,
            ),
            _buildInfoCard(
              icon: Icons.account_balance_wallet,
              label: 'Số dư',
              value: '${_formatCurrency(user.balance)} VND',
              cardColor: cardColor,
              accentColor: accentColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
    required Color cardColor,
    required Color accentColor,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: accentColor),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatCurrency(double amount) {
    return amount
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]},',
        );
  }
}
