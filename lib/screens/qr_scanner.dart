import 'dart:ui';
import 'package:ai_barcode_scanner/ai_barcode_scanner.dart';
import 'package:flutter/material.dart';

class QRScannerScreen extends StatelessWidget {
  const QRScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AiBarcodeScanner(
          onDetect: (BarcodeCapture capture) {
            final code = capture.barcodes.first.rawValue;
            if (code != null) {
              Navigator.pop(context, code);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('QR: $code')));
            }
          },

          appBarBuilder: (context, controller) {
            return AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              centerTitle: true,
              title: const Text(
                "Đặt mã QR vào khung để quét tự động",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.flash_on, color: Colors.white),
                  onPressed: () => controller.toggleTorch(),
                ),
              ],
            );
          },

          galleryButtonType: GalleryButtonType.icon,
          galleryButtonText: "Chọn ảnh",
          overlayConfig: const ScannerOverlayConfig(
            scannerOverlayBackground: ScannerOverlayBackground.none,
            scannerBorder: ScannerBorder.none,
          ),
        ),

        const _TPBankOverlay(),
      ],
    );
  }
}

class _TPBankOverlay extends StatelessWidget {
  const _TPBankOverlay();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double scanBox = size.width * 0.65;

    return Stack(
      children: [
        Positioned.fill(
          child: CustomPaint(painter: _BlurBackgroundPainter(scanBox)),
        ),

        Align(
          alignment: Alignment.center,
          child: Container(
            width: scanBox,
            height: scanBox,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 3),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),

        Align(
          alignment: const Alignment(0, -0.65),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                'TP',
                style: TextStyle(
                  color: Color(0xFF6D20AF),
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                ),
              ),
              Text(
                'Bank',
                style: TextStyle(color: Color(0xFF6D20AF), fontSize: 32),
              ),
              SizedBox(width: 20),
              Text(
                'V',
                style: TextStyle(
                  color: Color(0xFFB71C1C),
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                ),
              ),
              Text(
                'IETQR',
                style: TextStyle(color: Colors.white, fontSize: 26),
              ),
            ],
          ),
        ),

        const Align(alignment: Alignment(0, 0.7), child: _PartnerBanner()),
      ],
    );
  }
}

class _BlurBackgroundPainter extends CustomPainter {
  final double scanBox;
  _BlurBackgroundPainter(this.scanBox);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final cutOutRect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: scanBox,
      height: scanBox,
    );

    final paint = Paint()
      ..imageFilter = ImageFilter.blur(sigmaX: 10, sigmaY: 10)
      ..color = Colors.black.withValues(alpha: 0.5)
      ..blendMode = BlendMode.srcOver;

    canvas.saveLayer(rect, Paint());
    canvas.drawRect(rect, paint);

    paint.blendMode = BlendMode.clear;
    canvas.drawRRect(
      RRect.fromRectAndRadius(cutOutRect, const Radius.circular(16)),
      paint,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _PartnerBanner extends StatefulWidget {
  const _PartnerBanner({super.key});
  @override
  State<_PartnerBanner> createState() => _PartnerBannerState();
}

class _PartnerBannerState extends State<_PartnerBanner>
    with SingleTickerProviderStateMixin {
  late final ScrollController _controller;
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 25))
          ..addListener(() {
            if (_controller.hasClients) {
              _controller.jumpTo(
                _animationController.value *
                    _controller.position.maxScrollExtent,
              );
            }
          })
          ..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final logos = [
      'assets/vnpay.png',
      'assets/smartpay.png',
      'assets/napas.png',
      'assets/payoo.png',
    ];

    return SizedBox(
      height: 40,
      child: ListView.separated(
        controller: _controller,
        scrollDirection: Axis.horizontal,
        itemCount: logos.length * 3,
        separatorBuilder: (_, __) => const SizedBox(width: 30),
        itemBuilder: (_, i) {
          final logo = logos[i % logos.length];
          return Image.asset(logo, height: 30);
        },
      ),
    );
  }
}
