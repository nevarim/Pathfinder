import '../database.dart';


class PermissionService {
  Future<String> addPermission(String permissionName) async {
    final conn = await DatabaseHelper().connection;

    // Controlla se il permesso esiste già
    var check = await conn.query(
        'SELECT id FROM permissions WHERE permission_name = ?', 
        [permissionName]);

    if (check.isNotEmpty) {
      return 'Errore: Il permesso esiste già';
    }

    var result = await conn.query(
        'INSERT INTO permissions (permission_name, is_active) VALUES (?, ?)',
        [permissionName, true]);

    return result.affectedRows == 1 ? 'Permesso aggiunto con successo' : 'Errore nell\'aggiunta';
  }

  Future<String> editPermission(int permissionId, String newPermissionName) async {
    final conn = await DatabaseHelper().connection;

    var result = await conn.query(
        'UPDATE permissions SET permission_name = ? WHERE id = ?', 
        [newPermissionName, permissionId]);

    return result.affectedRows == 1 ? 'Permesso modificato' : 'Errore nella modifica';
  }

  Future<String> disablePermission(int permissionId) async {
    final conn = await DatabaseHelper().connection;

    var result = await conn.query(
        'UPDATE permissions SET is_active = FALSE WHERE id = ?', 
        [permissionId]);

    return result.affectedRows == 1 ? 'Permesso disabilitato' : 'Errore nella disabilitazione';
  }

  Future<int?> getPermissionId(String permissionName) async {
  final conn = await DatabaseHelper().connection;

  var result = await conn.query(
    'SELECT id FROM permissions WHERE permission_name = ?',
    [permissionName]
  );

  if (result.isEmpty) {
    return null; // Permesso non trovato
  }

  return result.first[0]; // Restituisce l'ID del permesso
}



}



