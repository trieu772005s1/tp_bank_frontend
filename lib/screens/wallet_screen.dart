import 'package:flutter/material.dart';
import 'package:tp_bank/screens/link_wallet_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  bool _isLoading = true;
  final List<Map<String, String>> _linkedWallets = [];
  Future<void> _saveLinkedWallets() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = jsonEncode(_linkedWallets);
    await prefs.setString('linked_wallets', jsonList);
  }

  Future<void> _loadLinkedWallets() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('linked_wallets');
    if (jsonString != null) {
      final List<dynamic> decoded = jsonDecode(jsonString);

      _linkedWallets.clear();
      _linkedWallets.addAll(decoded.map((e) => Map<String, String>.from(e)));
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadLinkedWallets();
  }

  void _showWalletOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        final wallet = [
          {'name': 'Momo', 'logo': 'assets/momo.png'},
          {'name': 'ZaloPay', 'logo': 'assets/zalo.png'},
          {'name': 'FPTPay', 'logo': 'assets/fpt.png'},
          {'name': 'GHTKPay', 'logo': 'assets/ghtk.png'},
          {'name': 'Payoo', 'logo': 'assets/payoo.png'},
          {'name': 'ShopeePay', 'logo': 'assets/shopeepay.png'},
          {'name': 'Payme', 'logo': 'assets/payme.png'},
          {'name': 'VNPay', 'logo': 'assets/vnpay.png'},
          {'name': 'SenPay', 'logo': 'assets/senpay.png'},
          {'name': 'VNPT', 'logo': 'assets/vnpt.png'},
          {'name': 'VTCPay', 'logo': 'assets/vtc.png'},
        ];
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          builder: (_, scrollController) => Column(
            children: [
              SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Chọn ví điện tử để liên kết',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: wallet.length,
                  itemBuilder: (context, index) {
                    final item = wallet[index];
                    return ListTile(
                      leading: Image.asset(item['logo']!, width: 36),
                      title: Text(
                        item['name']!,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onTap: () async {
                        Navigator.pop(context);
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LinkWalletScreen(
                              walletName: item['name']!,
                              walletLogo: item['logo']!,
                            ),
                          ),
                        );
                        if (result != null && mounted) {
                          setState(() {
                            _linkedWallets.add(result);
                          });
                          _saveLinkedWallets();
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ví điện tử',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        backgroundColor: const Color(0xFF6D32D3),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _linkedWallets.isEmpty
                  ? Center(
                      child: Text(
                        'Chưa có ví nào được liên kết',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView(
                      children: _linkedWallets
                          .map(
                            (wallet) => Card(
                              elevation: 0,
                              color: Colors.grey[100],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                leading: Image.asset(
                                  wallet['logo']!,
                                  width: 50,
                                  height: 50,
                                ),
                                title: Text(
                                  wallet['name']!,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(wallet['phone']!),
                              ),
                            ),
                          )
                          .toList(),
                    ),
            ),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6D32D3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () => _showWalletOptions(context),
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text(
                  'Thêm liên kết ví điện tử',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
