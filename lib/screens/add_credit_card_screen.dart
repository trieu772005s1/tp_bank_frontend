import 'package:flutter/material.dart';

class AddCreditCardScreen extends StatefulWidget {
  const AddCreditCardScreen({super.key});

  @override
  State<AddCreditCardScreen> createState() => _AddCreditCardScreenState();
}

class _AddCreditCardScreenState extends State<AddCreditCardScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _creditCards = [
    {
      'image': 'assets/credit_card_2.png',
      'badge': 'Thẻ Ẩm thực hời nhất!',
      'name': 'JCB CASHBACK',
      'features': [
        {'icon': Icons.flight, 'text': 'Đặc quyền sân bay, khách sạn'},
        {'icon': Icons.restaurant, 'text': 'Hoàn tới 12 triệu/năm cho ẩm thực'},
        {'icon': Icons.percent, 'text': 'Trả góp 0% mọi giao dịch'},
      ],
    },
    {
      'image': 'assets/credit_card_1.png',
      'badge': 'Thẻ giải trí HOT nhất!',
      'name': 'TPBANK MASTERCARD FEST',
      'features': [
        {'icon': Icons.music_note, 'text': 'Ưu đãi mua vé Concert'},
        {
          'icon': Icons.airplanemode_active,
          'text': 'Ưu đãi vé máy bay, khách sạn đi "Du Idol"',
        },
        {'icon': Icons.movie, 'text': 'Ưu đãi xem phim quanh năm'},
      ],
    },
  ];

  void _getCard(Map<String, dynamic> card) {
    final newCard = {
      'name': card['name'],
      'status': 'Đang hoạt động',
      'image': card['image'],
      'type': 'Thẻ tín dụng',
    };

    Navigator.pop(context, newCard);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) => setState(() => _currentPage = index),
              itemCount: _creditCards.length,
              itemBuilder: (context, index) {
                final card = _creditCards[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 25),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.asset(
                                card['image'],
                                width: 300,
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.orange[100],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                card['badge'],
                                style: const TextStyle(
                                  color: Colors.deepOrange,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        card['name'],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.deepPurple,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: card['features'].map<Widget>((f) {
                          return Column(
                            children: [
                              Icon(f['icon'], color: Colors.deepPurple),
                              const SizedBox(height: 6),
                              SizedBox(
                                width: 90,
                                child: Text(
                                  f['text'],
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: ElevatedButton(
                            onPressed: () => _getCard(card),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6D32D3),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: const Text(
                              'Nhận Thẻ ngay',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Xem biểu phí ?',
                          style: TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          _creditCards.length,
                          (i) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: i == _currentPage
                                  ? Colors.deepPurple
                                  : Colors.grey[400],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
