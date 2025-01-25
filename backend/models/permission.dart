class Permission {
  int id;
  String permissionName;
  bool isActive;

  Permission({required this.id, required this.permissionName, this.isActive = true});
}
