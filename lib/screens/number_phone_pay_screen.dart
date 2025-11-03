import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NumberPhonePayScreen extends StatefulWidget {
  const NumberPhonePayScreen({super.key});

  @override
  State<NumberPhonePayScreen> createState() => _NumberPhonePayScreenState();
}

class _NumberPhonePayScreenState extends State<NumberPhonePayScreen> {
  final TextEditingController _phoneController = TextEditingController();
  String? selectedNetwork;
  bool isSelected = false;
  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Lỗi'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void onContinue() {
    final phone = _phoneController.text.trim();
    // kiểm tra số điện thoại có điền chưa
    if (phone.isEmpty) {
      showErrorDialog('Vui lòng nhập số điện thoại.');
      return;
    }
    if (!RegExp(r'^\d+$').hasMatch(phone)) {
      showErrorDialog('Số điện thoại chỉ được chứa chữ số.');
      return;
    }
    if (phone.length != 10) {
      showErrorDialog('Số điện thoại không hợp lệ. Vui lòng nhập lại.');
      return;
    } else if (selectedNetwork == null) {
      showErrorDialog('Vui lòng chọn nhà mạng.');
      return;
    }
    if (selectedAmount == null) {
      showErrorDialog('Vui lòng chọn mệnh giá.');
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Số điện thoại: $phone\n'
          'Nhà mạng: $selectedNetwork\n'
          'Mệnh giá: ${selectedAmount.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (m) => '${m[1]}.')}VND',
        ),
      ),
    );
  }

  // Nếu hợp lệ, tiếp tục xử lý (ví dụ: chuyển sang màn hình chọn mệnh giá)
  final List<Map<String, String>> networks = [
    {'name': 'Viettel', 'icon': 'assets/viettel.png'},
    {'name': 'Mobifone', 'icon': 'assets/mobifone.png'},
    {'name': 'Vinaphone', 'icon': 'assets/vinaphone.png'},
    {'name': 'Vietnamobile', 'icon': 'assets/vietnamobile.png'},
    {'name': 'Wintel', 'icon': 'assets/wintel.png'},
  ];
  int? selectedAmount;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 223, 212, 241),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 223, 212, 241),
        elevation: 0,
        title: Container(
          margin: EdgeInsets.symmetric(horizontal: 80),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
          child: const Text(
            'Nạp tiền điện thoại',
            style: TextStyle(color: Colors.black, fontSize: 18),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 10,
              ),
              child: const Text(
                'Từ tài khoản',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(FontAwesomeIcons.heartCircleCheck, color: Colors.purple),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('06437082701', style: TextStyle(fontSize: 14)),
                      SizedBox(height: 4),
                      Text(
                        '326,367 VND',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Thông tin nạp tiền',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Số điện thoại',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintText: 'Nhập số điện thoại',
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                ],
              ),
            ),
            // Nhà mạng
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 20.0,
                horizontal: 20,
              ),
              child: Text('Nhà mạng', style: TextStyle(fontSize: 16)),
            ),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                ...networks.map((network) {
                  final isSelected = selectedNetwork == network['name'];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedNetwork = network['name'];
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 5,
                      ),
                      child: Container(
                        width: 100,
                        height: 60,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color.fromARGB(
                                  255,
                                  243,
                                  235,
                                  165,
                                ).withValues(alpha: 0.3)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? const Color.fromARGB(255, 244, 235, 156)
                                : Colors.grey.shade300,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 2,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: Image.asset(
                          network['icon']!,
                          width: 50,
                          height: 30,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 20.0,
                horizontal: 20,
              ),
              child: Text('Mệnh giá', style: TextStyle(fontSize: 16)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  for (var amount in [
                    30000,
                    50000,
                    100000,
                    200000,
                    300000,
                    500000,
                  ])
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedAmount = amount;
                        });
                      },
                      child: Container(
                        width: (MediaQuery.of(context).size.width - 72) / 3,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        decoration: BoxDecoration(
                          color: selectedAmount == amount
                              ? const Color.fromARGB(
                                  255,
                                  243,
                                  235,
                                  165,
                                ).withValues(alpha: 0.3)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: selectedAmount == amount
                                ? const Color.fromARGB(255, 244, 235, 156)
                                : Colors.grey.shade300,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 2,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (match) => '${match[1]}.')} VND',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Mệnh giá
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ElevatedButton(
          onPressed: onContinue,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 104, 5, 211),
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: const Text(
            'Tiếp tục',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
