class User {
  final String id;
  final String name;
  final String phone;
  final String stk;
  final double balance;

  User({
    required this.id,
    required this.name,
    required this.phone,
    required this.stk,
    required this.balance,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      stk: json['stk'] ?? '',
      balance: (json['balance'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'stk': stk,
      'balance': balance,
    };
  }

  // THÊM PHƯƠNG THỨC copyWith - QUAN TRỌNG CHO STATE MANAGEMENT
  User copyWith({
    String? id,
    String? name,
    String? phone,
    String? stk,
    double? balance,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      stk: stk ?? this.stk,
      balance: balance ?? this.balance,
    );
  }

  // TUỲ CHỌN: THÊM PHƯƠNG THỨT toString() ĐỂ DEBUG
  @override
  String toString() {
    return 'User(id: $id, name: $name, phone: $phone, stk: $stk, balance: $balance)';
  }

  // TUỲ CHỌN: THÊM PHƯƠNG THỨC equals
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User &&
        other.id == id &&
        other.name == name &&
        other.phone == phone &&
        other.stk == stk &&
        other.balance == balance;
  }

  @override
  int get hashCode {
    return Object.hash(id, name, phone, stk, balance);
  }
}
