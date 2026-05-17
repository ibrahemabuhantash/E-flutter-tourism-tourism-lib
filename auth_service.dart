class AuthService {
  AuthService._privateConstructor();

  static final AuthService instance = AuthService._privateConstructor();

  String? currentUserName;
  String? currentUserEmail;
  String? currentUserPhone;

  Future<void> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 2));

    if (email.isEmpty || password.isEmpty) {
      throw Exception('يرجى إدخال البريد الإلكتروني وكلمة المرور');
    }

    // محاكاة تحقق بسيط
    if (password.length < 6) {
      throw Exception('كلمة المرور يجب أن تكون 6 أحرف على الأقل');
    }

    currentUserEmail = email;
    currentUserName = 'المستخدم';
  }

  Future<void> register(
      String name,
      String email,
      String password,
      String? phone,
      ) async {
    await Future.delayed(const Duration(seconds: 2));

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      throw Exception('يرجى تعبئة جميع الحقول المطلوبة');
    }

    if (password.length < 6) {
      throw Exception('كلمة المرور يجب أن تكون 6 أحرف على الأقل');
    }

    currentUserName = name;
    currentUserEmail = email;
    currentUserPhone = phone;
  }

  void logout() {
    currentUserName = null;
    currentUserEmail = null;
    currentUserPhone = null;
  }
}