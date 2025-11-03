import 'package:flutter/material.dart';

class CardDetailScreen extends StatefulWidget {
  final Map<String, String> card;

  const CardDetailScreen({super.key, required this.card});

  @override
  State<CardDetailScreen> createState() => _CardDetailScreenState();
}

class _CardDetailScreenState extends State<CardDetailScreen>
    with SingleTickerProviderStateMixin {
  late bool isActive;
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    isActive = widget.card['status'] == 'Đang hoạt động';

    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleCardStatus(bool value) {
    setState(() {
      isActive = value;
      widget.card['status'] = isActive ? 'Đang hoạt động' : 'Đang khóa';
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      Navigator.pop(context, widget.card);
    });
  }

  @override
  Widget build(BuildContext context) {
    final card = widget.card;

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(card['name']!, style: const TextStyle(fontSize: 16)),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Hero(
                    tag: card['name']!,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        card['image']!,
                        width: 280,
                        height: 160,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  'Tên thẻ: ${card['name']}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Số thẻ: ${card['number'] ?? '**** **** **** 0000'}',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 10),
                Text(
                  'Ngày hết hạn: ${card['expiry'] ?? 'Không có'}',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 10),
                Text(
                  'Loại thẻ: ${card['type'] ?? 'Không xác định'}',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Icon(
                      isActive ? Icons.check_circle : Icons.lock,
                      color: isActive ? Colors.green : Colors.redAccent,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Trạng thái: ${isActive ? 'Đang hoạt động' : 'Đang khóa'}',
                      style: TextStyle(
                        fontSize: 18,
                        color: isActive ? Colors.green : Colors.redAccent,
                      ),
                    ),
                    const Spacer(),
                    Switch(
                      value: isActive,
                      onChanged: _toggleCardStatus,
                      activeColor: Colors.green,
                      inactiveThumbColor: Colors.redAccent,
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                Center(
                  child: Text(
                    isActive
                        ? 'Thẻ đang mở, bạn có thể sử dụng các giao dịch.'
                        : 'Thẻ hiện đang bị khóa. Vui lòng mở để sử dụng lại.',
                    style: TextStyle(
                      color: isActive ? Colors.green : Colors.redAccent,
                      fontSize: 15,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
