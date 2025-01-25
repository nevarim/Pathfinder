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
}



