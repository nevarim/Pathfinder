import 'dart:convert';
import 'package:shelf/shelf.dart';
import '../services/class_service.dart';

class ClassController {
  final ClassService classService = ClassService();

  Future<Response> addClass(Request request) async {
    try {
      final body = await request.readAsString();
      final jsonData = json.decode(body);

      if (!jsonData.containsKey('name') || !jsonData.containsKey('description')) {
        return Response(400, body: 'Nome o descrizione classe mancanti');
      }

      String name = jsonData['name'];
      String description = jsonData['description'];

      String result = await classService.addClass(name, description);
      return Response.ok(result);
    } catch (e) {
      return Response.internalServerError(body: 'Errore: $e');
    }
  }

  Future<Response> editClass(Request request) async {
    try {
      final body = await request.readAsString();
      final jsonData = json.decode(body);

      if (!jsonData.containsKey('id') || !jsonData.containsKey('name') || !jsonData.containsKey('description')) {
        return Response(400, body: 'Dati mancanti');
      }

      int id = jsonData['id'];
      String name = jsonData['name'];
      String description = jsonData['description'];

      String result = await classService.editClass(id, name, description);
      return Response.ok(result);
    } catch (e) {
      return Response.internalServerError(body: 'Errore: $e');
    }
  }

  Future<Response> inactivateClass(Request request) async {
    try {
      final body = await request.readAsString();
      final jsonData = json.decode(body);

      if (!jsonData.containsKey('id')) {
        return Response(400, body: 'ID classe mancante');
      }

      int id = jsonData['id'];
      String result = await classService.inactivateClass(id);
      return Response.ok(result);
    } catch (e) {
      return Response.internalServerError(body: 'Errore: $e');
    }
  }

  Future<Response> getAllClasses(Request request) async {
    try {
      final classes = await classService.getAllClasses();
      return Response.ok(jsonEncode(classes), headers: {'Content-Type': 'application/json'});
    } catch (e) {
      return Response.internalServerError(body: jsonEncode({'errore': e.toString()}), headers: {'Content-Type': 'application/json'});
    }
  }

  Future<Response> getClassById(Request request, String id) async {
    try {
      final classData = await classService.getClassById(int.parse(id));
      if (classData != null) {
        return Response.ok(json.encode(classData), headers: {'Content-Type': 'application/json'});
      } else {
        return Response(404, body: 'Classe non trovata');
      }
    } catch (e) {
      return Response.internalServerError(body: 'Errore: $e');
    }
  }
}
