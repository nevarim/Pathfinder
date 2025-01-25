import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_cors_headers/shelf_cors_headers.dart';
import 'routes/api_routes.dart';

void main() async {
  final handler = Pipeline()
      .addMiddleware(logRequests()) // Log delle richieste
      .addMiddleware(corsHeaders()) // Abilita CORS
      .addHandler(defineApiRoutes());

  var server = await io.serve(handler, 'localhost', 8080);
  print('Server in ascolto su http://${server.address.host}:${server.port}');
}
