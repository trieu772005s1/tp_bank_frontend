import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LinkWalletScreen extends StatefulWidget {
  String walletName;
  String walletLogo;

  LinkWalletScreen({
    super.key,
    required this.walletName,
    required this.walletLogo,
  });

  @override
  State<LinkWalletScreen> createState() => _LinkWalletScreenState();
}

class _LinkWalletScreenState extends State<LinkWalletScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final List<Map<String, String>> wallet = [
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
  @override
  void initState() {
    super.initState();
    _phoneController.addListener(() {
      setState(() {});
    });
  }

  void _showWalletSelector() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 10),
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
            'Chọn ví điện tử',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: wallet.length,
              itemBuilder: (context, index) {
                final item = wallet[index];
                return ListTile(
                  leading: Image.asset(item['logo']!, width: 36),
                  title: Text(item['name']!),
                  onTap: () {
                    setState(() {
                      widget.walletName = item['name']!;
                      widget.walletLogo = item['logo']!;
                    });
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color.fromARGB(255, 109, 50, 211),
        title: Text(
          'Thêm Liên Kết Ví',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Image.asset('assets/tpbanklogo.png', width: 40),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nguồn Tiền',
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            '06437082701',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(
                            FontAwesomeIcons.heartCircleCheck,
                            color: Color.fromARGB(255, 109, 50, 211),
                            size: 16,
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        '491,367 VND',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 29),
              child: Column(
                children: [
                  Icon(
                    FontAwesomeIcons.chevronDown,
                    size: 10,
                    color: Colors.grey,
                  ),
                  Icon(
                    FontAwesomeIcons.chevronDown,
                    size: 10,
                    color: Colors.black54,
                  ),
                  Icon(
                    FontAwesomeIcons.chevronDown,
                    size: 10,
                    color: Colors.black,
                  ),
                ],
              ),
            ),

            InkWell(
              onTap: _showWalletSelector,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Image.asset(widget.walletLogo, width: 40),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ví điện tử',
                          style: TextStyle(fontSize: 14, color: Colors.black54),
                        ),
                        SizedBox(height: 8),
                        Text(
                          widget.walletName,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 250),
                    Icon(
                      FontAwesomeIcons.chevronRight,
                      size: 18,
                      color: Color.fromARGB(255, 109, 50, 211),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Text('THÔNG TIN VÍ', style: TextStyle(fontWeight: FontWeight.w500)),
            SizedBox(height: 10),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                labelText: 'Số điện thoại liên kết ví',
                hintText: 'Nhập số điện thoại liên kết ví',
                prefixIcon: Icon(
                  FontAwesomeIcons.phone,
                  color: Color.fromARGB(255, 109, 50, 211),
                  size: 16,
                ),
                errorText: _phoneController.text.isEmpty
                    ? null
                    : (_phoneController.text.length != 10
                          ? 'Số điện thoại phải đủ 10 số'
                          : null),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 109, 50, 211),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: _phoneController.text.length == 10
              ? () {
                  final linkedWallet = {
                    'name': widget.walletName,
                    'logo': widget.walletLogo,
                    'phone': _phoneController.text,
                  };
                  Navigator.pop(context, linkedWallet);
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 109, 50, 211),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.symmetric(vertical: 16),
          ),
          child: Text(
            'Tiếp tục',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
