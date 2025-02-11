import 'dart:convert';
import 'package:shelf/shelf.dart';
import '../services/class_service.dart';

class ClassController {
  final ClassService classService = ClassService();

  Future<Response> getAllClasses(Request request) async {
  try {
    final classes = await classService.getAllClasses();
    return Response.ok(jsonEncode(classes), headers: {'Content-Type': 'application/json'});
  } catch (e) {
    return Response.internalServerError(body: jsonEncode({'error': e.toString()}), headers: {'Content-Type': 'application/json'});
  }
}

  Future<Response> addClass(Request request) async {
    try {
      final body = await request.readAsString();
      final jsonData = json.decode(body);

      if (!jsonData.containsKey('name') || !jsonData.containsKey('description')) {
        return Response(400, body: jsonEncode({'error': 'Nome o descrizione mancanti'}), headers: {'Content-Type': 'application/json'});
      }

      String result = await classService.addClass(jsonData['name'], jsonData['description']);
      return Response.ok(jsonEncode({'message': result}), headers: {'Content-Type': 'application/json'});
    } catch (e) {
      return Response.internalServerError(body: jsonEncode({'error': e.toString()}), headers: {'Content-Type': 'application/json'});
    }
  }

  Future<Response> editClass(Request request) async {
    try {
      final body = await request.readAsString();
      final jsonData = json.decode(body);

      if (!jsonData.containsKey('id') || !jsonData.containsKey('name') || !jsonData.containsKey('description')) {
        return Response(400, body: jsonEncode({'error': 'Dati mancanti'}), headers: {'Content-Type': 'application/json'});
      }

      String result = await classService.editClass(jsonData['id'], jsonData['name'], jsonData['description']);
      return Response.ok(jsonEncode({'message': result}), headers: {'Content-Type': 'application/json'});
    } catch (e) {
      return Response.internalServerError(body: jsonEncode({'error': e.toString()}), headers: {'Content-Type': 'application/json'});
    }
  }

  Future<Response> inactivateClass(Request request) async {
    try {
      final body = await request.readAsString();
      final jsonData = json.decode(body);

      if (!jsonData.containsKey('id')) {
        return Response(400, body: jsonEncode({'error': 'ID classe mancante'}), headers: {'Content-Type': 'application/json'});
      }

      String result = await classService.inactivateClass(jsonData['id']);
      return Response.ok(jsonEncode({'message': result}), headers: {'Content-Type': 'application/json'});
    } catch (e) {
      return Response.internalServerError(body: jsonEncode({'error': e.toString()}), headers: {'Content-Type': 'application/json'});
    }
  }

  Future<Response> getClassById(Request request, String classId) async {
  try {
    final classData = await classService.getClassById(int.parse(classId));
    if (classData != null) {
      return Response.ok(jsonEncode(classData), headers: {'Content-Type': 'application/json'});
    } else {
      return Response(404, body: jsonEncode({'error': 'Classe non trovata'}), headers: {'Content-Type': 'application/json'});
    }
  } catch (e) {
    return Response.internalServerError(body: jsonEncode({'error': e.toString()}), headers: {'Content-Type': 'application/json'});
  }
}

  Future<Response> addClassLevel(Request request) async {
    try {
      final body = await request.readAsString();
      final jsonData = json.decode(body);

      if (!jsonData.containsKey('class_id') || !jsonData.containsKey('level') ||
          !jsonData.containsKey('base_attack_bonus') || !jsonData.containsKey('fort_save') ||
          !jsonData.containsKey('ref_save') || !jsonData.containsKey('will_save')) {
        return Response(400, body: jsonEncode({'error': 'Dati mancanti per il livello della classe'}), headers: {'Content-Type': 'application/json'});
      }

      String result = await classService.addClassLevel(
        jsonData['class_id'],
        level: jsonData['level'],
        baseAttackBonus: jsonData['base_attack_bonus'],
        fortSave: jsonData['fort_save'],
        refSave: jsonData['ref_save'],
        willSave: jsonData['will_save'],
      );
      return Response.ok(jsonEncode({'message': result}), headers: {'Content-Type': 'application/json'});
    } catch (e) {
      return Response.internalServerError(body: jsonEncode({'error': e.toString()}), headers: {'Content-Type': 'application/json'});
    }
  }

  Future<Response> removeClassLevel(Request request) async {
    try {
      final body = await request.readAsString();
      final jsonData = json.decode(body);

      if (!jsonData.containsKey('class_id') || !jsonData.containsKey('level')) {
        return Response(400, body: jsonEncode({'error': 'Dati mancanti'}), headers: {'Content-Type': 'application/json'});
      }

      String result = await classService.removeClassLevel(jsonData['class_id'], jsonData['level']);
      return Response.ok(jsonEncode({'message': result}), headers: {'Content-Type': 'application/json'});
    } catch (e) {
      return Response.internalServerError(body: jsonEncode({'error': e.toString()}), headers: {'Content-Type': 'application/json'});
    }
  }

  Future<Response> getClassLevels(Request request, String classId) async {
    try {
      final levels = await classService.getClassLevels(int.parse(classId));
      return Response.ok(jsonEncode(levels), headers: {'Content-Type': 'application/json'});
    } catch (e) {
      return Response.internalServerError(body: jsonEncode({'error': e.toString()}), headers: {'Content-Type': 'application/json'});
    }
  }

  Future<Response> getClassLevel(Request request, String classId, String level) async {
    try {
      final levelData = await classService.getClassLevel(int.parse(classId), int.parse(level));
      if (levelData != null) {
        return Response.ok(jsonEncode(levelData), headers: {'Content-Type': 'application/json'});
      } else {
        return Response(404, body: jsonEncode({'error': 'Livello non trovato'}), headers: {'Content-Type': 'application/json'});
      }
    } catch (e) {
      return Response.internalServerError(body: jsonEncode({'error': e.toString()}), headers: {'Content-Type': 'application/json'});
    }
  }



}
