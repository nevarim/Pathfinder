class Class {
  final int id;
  final String name;
  final bool isActive;
  final String description;

  Class({
    required this.id,
    required this.name,
    required this.isActive,
    required this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'is_active': isActive,
      'description': description,
    };
  }
}
