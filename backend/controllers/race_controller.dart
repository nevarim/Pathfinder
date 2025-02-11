import 'dart:convert';
import 'package:shelf/shelf.dart';
import '../services/race_service.dart';

class RaceController {
  final RaceService raceService = RaceService();

  Future<Response> addRace(Request request) async {
    try {
      final body = await request.readAsString();
      final jsonData = json.decode(body);

      if (!jsonData.containsKey('name') || !jsonData.containsKey('description')) {
        return Response(400, body: 'Nome o descrizione razza mancanti');
      }

      String name = jsonData['name'];
      String description = jsonData['description'];

      String result = await raceService.addRace(name, description);
      return Response.ok(result);
    } catch (e) {
      return Response.internalServerError(body: 'Errore: $e');
    }
  }

  Future<Response> editRace(Request request) async {
    try {
      final body = await request.readAsString();
      final jsonData = json.decode(body);

      if (!jsonData.containsKey('id') || !jsonData.containsKey('name') || !jsonData.containsKey('description')) {
        return Response(400, body: 'Dati mancanti');
      }

      int id = jsonData['id'];
      String name = jsonData['name'];
      String description = jsonData['description'];

      String result = await raceService.editRace(id, name, description);
      return Response.ok(result);
    } catch (e) {
      return Response.internalServerError(body: 'Errore: $e');
    }
  }

  Future<Response> inactivateRace(Request request) async {
    try {
      final body = await request.readAsString();
      final jsonData = json.decode(body);

      if (!jsonData.containsKey('id')) {
        return Response(400, body: 'ID razza mancante');
      }

      int id = jsonData['id'];
      String result = await raceService.inactivateRace(id);
      return Response.ok(result);
    } catch (e) {
      return Response.internalServerError(body: 'Errore: $e');
    }
  }

  // Nuova funzione per ottenere tutte le razze
  Future<Response> getAllRaces(Request request) async {
    try {
      final races = await raceService.getAllRaces();
      return Response.ok(jsonEncode(races), headers: {'Content-Type': 'application/json'});
    } catch (e) {
      return Response.internalServerError(body: jsonEncode({'errore': e.toString()}), headers: {'Content-Type': 'application/json'});
    }
  }

  // Nuova funzione per ottenere una razza per ID
  
  Future<Response> getRaceById(Request request, String id) async {
    try {
      final race = await raceService.getRaceById(int.parse(id));
      if (race != null) {
        return Response.ok(json.encode(race), headers: {'Content-Type': 'application/json'});
      } else {
        return Response(404, body: 'Razza non trovata');
      }
    } catch (e) {
      return Response.internalServerError(body: 'Errore: $e');
    }
  }

  // Assegna un bonus/malus a una razza
  Future<Response> assignRaceAbility(Request request) async {
    try {
      final body = await request.readAsString();
      final jsonData = json.decode(body);

      if (!jsonData.containsKey('race_id') || !jsonData.containsKey('value')) {
        return Response(400, body: 'Dati mancanti');
      }

      int raceId = jsonData['race_id'];
      int? abilityId = jsonData.containsKey('ability_id') ? jsonData['ability_id'] : null;
      int value = jsonData['value'];

      String result = await raceService.assignRaceAbility(raceId, abilityId, value);
      return Response.ok(result);
    } catch (e) {
      return Response.internalServerError(body: 'Errore: $e');
    }
  }

  // Rimuove un bonus/malus da una razza
  Future<Response> removeRaceAbility(Request request) async {
    try {
      final body = await request.readAsString();
      final jsonData = json.decode(body);

      if (!jsonData.containsKey('race_id')) {
        return Response(400, body: 'Dati mancanti');
      }

      int raceId = jsonData['race_id'];
      int? abilityId = jsonData.containsKey('ability_id') ? jsonData['ability_id'] : null;

      String result = await raceService.removeRaceAbility(raceId, abilityId);
      return Response.ok(result);
    } catch (e) {
      return Response.internalServerError(body: 'Errore: $e');
    }
  }

  // Modifica un bonus/malus esistente
  Future<Response> updateRaceAbility(Request request) async {
    try {
      final body = await request.readAsString();
      final jsonData = json.decode(body);

      if (!jsonData.containsKey('race_id') || !jsonData.containsKey('new_value')) {
        return Response(400, body: 'Dati mancanti');
      }

      int raceId = jsonData['race_id'];
      int? abilityId = jsonData.containsKey('ability_id') ? jsonData['ability_id'] : null;
      int newValue = jsonData['new_value'];

      String result = await raceService.updateRaceAbility(raceId, abilityId, newValue);
      return Response.ok(result);
    } catch (e) {
      return Response.internalServerError(body: 'Errore: $e');
    }
  }

  // Recupera tutte le abilità modificate da una razza
  Future<Response> getRaceAbilities(Request request) async {
    try {
      final body = await request.readAsString();
      final jsonData = json.decode(body);

      if (!jsonData.containsKey('race_id')) {
        return Response(400, body: 'Dati mancanti: race_id');
      }

      int raceId = jsonData['race_id'];
      List<Map<String, dynamic>> abilities = await raceService.getRaceAbilities(raceId);

      return Response.ok(json.encode(abilities), headers: {'Content-Type': 'application/json'});
    } catch (e) {
      return Response.internalServerError(body: 'Errore: $e');
    }
  }

  // Recupera tutte le razze che modificano una determinata abilità
  Future<Response> getRacesByAbility(Request request) async {
    try {
      final body = await request.readAsString();
      final jsonData = json.decode(body);

      if (!jsonData.containsKey('ability_id')) {
        return Response(400, body: 'Dati mancanti: ability_id');
      }

      int abilityId = jsonData['ability_id'];
      List<Map<String, dynamic>> races = await raceService.getRacesByAbility(abilityId);

      return Response.ok(json.encode(races), headers: {'Content-Type': 'application/json'});
    } catch (e) {
      return Response.internalServerError(body: 'Errore: $e');
    }
  }


}



