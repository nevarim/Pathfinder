class Class {
  final int id;
  final String name;
  final bool isActive;

  Class({required this.id, required this.name, required this.isActive});

  factory Class.fromJson(Map<String, dynamic> json) {
    return Class(
      id: json['id'],
      name: json['name'],
      isActive: json['is_active'] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'is_active': isActive ? 1 : 0,
    };
  }
}
