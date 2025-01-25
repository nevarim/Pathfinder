import '../services/permission_service.dart';
import 'dart:convert';
import 'package:shelf/shelf.dart';
import '../database.dart';


class PermissionController {
  final PermissionService permissionService = PermissionService();

Future<bool> hasPermissionToEdit(int userId) async {
  // Verifica se l'utente ha il permesso "edit_permission"
  final conn = await DatabaseHelper().connection;

  // Ottieni l'ID del permesso dal nome "edit_permission"
  var permissionResult = await conn.query(
    'SELECT id FROM permissions WHERE permission_name = ?',
    ['edit_permission']
  );

  if (permissionResult.isEmpty) {
    return false; // Se il permesso non esiste, restituisci false
  }

  int permissionId = permissionResult.first['id'];

  // Verifica se l'utente ha questo permesso
  var result = await conn.query(
    'SELECT * FROM user_permissions WHERE user_id = ? AND permission_id = ?',
    [userId, permissionId]
  );

  return result.isNotEmpty;
}

Future<bool> hasPermissionToDisable(int userId) async {
  // Verifica se l'utente ha il permesso "disable_permission"
  final conn = await DatabaseHelper().connection;

  // Ottieni l'ID del permesso dal nome "disable_permission"
  var permissionResult = await conn.query(
    'SELECT id FROM permissions WHERE permission_name = ?',
    ['disable_permission']
  );

  if (permissionResult.isEmpty) {
    return false; // Se il permesso non esiste, restituisci false
  }

  int permissionId = permissionResult.first['id'];

  // Verifica se l'utente ha questo permesso
  var result = await conn.query(
    'SELECT * FROM user_permissions WHERE user_id = ? AND permission_id = ?',
    [userId, permissionId]
  );

  return result.isNotEmpty;
}

Future<bool> hasPermissionToAdd(int userId) async {
  // Verifica se l'utente ha il permesso "add_permission"
  final conn = await DatabaseHelper().connection;

  // Ottieni l'ID del permesso dal nome "add_permission"
  var permissionResult = await conn.query(
    'SELECT id FROM permissions WHERE permission_name = ?',
    ['add_permission']
  );

  if (permissionResult.isEmpty) {
    return false; // Se il permesso non esiste, restituisci false
  }

  int permissionId = permissionResult.first['id'];

  // Verifica se l'utente ha questo permesso
  var result = await conn.query(
    'SELECT * FROM user_permissions WHERE user_id = ? AND permission_id = ?',
    [userId, permissionId]
  );

  return result.isNotEmpty;
}


  Future<Response> addPermission(Request request) async {
    try {
      final body = await request.readAsString();
      final jsonData = json.decode(body);

      // Verifica se user_id è presente
      if (!jsonData.containsKey('user_id') || !jsonData.containsKey('permission_name')) {
        return Response(400, body: 'Dati mancanti');
      }

      int userId = jsonData['user_id'];
      String permissionName = jsonData['permission_name'];

      // Verifica se l'utente ha il permesso di aggiungere permessi (ad esempio, controllo che l'utente sia un admin)
      if (!await hasPermissionToAdd(userId)) {
        return Response(403, body: 'Non hai il permesso di aggiungere un permesso');
      }

      // Aggiungi il permesso
      String result = await permissionService.addPermission(permissionName);

      return Response.ok(json.encode({'message': result}));
    } catch (e) {
      return Response.internalServerError(body: 'Errore: $e');
    }
  }

  Future<Response> editPermission(Request request) async {
  try {
    final body = await request.readAsString();
    final jsonData = json.decode(body);

    if (!jsonData.containsKey('user_id') || !jsonData.containsKey('permission_id') || !jsonData.containsKey('new_permission_name')) {
      return Response(400, body: 'Dati mancanti');
    }

    int userId = jsonData['user_id'];
    int permissionId = jsonData['permission_id'];
    String newPermissionName = jsonData['new_permission_name'];

    // Verifica se l'utente ha il permesso di modificare
    if (!await hasPermissionToEdit(userId)) {
      return Response(403, body: 'Non hai il permesso di modificare questo permesso');
    }

    String result = await permissionService.editPermission(permissionId, newPermissionName);

    return Response.ok(json.encode({'message': result}));
  } catch (e) {
    return Response.internalServerError(body: 'Errore: $e');
  }
  }

  Future<Response> disablePermission(Request request) async {
  try {
    final body = await request.readAsString();
    final jsonData = json.decode(body);

    if (!jsonData.containsKey('user_id') || !jsonData.containsKey('permission_id')) {
      return Response(400, body: 'Dati mancanti');
    }

    int userId = jsonData['user_id'];
    int permissionId = jsonData['permission_id'];

    // Verifica se l'utente ha il permesso di disabilitare permessi
    if (!await hasPermissionToDisable(userId)) {
      return Response(403, body: 'Non hai il permesso di disabilitare questo permesso');
    }

    String result = await permissionService.disablePermission(permissionId);

    return Response.ok(json.encode({'message': result}));
  } catch (e) {
    return Response.internalServerError(body: 'Errore: $e');
  }
  }

  Future<Response> getUserPermissions(Request request, String userId) async {
  try {
    final conn = await DatabaseHelper().connection;

    // Query per ottenere i permessi assegnati all'utente
    var results = await conn.query(
      '''SELECT p.id, p.permission_name, p.is_active 
         FROM user_permissions up
         JOIN permissions p ON up.permission_id = p.id
         WHERE up.user_id = ?''',
      [int.parse(userId)]
    );

    // Se l'utente non ha permessi assegnati, restituiamo una lista vuota
    if (results.isEmpty) {
      return Response.ok(json.encode([]),
          headers: {'Content-Type': 'application/json'});
    }

    // Costruiamo la lista dei permessi
    List<Map<String, dynamic>> permissions = results.map((row) {
      return {
        'id': row[0],
        'permission_name': row[1],
        'is_active': row[2]
      };
    }).toList();

    return Response.ok(json.encode(permissions),
        headers: {'Content-Type': 'application/json'});
  } catch (e) {
    return Response.internalServerError(body: json.encode({'error': e.toString()}));
  }
}

  Future<Response> getPermissionId(Request request) async {
  try {
    final body = await request.readAsString();
    final jsonData = json.decode(body);

    if (!jsonData.containsKey('permission_name')) {
      return Response(400, body: 'Dati mancanti: permission_name richiesto');
    }

    String permissionName = jsonData['permission_name'];
    int? permissionId = await permissionService.getPermissionId(permissionName);

    if (permissionId == null) {
      return Response(404, body: json.encode({'error': 'Permesso non trovato'}));
    }

    return Response.ok(json.encode({'permission_id': permissionId}),
        headers: {'Content-Type': 'application/json'});
  } catch (e) {
    return Response.internalServerError(body: json.encode({'error': e.toString()}));
  }
}


  }


