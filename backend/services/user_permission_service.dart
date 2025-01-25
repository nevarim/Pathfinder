import '../database.dart';

class UserPermissionService {
  Future<String> assignPermission(int userId, int permissionId) async {
    final conn = await DatabaseHelper().connection;

    // Controlla se il permesso è già assegnato
    var check = await conn.query(
        'SELECT * FROM user_permissions WHERE user_id = ? AND permission_id = ?', 
        [userId, permissionId]);

    if (check.isNotEmpty) {
      return 'Errore: Permesso già assegnato';
    }

    var result = await conn.query(
        'INSERT INTO user_permissions (user_id, permission_id) VALUES (?, ?)',
        [userId, permissionId]);

    return result.affectedRows == 1 ? 'Permesso assegnato con successo' : 'Errore nell\'assegnazione';
  }

  Future<String> removePermission(int userId, int permissionId) async {
    final conn = await DatabaseHelper().connection;

    var result = await conn.query(
        'DELETE FROM user_permissions WHERE user_id = ? AND permission_id = ?', 
        [userId, permissionId]);

    return result.affectedRows == 1 ? 'Permesso rimosso con successo' : 'Errore nella rimozione';
  }
}


