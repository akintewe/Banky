class UserTokenManager {
  static String? _token;

  static String? get token => _token;

  static void setToken(String token) {
    _token = token;
  }
}
