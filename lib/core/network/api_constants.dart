class ApiConstants {
  // BASE URL
  static const String baseUrl = "https://t8r687h7-4000.asse.devtunnels.ms";
  // verson
  static const String version = "/api/v1";

  // AUTHENTICATION (Đăng nhập / Đăng ký / Token)

  static const String auth = "$version/auth";
  static const String login = "/login";
  static const String register = "$auth/register";
  static const String logout = "$auth/logout";
  static const String refreshToken = "$auth/refresh";
  static const String forgotPassword = "$auth/forgot-password";
  static const String verifyOtp = "$auth/verify-otp";

  // ACCOUNT (Tài khoản / Thông tin người dùng)
  static const String account = "$version/account";
  static const String accountInfo = "$account/info"; // Lấy thông tin cá nhân
  static const String accountBalance = "$account/balance"; // Lấy số dư
  static const String updateAccount = "$account/update"; // Cập nhật hồ sơ
  static const String linkedCards =
      "$account/linked-cards"; // Danh sách thẻ liên kết
  static const String removeCard = "$account/remove-card"; // Hủy liên kết thẻ

  //  TRANSACTION (Chuyển tiền / Lịch sử giao dịch)

  static const String transaction = "$version/transaction";
  static const String transfer = "$transaction/transfer"; // Chuyển tiền
  static const String history = "$transaction/history"; // Lịch sử giao dịch
  static const String transactionDetail =
      "$transaction/detail"; // Chi tiết 1 giao dịch
  static const String recentReceivers =
      "$transaction/recent"; // Người nhận gần đây
  static const String categoryList =
      "$transaction/categories"; // Danh mục giao dịch

  // SAVING (Tiết kiệm / Gửi tiết kiệm)
  static const String saving = "$version/saving";
  static const String openSaving = "$saving/open"; // Mở sổ tiết kiệm
  static const String closeSaving = "$saving/close"; // Tất toán
  static const String savingList = "$saving/list"; // Danh sách sổ tiết kiệm

  //PAYMENT (Thanh toán / Hóa đơn / Dịch vụ)
  static const String payment = "$version/payment";
  static const String payBill = "$payment/pay-bill";
  static const String billHistory = "$payment/history";
  static const String mobileTopUp = "$payment/topup";
  static const String cardPayment = "$payment/card";

  //  QR SERVICES (QR code / Thanh toán / Nhận tiền)
  static const String qr = "$version/qr";
  static const String myQr = "$qr/my-qr"; // Lấy QR của người dùng
  static const String scanQr = "$qr/scan"; // Quét mã QR để chuyển tiền
  static const String qrPayment = "$qr/payment"; // Thanh toán bằng QR

  // NOTIFICATIONS (Thông báo)
  // ==============================
  static const String notification = "$version/notification";
  static const String getNotifications = "$notification/list";
  static const String markAsRead = "$notification/read";
  static const String deleteNotification = "$notification/delete";

  // BANK INFO (Ngân hàng / Chi nhánh)
  static const String bank = "$version/bank";
  static const String bankList = "$bank/list";
  static const String branchList = "$bank/branches";
  static const String exchangeRate = "$bank/exchange-rate";

  // REWARD / PROMO (Ưu đãi / Đổi quà)

  static const String reward = "$version/reward";
  static const String getRewards = "$reward/list";
  static const String redeemReward = "$reward/redeem";

  //INSURANCE (Bảo hiểm)
  static const String insurance = "$version/insurance";
  static const String listInsurance = "$insurance/list";
  static const String buyInsurance = "$insurance/buy";
  static const String insuranceDetail = "$insurance/detail";

  // SUPPORT (Hỗ trợ khách hàng)
  static const String support = "$version/support";
  static const String sendFeedback = "$support/feedback";
  static const String contact = "$support/contact";
}
