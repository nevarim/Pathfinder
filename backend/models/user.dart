class User {
  final int id;
  final String username;
  final String email;
  final String password;
  final bool isActive;
  final bool isDebug;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
    required this.isActive,
    required this.isDebug,
  });

  // Add a toJson method to serialize the User object
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'is_active': isActive,
      'is_debug': isDebug,
    };
  }
}
