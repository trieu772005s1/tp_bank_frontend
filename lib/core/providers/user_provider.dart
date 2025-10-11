import 'package:flutter/foundation.dart';
import 'package:tp_bank/core/models/user_model.dart';

class UserProvider with ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;

  // ============ USER MANAGEMENT ============
  void setUser(User user) {
    _currentUser = user;
    notifyListeners();
  }

  void clearUser() {
    _currentUser = null;
    notifyListeners();
  }

  // ============ BALANCE MANAGEMENT ============
  void updateBalance(double newBalance) {
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(balance: newBalance);
      notifyListeners();
    }
  }

  void deductBalance(double amount) {
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(
        balance: _currentUser!.balance - amount,
      );
      notifyListeners();
    }
  }

  void addBalance(double amount) {
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(
        balance: _currentUser!.balance + amount,
      );
      notifyListeners();
    }
  }

  // ============ PROFILE MANAGEMENT ============
  void updateProfile({String? name, String? phone}) {
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(name: name, phone: phone);
      notifyListeners();
    }
  }

  void updateBankInfo({String? stk}) {
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(stk: stk);
      notifyListeners();
    }
  }

  // ============ VALIDATION METHODS ============
  bool canTransfer(double amount) {
    return _currentUser != null &&
        _currentUser!.balance >= amount &&
        amount > 0;
  }

  bool hasSufficientBalance(double amount) {
    return _currentUser != null && _currentUser!.balance >= amount;
  }

  double get availableBalance {
    return _currentUser?.balance ?? 0.0;
  }

  // ============ LOADING STATE ============
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // ============ QUICK ACCESSORS ============
  String get userId => _currentUser?.id ?? '';
  String get userName => _currentUser?.name ?? '';
  String get userPhone => _currentUser?.phone ?? '';
  String get userStk => _currentUser?.stk ?? '';
  double get userBalance => _currentUser?.balance ?? 0.0;

  // ============ UTILITY METHODS ============
  bool get isLoggedIn => _currentUser != null;

  void reloadUser(User updatedUser) {
    _currentUser = updatedUser;
    notifyListeners();
  }

  // Reset to initial state
  void reset() {
    _currentUser = null;
    _isLoading = false;
    notifyListeners();
  }
}
