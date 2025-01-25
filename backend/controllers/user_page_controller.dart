import '../services/user_page_service.dart';
import 'dart:convert';
import 'package:shelf/shelf.dart';

class UserPageController {
  final UserPageService userPageService = UserPageService();

  // Assegnare una pagina a un utente
  Future<Response> assignPageToUser(Request request) async {
    try {
      final body = await request.readAsString();
      final jsonData = json.decode(body);

      if (!jsonData.containsKey('user_id') || !jsonData.containsKey('page_id')) {
        return Response(400, body: 'Dati mancanti');
      }

      int userId = jsonData['user_id'];
      int pageId = jsonData['page_id'];

      String result = await userPageService.assignPageToUser(userId, pageId);

      return Response.ok(result);
    } catch (e) {
      return Response.internalServerError(body: 'Errore: $e');
    }
  }

  // Rimuovere una pagina da un utente
  Future<Response> removePageFromUser(Request request) async {
    try {
      final body = await request.readAsString();
      final jsonData = json.decode(body);

      if (!jsonData.containsKey('user_id') || !jsonData.containsKey('page_id')) {
        return Response(400, body: 'Dati mancanti');
      }

      int userId = jsonData['user_id'];
      int pageId = jsonData['page_id'];

      String result = await userPageService.removePageFromUser(userId, pageId);

      return Response.ok(result);
    } catch (e) {
      return Response.internalServerError(body: 'Errore: $e');
    }
  }

  // Visualizzare le pagine di un utente
  Future<Response> getUserPages(Request request) async {
    try {
      final userId = request.url.pathSegments.last;

      if (userId == 0) {
        return Response(400, body: 'ID utente mancante');
      }

      List<Map<String, dynamic>> pages = await userPageService.getUserPages(int.parse(userId));

      return Response.ok(json.encode(pages), headers: {'Content-Type': 'application/json'});
    } catch (e) {
      return Response.internalServerError(body: 'Errore: $e');
    }
  }

  Future<Response> getPageId(Request request) async {
  try {
    final body = await request.readAsString();
    final jsonData = json.decode(body);

    if (!jsonData.containsKey('page_name')) {
      return Response(400, body: 'Dati mancanti');
    }

    String pageName = jsonData['page_name'];
    int? pageId = await userPageService.getPageIdByName(pageName);

    if (pageId != null) {
      return Response.ok(json.encode({'page_id': pageId}), headers: {'Content-Type': 'application/json'});
    } else {
      return Response(404, body: 'Pagina non trovata');
    }
  } catch (e) {
    return Response.internalServerError(body: 'Errore: $e');
  }
}


}
