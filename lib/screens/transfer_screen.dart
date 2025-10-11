import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tp_bank/core/models/user_model.dart';
import 'package:tp_bank/core/network/api_client.dart';
import 'package:tp_bank/core/network/api_constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TransferScreen extends StatefulWidget {
  final User user;

  const TransferScreen({super.key, required this.user});

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  int _selectedTransferType = 0; // 0: TPBank, 1: Liên NH, 2: ATM
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  String? _accountError;
  String? _amountError;
  bool _isLoading = false;

  final List<String> _banks = [
    'TPBank',
    'Vietcombank',
    'BIDV',
    'Agribank',
    'Techcombank',
    'MB Bank',
    'ACB',
    'VPBank',
  ];
  String? _selectedBank;

  late User _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = widget.user;
    _contentController.text = '${_currentUser.name} chuyển tiền';
  }

  @override
  void dispose() {
    _accountController.dispose();
    _amountController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  // ===== Validation =====
  bool _isValidPhoneNumber(String phone) =>
      RegExp(r'^[0-9]{10}$').hasMatch(phone);
  bool _isValidTPBankAccount(String account) =>
      RegExp(r'^[0-9]{11}$').hasMatch(account);
  bool _isValidAccountNumber(String account) =>
      RegExp(r'^[0-9]{8,15}$').hasMatch(account);
  bool _isValidATMCard(String card) => RegExp(r'^[0-9]{10}$').hasMatch(card);
  String? _validateAccountInput(String input, int transferType) {
    if (input.isEmpty) return 'Vui lòng nhập thông tin người nhận';
    switch (transferType) {
      case 0: // Trong TPBank
        if (!_isValidPhoneNumber(input) && !_isValidTPBankAccount(input)) {
          return 'SĐT phải 10 số hoặc STK phải 11 số';
        }
        break;
      case 1: // Liên Ngân Hàng
        if (!_isValidAccountNumber(input)) {
          return 'Số tài khoản phải từ 8-15 số';
        }
        break;
      case 2: // ATM
        if (!_isValidATMCard(input)) {
          return 'Số thẻ ATM phải 10 số';
        }
        break;
    }
    return null;
  }

  String? _validateAmount(String value) {
    if (value.isEmpty) return 'Vui lòng nhập số tiền';
    final clean = value.replaceAll(',', '');
    final amount = double.tryParse(clean);
    if (amount == null || amount <= 0) return 'Số tiền không hợp lệ';
    if (amount < 1000) return 'Số tiền tối thiểu 1,000 VND';
    if (amount > _currentUser.balance) return 'Số dư không đủ';
    return null;
  }

  // ===== API call =====
  Future<void> _callTransferAPI(double amount) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.baseUrl + ApiConstants.transfer),
        headers: {
          'Authorization': 'Bearer ${ApiClient.getToken()}',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'fromAccount': _currentUser.stk,
          'toAccount': _accountController.text.trim(),
          'amount': amount,
          'content': _contentController.text,
          'bank': _selectedBank,
          'transferType': _selectedTransferType,
          'currency': 'VND',
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          // Update balance immutable
          setState(() {
            _currentUser = _currentUser.copyWith(
              balance: _currentUser.balance - amount,
            );
          });
          _showSuccessDialog(amount);
          _clearForm();
        } else {
          _showErrorDialog(data['message'] ?? 'Chuyển tiền thất bại');
        }
      } else if (response.statusCode == 400) {
        _showErrorDialog('Thông tin chuyển tiền không hợp lệ');
      } else if (response.statusCode == 401) {
        _showErrorDialog('Phiên đăng nhập hết hạn');
      } else if (response.statusCode == 403) {
        _showErrorDialog('Số dư không đủ để thực hiện giao dịch');
      } else {
        _showErrorDialog('Lỗi server: ${response.statusCode}');
      }
    } catch (e) {
      _showErrorDialog('Lỗi kết nối: $e');
    }
  }

  // ===== Transfer =====
  void _transferMoney() {
    FocusScope.of(context).unfocus();

    final accountError = _validateAccountInput(
      _accountController.text.trim(),
      _selectedTransferType,
    );
    final amountError = _validateAmount(_amountController.text);

    setState(() {
      _accountError = accountError;
      _amountError = amountError;
    });

    if (accountError != null || amountError != null) return;

    if (_selectedTransferType == 1 && _selectedBank == null) {
      _showErrorDialog('Vui lòng chọn ngân hàng');
      return;
    }

    final amount = double.parse(
      _amountController.text.replaceAll(',', '').trim(),
    );
    _showConfirmDialog(amount);
  }

  // ===== Dialogs =====
  void _showConfirmDialog(double amount) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.help_outline, color: Color(0xFF6A1B9A)),
            SizedBox(width: 8),
            Text(
              'Xác nhận giao dịch',
              style: TextStyle(color: Color(0xFF6A1B9A)),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildConfirmRow('Người nhận', _accountController.text),
            if (_selectedBank != null)
              _buildConfirmRow('Ngân hàng', _selectedBank!),
            _buildConfirmRow('Số tiền', '${_formatCurrency(amount)} VND'),
            _buildConfirmRow('Nội dung', _contentController.text),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('HỦY', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: _isLoading
                ? null
                : () async {
                    Navigator.pop(context);
                    setState(() => _isLoading = true);
                    await _callTransferAPI(amount);
                    setState(() => _isLoading = false);
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF6A1B9A),
              foregroundColor: Colors.white,
            ),
            child: Text('XÁC NHẬN'),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(double amount) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 64),
              const SizedBox(height: 16),
              const Text(
                'Giao dịch thành công!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSuccessRow(
                      'Số tiền:',
                      '${_amountController.text} VND',
                      Colors.green,
                    ),
                    const SizedBox(height: 8),
                    _buildSuccessRow(
                      'Tới:',
                      _accountController.text,
                      Colors.black87,
                    ),
                    const SizedBox(height: 8),
                    _buildSuccessRow(
                      'Nội dung:',
                      _contentController.text,
                      Colors.black87,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF6A1B9A),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('HOÀN TẤT', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red),
            SizedBox(width: 8),
            Text('Lỗi giao dịch', style: TextStyle(color: Colors.red)),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('ĐÃ HIỂU', style: TextStyle(color: Color(0xFF6A1B9A))),
          ),
        ],
      ),
    );
  }

  // ===== Utils =====
  String _formatCurrency(double amount) {
    return amount
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]},',
        );
  }

  void _clearForm() {
    _accountController.clear();
    _amountController.clear();
    _contentController.text = '${_currentUser.name} chuyển tiền';
    _selectedBank = null;
    setState(() {
      _accountError = null;
      _amountError = null;
    });
  }

  // ===== UI =====
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          'Chuyển tiền',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Color(0xFF6D32D3),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            onPressed: _clearForm,
            icon: Icon(Icons.refresh, color: Colors.white),
          ),
        ],
      ),
      body: _isLoading
          ? _buildLoadingScreen()
          : SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAccountInfoCard(),
                  SizedBox(height: 24),
                  _buildTransferTypeSection(),
                  SizedBox(height: 24),
                  _buildTransferForm(),
                  SizedBox(height: 24),
                  _buildScheduleButton(),
                  SizedBox(height: 16),
                  _buildTransferButton(),
                ],
              ),
            ),
    );
  }

  Widget _buildLoadingScreen() =>
      Center(child: CircularProgressIndicator(color: Color(0xFF6D32D3)));

  // Các widget nhỏ giữ nguyên, chỉ cần thêm inline error text dưới TextField
  Widget _buildAccountField() {
    String labelText = '';
    String hintText = '';

    switch (_selectedTransferType) {
      case 0:
        labelText = 'Số tài khoản hoặc số điện thoại';
        hintText = 'Nhập 10 số điện thoại hoặc 8-15 số tài khoản';
        break;
      case 1:
        labelText = 'Số tài khoản người nhận';
        hintText = 'Nhập 8-15 số tài khoản người nhận';
        break;
      case 2:
        labelText = 'Số thẻ ATM người nhận';
        hintText = 'Nhập 10 số thẻ ATM người nhận';
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(labelText, style: TextStyle(fontWeight: FontWeight.w500)),
        SizedBox(height: 8),
        TextField(
          controller: _accountController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: hintText,
            filled: true,
            fillColor: Colors.grey[50],
            errorText: _accountError,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }

  Widget _buildAmountField() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Số tiền', style: TextStyle(fontWeight: FontWeight.w500)),
      SizedBox(height: 8),
      TextField(
        controller: _amountController,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
          hintText: 'Nhập số tiền',
          suffixText: 'VND',
          filled: true,
          fillColor: Colors.grey[50],
          errorText: _amountError,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onChanged: (value) {
          final clean = value.replaceAll(',', '');
          final num = int.tryParse(clean);
          if (num != null) {
            final formatted = _formatCurrency(num.toDouble());
            _amountController.value = TextEditingValue(
              text: formatted,
              selection: TextSelection.collapsed(offset: formatted.length),
            );
          }
        },
      ),
    ],
  );
  Widget _buildTransferButton() => SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: _isLoading ? null : _transferMoney,
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF6D32D3),
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(
        'CHUYỂN TIỀN NGAY',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ),
  );

  Widget _buildConfirmRow(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      children: [
        Expanded(flex: 2, child: Text('$label:')),
        Expanded(
          flex: 3,
          child: Text(value, style: TextStyle(color: Colors.grey[700])),
        ),
      ],
    ),
  );

  Widget _buildSuccessRow(String label, String value, Color color) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(label, style: TextStyle(fontWeight: FontWeight.w500)),
        ),
        Expanded(
          flex: 3,
          child: Text(value, style: TextStyle(color: color)),
        ),
      ],
    ),
  );

  Widget _buildAccountInfoCard() => Container(
    width: double.infinity,
    padding: EdgeInsets.all(20),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [Color(0xFF7D4BD2), Color(0xFF6D32D3)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(color: Colors.purple.withOpacity(0.3), blurRadius: 10),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'STK: 06437082701', // hiển thị STK trên số dư
          style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 8),
        Text(
          'Số dư khả dụng: ${_formatCurrency(_currentUser.balance)} VND',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );

  Widget _buildTransferTypeSection() {
    return Row(
      children: [
        _buildTransferTypeButton(0, 'Trong TPBank', Icons.account_balance),
        SizedBox(width: 12),
        _buildTransferTypeButton(1, 'Liên Ngân Hàng', Icons.swap_horiz),
        SizedBox(width: 12),
        _buildTransferTypeButton(2, 'Qua Thẻ ATM', Icons.credit_card),
      ],
    );
  }

  Widget _buildTransferTypeButton(int type, String text, IconData icon) {
    final isSelected = _selectedTransferType == type;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTransferType = type),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Color(0xFF6D32D3) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? Color(0xFF6D32D3) : Colors.grey[300]!,
              width: 1.2,
            ),
          ),
          child: Column(
            children: [
              Icon(icon, color: isSelected ? Colors.white : Colors.grey[600]),
              SizedBox(height: 4),
              Text(
                text,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey[800],
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransferForm() => Column(
    children: [
      _buildAccountField(),
      if (_selectedTransferType == 1)
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[50],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            hint: Text('Chọn ngân hàng'),
            value: _selectedBank,
            items: _banks
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (v) => setState(() => _selectedBank = v),
          ),
        ),
      SizedBox(height: 16),
      _buildAmountField(),
      SizedBox(height: 16),
      TextField(
        controller: _contentController,
        decoration: InputDecoration(
          labelText: 'Nội dung chuyển tiền',
          filled: true,
          fillColor: Colors.grey[50],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    ],
  );

  Widget _buildScheduleButton() => SizedBox(
    width: double.infinity,
    child: OutlinedButton.icon(
      onPressed: () {},
      icon: Icon(Icons.schedule, color: Color(0xFF6D32D3)),
      label: Text(
        'Lên lịch chuyển tiền',
        style: TextStyle(color: Color(0xFF6D32D3)),
      ),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: Color(0xFF6D32D3)),
        padding: EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
  );
}
