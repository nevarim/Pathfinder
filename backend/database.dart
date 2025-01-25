import 'package:mysql1/mysql1.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  MySqlConnection? _connection;

  Future<MySqlConnection> get connection async {
    if (_connection == null) {
      _connection = await _initDb();
    }
    return _connection!;
  }

  Future<MySqlConnection> _initDb() async {
    final settings = ConnectionSettings(
      host: 'localhost', // Cambia se necessario
      port: 3306,
      user: 'pathfinder',
      password: 'pathfinder',
      db: 'pathproject',
    );
    return await MySqlConnection.connect(settings);
  }
}
