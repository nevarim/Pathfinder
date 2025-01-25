import '../services/user_permission_service.dart';
import 'dart:convert';
import 'package:shelf/shelf.dart';

class UserPermissionController {
  final UserPermissionService userPermissionService = UserPermissionService();

  Future<Response> assignPermission(Request request) async {
    try {
      final body = await request.readAsString();
      final jsonData = json.decode(body);

      if (!jsonData.containsKey('user_id') || !jsonData.containsKey('permission_id')) {
        return Response(400, body: 'Dati mancanti');
      }

      int userId = jsonData['user_id'];
      int permissionId = jsonData['permission_id'];

      String result = await userPermissionService.assignPermission(userId, permissionId);

      return Response.ok(result);
    } catch (e) {
      return Response.internalServerError(body: 'Errore: $e');
    }
  }

  Future<Response> removePermission(Request request) async {
    try {
      final body = await request.readAsString();
      final jsonData = json.decode(body);

      if (!jsonData.containsKey('user_id') || !jsonData.containsKey('permission_id')) {
        return Response(400, body: 'Dati mancanti');
      }

      int userId = jsonData['user_id'];
      int permissionId = jsonData['permission_id'];

      String result = await userPermissionService.removePermission(userId, permissionId);

      return Response.ok(result);
    } catch (e) {
      return Response.internalServerError(body: 'Errore: $e');
    }
  }
}
