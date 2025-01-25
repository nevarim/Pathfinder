class Race {
  final int id;
  final String name;
  final bool isActive;
  final String description;

  Race({
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
