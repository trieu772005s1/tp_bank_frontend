import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScannerScreen extends StatelessWidget {
  const QRScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quét mã QR')),
      body: MobileScanner(
        onDetect: (barcodeCapture) {
          final barcode = barcodeCapture.barcodes.first;
          final String? code = barcode.rawValue;
          if (code != null) {
            debugPrint('QR code: $code');
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('QR: $code')));
          }
        },
      ),
    );
  }
}
