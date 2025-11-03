import 'package:flutter/material.dart';

class Add2in1CardScreen extends StatefulWidget {
  const Add2in1CardScreen({super.key});

  @override
  State<Add2in1CardScreen> createState() => _Add2in1CardScreenState();
}

class _Add2in1CardScreenState extends State<Add2in1CardScreen> {
  int? _selectedIndex;

  // Danh sách thẻ: hình, tên và giá
  final List<Map<String, String>> cards = [
    {
      'image': 'assets/ca_2in1_card.png',
      'name': 'Thẻ Cá Chép Phát Tài',
      'price': 'Phí phát hành: 99.000đ',
    },
    {
      'image': 'assets/meo_2in1_card.png',
      'name': 'Thẻ Mèo May Mắn',
      'price': 'Miễn phí phát hành',
    },
    {
      'image': 'assets/rong_2in1_card.png',
      'name': 'Thẻ Rồng Vàng Thịnh Vượng',
      'price': 'Phí phát hành: 129.000đ',
    },
  ];

  void _addSelectedCard() {
    if (_selectedIndex == null) return;

    final selected = cards[_selectedIndex!];

    final newCard = {
      'name': selected['name']!,
      'status': 'Đang hoạt động',
      'image': selected['image']!,
      'type': '2in1',
    };

    Navigator.pop(context, newCard);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: false,
        title: const Text(
          'Bộ Sưu Tập Thẻ Flash 2In1',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                itemCount: cards.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  childAspectRatio: 0.68,
                ),
                itemBuilder: (context, index) {
                  final card = cards[index];
                  final isSelected = _selectedIndex == index;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                    child: Column(
                      children: [
                        Expanded(
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFF6D32D3)
                                    : Colors.transparent,
                                width: 3,
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: Colors.purple.withValues(
                                          alpha: 0.3,
                                        ),
                                        blurRadius: 6,
                                        offset: const Offset(0, 3),
                                      ),
                                    ]
                                  : [],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.asset(
                                card['image']!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          card['name']!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          card['price']!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _selectedIndex != null ? _addSelectedCard : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6D32D3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Thêm thẻ',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
