class UserIdManager {
  static String? _id;

  static String? get id => _id;

  static void setId(String id) {
    _id = id;
  }
}
