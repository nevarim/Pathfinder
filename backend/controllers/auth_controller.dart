import '../services/auth_service.dart';
import '../models/user.dart';
import 'dart:convert';
import 'package:shelf/shelf.dart';

class AuthController {
  final AuthService authService = AuthService();

  Future<Response> register(Request request) async {
    try {
      final body = await request.readAsString();
      final jsonData = json.decode(body);

      if (!jsonData.containsKey('username') || 
          !jsonData.containsKey('password') || 
          !jsonData.containsKey('email')) {
        return Response(400, body: 'Dati mancanti');
      }

      String username = jsonData['username'];
      String password = jsonData['password'];
      String email = jsonData['email'];

      User user = User(
        id: 0,
        username: username,
        password: password,
        email: email,
        isActive: true, // Aggiunto il campo isActive
        isDebug: false
      );

      String result = await authService.register(user);
      return Response.ok(result);
    } catch (e) {
      return Response.internalServerError(body: 'Errore: $e');
    }
  }

  Future<Response> login(Request request) async {
    try {
      final body = await request.readAsString();
      final jsonData = json.decode(body);

      if (!jsonData.containsKey('identifier') || !jsonData.containsKey('password')) {
        return Response(400, body: json.encode({'error': 'Dati mancanti'}));
      }

      String identifier = jsonData['identifier']; // Può essere username o email
      String password = jsonData['password'];

      Map<String, dynamic> loginResult = await authService.login(identifier, password);

      return Response.ok(json.encode(loginResult),
          headers: {'Content-Type': 'application/json'});
    } catch (e) {
      return Response.internalServerError(body: json.encode({'error': e.toString()}));
    }
  }

  Future<Response> logout(Request request) async {
    try {
      final body = await request.readAsString();
      final jsonData = json.decode(body);

      if (!jsonData.containsKey('session_token')) {
        return Response(400, body: 'Sessione non trovata');
      }

      String sessionToken = jsonData['session_token'];
      String result = await authService.logout(sessionToken);
      return Response.ok(result);
    } catch (e) {
      return Response.internalServerError(body: 'Errore: $e');
    }
  }

  Future<Response> getUserByEmail(String email) async {
    try {
      User? user = await authService.getUserByEmail(email);

      if (user == null) {
        return Response(404, body: 'Utente non trovato');
      }

      return Response.ok(json.encode(user.toJson()),
          headers: {'Content-Type': 'application/json'});
    } catch (e) {
      return Response.internalServerError(body: 'Errore: $e');
    }
  }

  Future<Response> getUserByUsername(String username) async {
    try {
      User? user = await authService.getUserByUsername(username);

      if (user == null) {
        return Response(404, body: 'Utente non trovato');
      }

      return Response.ok(json.encode(user.toJson()),
          headers: {'Content-Type': 'application/json'});
    } catch (e) {
      return Response.internalServerError(body: 'Errore: $e');
    }
  }

  Future<Response> updateUserSettings(Request request) async {
    try {
      final body = await request.readAsString();
      final jsonData = json.decode(body);

      if (!jsonData.containsKey('user_id') ||
          !jsonData.containsKey('username') ||
          !jsonData.containsKey('password') ||
          !jsonData.containsKey('is_debug') ||
          !jsonData.containsKey('is_active')) {
        return Response(400, body: 'Dati mancanti');
      }

      int userId = jsonData['user_id'];
      String username = jsonData['username'];
      String password = jsonData['password'];
      bool isDebug = jsonData['is_debug'];
      bool isActive = jsonData['is_active'];

      String result = await authService.updateUserSettings(userId, username, password, isDebug, isActive);
      return Response.ok(result);
    } catch (e) {
      return Response.internalServerError(body: 'Errore: $e');
    }
  }


}
