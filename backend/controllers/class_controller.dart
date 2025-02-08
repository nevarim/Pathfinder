import 'dart:convert';
import 'package:shelf/shelf.dart';
import '../services/class_service.dart';

class ClassController {
  final ClassService classService = ClassService();

  Future<Response> getAllClasses(Request request) async {
    try {
      final classes = await classService.getAllClasses();
      return Response.ok(jsonEncode(classes.map((c) => c.toJson()).toList()),
          headers: {'Content-Type': 'application/json'});
    } catch (e) {
      return Response.internalServerError(body: jsonEncode({'error': e.toString()}));
    }
  }

  Future<Response> getClassById(Request request, String id) async {
    try {
      final classId = int.parse(id);
      final classData = await classService.getClassById(classId);
      if (classData != null) {
        return Response.ok(jsonEncode(classData.toJson()),
            headers: {'Content-Type': 'application/json'});
      } else {
        return Response.notFound(jsonEncode({'error': 'Class not found'}));
      }
    } catch (e) {
      return Response.internalServerError(body: jsonEncode({'error': e.toString()}));
    }
  }

  Future<Response> addClass(Request request) async {
    try {
      final payload = jsonDecode(await request.readAsString());
      await classService.addClass(payload['name']);
      return Response.ok(jsonEncode({'message': 'Class added successfully'}));
    } catch (e) {
      return Response.internalServerError(body: jsonEncode({'error': e.toString()}));
    }
  }

  Future<Response> updateClass(Request request, String id) async {
    try {
      final classId = int.parse(id);
      final payload = jsonDecode(await request.readAsString());
      await classService.updateClass(classId, payload['name']);
      return Response.ok(jsonEncode({'message': 'Class updated successfully'}));
    } catch (e) {
      return Response.internalServerError(body: jsonEncode({'error': e.toString()}));
    }
  }

  Future<Response> deactivateClass(Request request, String id) async {
    try {
      final classId = int.parse(id);
      await classService.deactivateClass(classId);
      return Response.ok(jsonEncode({'message': 'Class deactivated successfully'}));
    } catch (e) {
      return Response.internalServerError(body: jsonEncode({'error': e.toString()}));
    }
  }
}
