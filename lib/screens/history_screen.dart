import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tp_bank/core/network/api_client.dart';
import 'package:tp_bank/core/network/api_constants.dart';
import 'package:tp_bank/core/models/user_model.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String? _selectedCategory;
  final String accountNumber = "0643 7082 701";
  List<Transaction> transactions = [];
  List<Transaction> filteredTransactions = [];
  bool isLoading = true;
  User? currentUser;
  String? errorMessage;
  String _selectedTimeFilter = "3 Tháng gần nhất";
  DateTime? _startDate;
  DateTime? _endDate;
  TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> categories = [
    {"name": "Ăn uống", "icon": Icons.restaurant, "color": Colors.orange},
    {"name": "Mua sắm", "icon": Icons.shopping_bag, "color": Colors.pink},
    {"name": "Giải trí", "icon": Icons.movie, "color": Colors.blueAccent},
    {"name": "Chuyển khoản", "icon": Icons.swap_horiz, "color": Colors.green},
    {"name": "Hóa đơn", "icon": Icons.receipt_long, "color": Colors.purple},
    {"name": "Khác", "icon": Icons.more_horiz, "color": Colors.grey},
  ];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    try {
      await Future.wait([
        _loadUserInfo(),
        _loadTransactionHistory(),
        _loadCategories(),
      ]);
    } catch (e) {
      setState(() {
        errorMessage = "Lỗi tải dữ liệu: $e";
        isLoading = false;
      });
    }
  }

  Future<void> _loadUserInfo() async {
    try {
      final response = await ApiClient.get(
        ApiConstants.baseUrl + ApiConstants.accountInfo,
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() => currentUser = User.fromJson(data));
      }
    } catch (e) {
      debugPrint("Load user info error: $e");
    }
  }

  Future<void> _loadTransactionHistory() async {
    try {
      final response = await ApiClient.get(
        ApiConstants.baseUrl + ApiConstants.history,
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> transactionsData = data['transactions'] ?? [];

        setState(() {
          transactions = transactionsData.map((item) {
            return Transaction(
              id: item['id'].toString(),
              date: DateTime.parse(item['date'] ?? DateTime.now().toString()),
              description: item['description'] ?? '',
              amount: (item['amount'] ?? 0).toDouble(),
              balance: (item['balance'] ?? 0).toDouble(),
              type: (item['amount'] ?? 0) >= 0 ? 'in' : 'out',
            );
          }).toList();
          filteredTransactions = List.from(transactions);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load transaction history');
      }
    } catch (e) {
      debugPrint("Load transaction history error: $e");
      _loadMockTransactions();
    }
  }

  Future<void> _loadCategories() async {
    try {
      final response = await ApiClient.get(
        ApiConstants.baseUrl + ApiConstants.categoryList,
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          categories = data.map<Map<String, dynamic>>((name) {
            return {
              "name": name,
              "icon": Icons.category,
              "color": Colors.deepPurple,
            };
          }).toList();
        });
      }
    } catch (_) {}
  }

  void _loadMockTransactions() {
    setState(() {
      transactions = [
        Transaction(
          id: "1",
          date: DateTime(2025, 10, 8),
          description: "RUT TIEN BANG QRC",
          amount: -30000000,
          balance: 2069367,
          type: "out",
        ),
        Transaction(
          id: "2",
          date: DateTime(2025, 10, 8),
          description: "NGO THI THU THUY chuyen FT25281130052080",
          amount: 80000000,
          balance: 82069367,
          type: "in",
        ),
      ];
      filteredTransactions = List.from(transactions);
      isLoading = false;
    });
  }

  void _filterTransactions() {
    String searchText = _searchController.text.toLowerCase();
    setState(() {
      filteredTransactions = searchText.isEmpty
          ? List.from(transactions)
          : transactions.where((transaction) {
              String description = transaction.description.toLowerCase();
              String amountClean = _formatCurrency(
                transaction.amount,
              ).replaceAll(RegExp(r'[^0-9\-]'), '');
              String balanceClean = _formatCurrency(
                transaction.balance,
              ).replaceAll(RegExp(r'[^0-9\-]'), '');
              return description.contains(searchText) ||
                  amountClean.contains(searchText) ||
                  balanceClean.contains(searchText);
            }).toList();
    });
  }

  void _filterByTimeRange() {
    DateTime now = DateTime.now();
    DateTime filterDate;

    switch (_selectedTimeFilter) {
      case "3 Tháng gần nhất":
        filterDate = DateTime(now.year, now.month - 3, now.day);
        break;
      case "6 Tháng gần nhất":
        filterDate = DateTime(now.year, now.month - 6, now.day);
        break;
      case "1 Năm gần nhất":
        filterDate = DateTime(now.year - 1, now.month, now.day);
        break;
      case "Tùy chỉnh":
        if (_startDate != null && _endDate != null) {
          DateTime start = DateTime(
            _startDate!.year,
            _startDate!.month,
            _startDate!.day,
          );
          DateTime end = DateTime(
            _endDate!.year,
            _endDate!.month,
            _endDate!.day,
          );
          if (start.isAfter(end)) {
            final tmp = start;
            start = end;
            end = tmp;
          }
          setState(() {
            filteredTransactions = transactions.where((t) {
              final d = DateTime(t.date.year, t.date.month, t.date.day);
              return d.isAtSameMomentAs(start) ||
                  d.isAtSameMomentAs(end) ||
                  (d.isAfter(start) &&
                      d.isBefore(end.add(const Duration(days: 1))));
            }).toList();
          });
        }
        return;
      default:
        filterDate = DateTime(now.year, now.month - 3, now.day);
    }

    setState(() {
      filteredTransactions = transactions
          .where((t) => t.date.isAfter(filterDate))
          .toList();
    });
  }

  String _formatCurrency(double amount) =>
      NumberFormat('#,###', 'vi_VN').format(amount.abs()) + ' VND';

  String _formatDate(DateTime date) {
    final vietnameseDays = {
      'Monday': 'Thứ Hai',
      'Tuesday': 'Thứ Ba',
      'Wednesday': 'Thứ Tư',
      'Thursday': 'Thứ Năm',
      'Friday': 'Thứ Sáu',
      'Saturday': 'Thứ Bảy',
      'Sunday': 'Chủ Nhật',
    };
    return '${DateFormat('dd/MM/yyyy').format(date)} - ${vietnameseDays[DateFormat('EEEE').format(date)] ?? ''}';
  }

  @override
  Widget build(BuildContext context) {
    final grouped = <String, List<Transaction>>{};
    for (final t in filteredTransactions) {
      final key = DateFormat('yyyy-MM-dd').format(t.date);
      grouped.putIfAbsent(key, () => []).add(t);
    }
    final dates = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lịch sử giao dịch'),
        backgroundColor: const Color.fromARGB(255, 109, 50, 211),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadInitialData,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
          ? _buildErrorWidget()
          : RefreshIndicator(
              onRefresh: _loadInitialData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFilterSection(),
                    const SizedBox(height: 20),
                    _buildTransactionHeader(),
                    const SizedBox(height: 20),
                    if (filteredTransactions.isEmpty)
                      const Center(
                        child: Text(
                          'Không có giao dịch nào',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    else
                      ...dates.map((k) {
                        final d = DateTime.parse(k);
                        final list = grouped[k]!;
                        return _buildDateSection(d, list);
                      }),
                  ],
                ),
              ),
            ),
    );
  }

  // =============== UI Helper Widgets ===============

  Widget _buildFilterSection() => Container(
    padding: const EdgeInsets.all(16),
    decoration: _boxDecoration(),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.search, color: Colors.grey),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Tìm kiếm giao dịch, số tiền...',
                  border: InputBorder.none,
                ),
                onChanged: (_) => _filterTransactions(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const Text('Lọc theo', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(
          children: [
            _filterButton(
              icon: Icons.calendar_today,
              text: _selectedTimeFilter,
              onTap: () => _showTimeFilter(context),
            ),
            const SizedBox(width: 8),
            _filterButton(
              icon: Icons.category,
              text: _selectedCategory ?? 'Danh mục',
              onTap: () => _showCategoryFilter(context),
            ),
          ],
        ),
      ],
    ),
  );

  BoxDecoration _boxDecoration() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.15), blurRadius: 4)],
  );

  Widget _filterButton({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 32,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: Colors.deepPurple),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  text,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Icon(Icons.arrow_drop_up, size: 18, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  // =============== Các modal ===============

  void _showTimeFilter(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => _buildTimeFilterModal(),
    );
  }

  void _showCategoryFilter(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => _buildCategoryModal(),
    );
  }

  Widget _buildTimeFilterModal() => Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Chọn thời gian tra cứu',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ...[
          '3 Tháng gần nhất',
          '6 Tháng gần nhất',
          '1 Năm gần nhất',
          'Tùy chỉnh',
        ].map(_buildTimeFilterOption),
      ],
    ),
  );

  Widget _buildTimeFilterOption(String option) {
    final isSelected = _selectedTimeFilter == option;
    return GestureDetector(
      onTap: () async {
        Navigator.pop(context); // Đóng sheet chọn thời gian cũ
        if (option == "Tùy chỉnh") {
          // Mở bottom sheet chọn khoảng ngày tùy chỉnh
          await showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            builder: (context) => _buildCustomDatePickerSheet(context),
          );
        } else {
          setState(() {
            _selectedTimeFilter = option;
            _filterByTimeRange();
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              option,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            if (isSelected)
              const Icon(Icons.check, color: Colors.blue, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomDatePickerSheet(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: StatefulBuilder(
        builder: (context, setModalState) {
          bool isValidRange =
              _startDate != null &&
              _endDate != null &&
              !_startDate!.isAfter(_endDate!);

          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Chọn khoảng thời gian',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Ngày bắt đầu
              GestureDetector(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _startDate ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    setModalState(() {
                      _startDate = picked;
                      if (_endDate != null && _startDate!.isAfter(_endDate!)) {
                        _endDate = null;
                      }
                    });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _startDate != null
                            ? DateFormat('dd/MM/yyyy').format(_startDate!)
                            : 'Chọn ngày bắt đầu',
                        style: TextStyle(
                          color: _startDate != null
                              ? Colors.black
                              : Colors.grey,
                        ),
                      ),
                      const Icon(
                        Icons.calendar_today,
                        color: Colors.deepPurple,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Ngày kết thúc
              GestureDetector(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _endDate ?? (_startDate ?? DateTime.now()),
                    firstDate: _startDate ?? DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    setModalState(() {
                      _endDate = picked;
                    });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _endDate != null
                            ? DateFormat('dd/MM/yyyy').format(_endDate!)
                            : 'Chọn ngày kết thúc',
                        style: TextStyle(
                          color: _endDate != null ? Colors.black : Colors.grey,
                        ),
                      ),
                      const Icon(
                        Icons.calendar_today,
                        color: Colors.deepPurple,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              if (_startDate != null &&
                  _endDate != null &&
                  _startDate!.isAfter(_endDate!))
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    'Ngày kết thúc phải lớn hơn hoặc bằng ngày bắt đầu.',
                    style: TextStyle(color: Colors.red[700], fontSize: 13),
                  ),
                ),

              const SizedBox(height: 8),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: isValidRange
                      ? () {
                          setState(() {
                            _selectedTimeFilter = "Tùy chỉnh";
                            _filterByTimeRange();
                          });
                          Navigator.pop(context);
                        }
                      : null,
                  child: const Text(
                    'Xác nhận',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCategoryModal() => Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Chọn danh mục',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ...categories.map(
          (c) => ListTile(
            leading: Icon(c["icon"], color: c["color"]),
            title: Text(c["name"]),
            trailing: _selectedCategory == c["name"]
                ? const Icon(Icons.check, color: Colors.deepPurple)
                : null,
            onTap: () {
              Navigator.pop(context);
              setState(() {
                _selectedCategory = c["name"];
                filteredTransactions = c["name"] == "Tất cả"
                    ? List.from(transactions)
                    : transactions
                          .where(
                            (t) => t.description.toLowerCase().contains(
                              c["name"].toLowerCase(),
                            ),
                          )
                          .toList();
              });
            },
          ),
        ),
      ],
    ),
  );
  Widget _buildTransactionHeader() => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        '${filteredTransactions.length} giao dịch',
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      ElevatedButton(
        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tính năng xuất sao kê đang được phát triển'),
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 109, 50, 211),
          foregroundColor: Colors.white,
        ),
        child: const Text('Xuất sao kê'),
      ),
    ],
  );

  Widget _buildDateSection(DateTime date, List<Transaction> list) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          _formatDate(date),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      ...list.map(_buildTransactionItem),
      const SizedBox(height: 8),
    ],
  );

  Widget _buildTransactionItem(Transaction t) {
    final searchText = _searchController.text.toLowerCase();
    final amountText =
        '${t.amount < 0 ? '-' : '+'}${_formatCurrency(t.amount)}';
    final balanceText = 'SD: ${_formatCurrency(t.balance)}';
    final amountClean = _formatCurrency(
      t.amount,
    ).replaceAll(RegExp(r'[^0-9\-]'), '');
    final balanceClean = _formatCurrency(
      t.balance,
    ).replaceAll(RegExp(r'[^0-9\-]'), '');
    final amountIndex = searchText.isNotEmpty
        ? amountClean.indexOf(searchText)
        : -1;
    final balanceIndex = searchText.isNotEmpty
        ? balanceClean.indexOf(searchText)
        : -1;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t.description,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                _buildHighlightedText(
                  balanceText,
                  balanceClean,
                  balanceIndex,
                  searchText.length,
                  isBalance: true,
                ),
              ],
            ),
          ),
          _buildHighlightedText(
            amountText,
            amountClean,
            amountIndex,
            searchText.length,
            isBalance: false,
            isNegative: t.amount < 0,
          ),
        ],
      ),
    );
  }

  Widget _buildHighlightedText(
    String original,
    String clean,
    int index,
    int len, {
    required bool isBalance,
    bool isNegative = false,
  }) {
    if (index == -1 || len == 0) {
      return Text(
        original,
        style: TextStyle(
          color: isBalance
              ? Colors.grey[600]
              : (isNegative ? Colors.red : Colors.green),
          fontWeight: isBalance ? FontWeight.normal : FontWeight.bold,
          fontSize: isBalance ? 13 : 14,
        ),
      );
    }

    final before = original.substring(0, index);
    final match = original.substring(index, index + len);
    final after = original.substring(index + len);

    return RichText(
      text: TextSpan(
        style: TextStyle(
          color: isBalance
              ? Colors.grey[600]
              : (isNegative ? Colors.red : Colors.green),
          fontWeight: isBalance ? FontWeight.normal : FontWeight.bold,
        ),
        children: [
          TextSpan(text: before),
          TextSpan(
            text: match,
            style: const TextStyle(backgroundColor: Colors.yellow),
          ),
          TextSpan(text: after),
        ],
      ),
    );
  }

  Widget _buildErrorWidget() => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.error_outline, color: Colors.red, size: 50),
        const SizedBox(height: 12),
        Text(
          errorMessage ?? "Lỗi không xác định",
          style: const TextStyle(color: Colors.red, fontSize: 16),
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: _loadInitialData,
          child: const Text("Thử lại"),
        ),
      ],
    ),
  );
}

class Transaction {
  final String id;
  final DateTime date;
  final String description;
  final double amount;
  final double balance;
  final String type;

  Transaction({
    required this.id,
    required this.date,
    required this.description,
    required this.amount,
    required this.balance,
    required this.type,
  });
}
