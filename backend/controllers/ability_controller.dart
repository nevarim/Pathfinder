import 'dart:convert';
import 'package:shelf/shelf.dart';
import '../services/ability_service.dart';

class AbilityController {
  final AbilityService abilityService = AbilityService();

  Future<Response> addAbility(Request request) async {
    try {
      final body = await request.readAsString();
      final jsonData = json.decode(body);

      if (!jsonData.containsKey('name') || !jsonData.containsKey('description')) {
        return Response(400, body: 'Nome o descrizione abilità mancanti');
      }

      String name = jsonData['name'];
      String description = jsonData['description'];

      String result = await abilityService.addAbility(name, description);
      return Response.ok(result);
    } catch (e) {
      return Response.internalServerError(body: 'Errore: $e');
    }
  }

  Future<Response> editAbility(Request request) async {
    try {
      final body = await request.readAsString();
      final jsonData = json.decode(body);

      if (!jsonData.containsKey('id') || !jsonData.containsKey('name') || !jsonData.containsKey('description')) {
        return Response(400, body: 'Dati mancanti');
      }

      int id = jsonData['id'];
      String name = jsonData['name'];
      String description = jsonData['description'];

      String result = await abilityService.editAbility(id, name, description);
      return Response.ok(result);
    } catch (e) {
      return Response.internalServerError(body: 'Errore: $e');
    }
  }

  Future<Response> inactivateAbility(Request request) async {
    try {
      final body = await request.readAsString();
      final jsonData = json.decode(body);

      if (!jsonData.containsKey('id')) {
        return Response(400, body: 'ID abilità mancante');
      }

      int id = jsonData['id'];
      String result = await abilityService.inactivateAbility(id);
      return Response.ok(result);
    } catch (e) {
      return Response.internalServerError(body: 'Errore: $e');
    }
  }

  Future<Response> getAllAbilities(Request request) async {
    try {
      final abilities = await abilityService.getAllAbilities();
      return Response.ok(jsonEncode(abilities), headers: {'Content-Type': 'application/json'});
    } catch (e) {
      return Response.internalServerError(body: jsonEncode({'errore': e.toString()}), headers: {'Content-Type': 'application/json'});
    }
  }

  Future<Response> getAbilityById(Request request, String id) async {
    try {
      final ability = await abilityService.getAbilityById(int.parse(id));
      if (ability != null) {
        return Response.ok(json.encode(ability), headers: {'Content-Type': 'application/json'});
      } else {
        return Response(404, body: 'Abilità non trovata');
      }
    } catch (e) {
      return Response.internalServerError(body: 'Errore: $e');
    }
  }
}
