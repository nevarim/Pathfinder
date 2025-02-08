// AuthService.dart
import 'package:bcrypt/bcrypt.dart';
import '../models/user.dart';
import '../database.dart';
import 'dart:math';
// Per la serializzazione JSON


class AuthService {
  Future<String> register(User user) async {
    try {
      final conn = await DatabaseHelper().connection;

      final hashedPassword = BCrypt.hashpw(user.password, BCrypt.gensalt());

      var result = await conn.query(
        'INSERT INTO users (username, email, password, is_active, is_debug) VALUES (?, ?, ?, ?, ?)',
        [user.username, user.email, hashedPassword, true, false]
      );

      if (result.affectedRows == 1) {
        return 'Utente registrato con successo';
      } else {
        print("Errore durante la registrazione dell'utente ${user.username}");
        return 'Errore nella registrazione';
      }
    } catch (e) {
      print("Errore durante la registrazione: $e");
      return 'Errore: $e';
    }
  }

  Future<Map<String, dynamic>> login(String identifier, String password) async {
    final conn = await DatabaseHelper().connection;

    var results = await conn.query(
        'SELECT id, password FROM users WHERE username = ? OR email = ?', 
        [identifier, identifier]);

    if (results.isEmpty) {
      throw Exception('Errore: Utente non trovato');
    }

    var row = results.first;
    int userId = row[0];
    String hashedPassword = row[1];

    if (!BCrypt.checkpw(password, hashedPassword)) {
      throw Exception('Errore: Password errata');
    }

    await conn.query(
        'UPDATE users SET last_access = NOW() WHERE id = ?', [userId]);

    String sessionToken = _generateSessionToken();
    DateTime expiresAt = DateTime.now().add(Duration(hours: 2));

    await conn.query(
        'INSERT INTO sessions (user_id, session_token, expires_at) VALUES (?, ?, ?)',
        [userId, sessionToken, expiresAt.toUtc().toIso8601String()]);

    return {
      'session_token': sessionToken,
      'user_id': userId
    };
  }

  Future<String> logout(String sessionToken) async {
    final conn = await DatabaseHelper().connection;

    var result = await conn.query(
        'DELETE FROM sessions WHERE session_token = ?', [sessionToken]);

    return result.affectedRows == 1 ? 'Logout effettuato' : 'Errore nel logout';
  }

  String _generateSessionToken() {
    var rand = Random.secure();
    var bytes = List<int>.generate(32, (_) => rand.nextInt(256));
    return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }

  Future<bool> isSessionValid(String sessionToken) async {
    final conn = await DatabaseHelper().connection;

    var results = await conn.query(
        'SELECT user_id FROM sessions WHERE session_token = ? AND expires_at > NOW()',
        [sessionToken]);

    return results.isNotEmpty;
  }

  Future<User?> getUserByEmail(String email) async {
  final conn = await DatabaseHelper().connection;

  var results = await conn.query(
    'SELECT id, username, email, is_active, is_debug FROM users WHERE email = ?', 
    [email]
  );

  if (results.isEmpty) {
    return null;
  }

  var row = results.first;
  return User(
    id: row[0] as int,
    username: row[1] as String,
    email: row[2] as String,
    password: '',  // Assumendo che la password non debba essere restituita
    isActive: (row[3] as int) == 1, // Conversione esplicita int -> bool
    isDebug: (row[4] as int) == 1,  // Conversione esplicita int -> bool
  );
}

  Future<User?> getUserByUsername(String username) async {
  final conn = await DatabaseHelper().connection;

  var results = await conn.query(
    'SELECT id, username, email, is_active, is_debug FROM users WHERE username = ?', 
    [username]
  );

  if (results.isEmpty) {
    return null;
  }

  var row = results.first;
  return User(
    id: row[0] as int,
    username: row[1] as String,
    email: row[2] as String,
    password: '',  // Assumendo che la password non debba essere restituita
    isActive: (row[3] as int) == 1, // Conversione esplicita int -> bool
    isDebug: (row[4] as int) == 1,  // Conversione esplicita int -> bool
  );
}

  Future<String> updateUserSettings(int userId, String username, String password, bool isDebug, bool isActive) async {
  try {
    final conn = await DatabaseHelper().connection;

    // Log per verificare i dati in ingresso
    print("Aggiornamento delle impostazioni per l'utente con ID: $userId");
    print("Nuovo username: $username");
    print("Nuova password (criptata): $password"); // Non è sicuro stampare la password in chiaro
    print("Nuovo stato IsDebug: $isDebug");
    print("Nuovo stato IsActive: $isActive");

    String updateQuery = 'UPDATE users SET username = ?, password = ?, is_debug = ?, is_active = ? WHERE id = ?';
    var parameters = [
      username, 
      BCrypt.hashpw(password, BCrypt.gensalt()), // Usa bcrypt per criptare la nuova password
      isDebug ? 1 : 0, 
      isActive ? 1 : 0,
      userId
    ];

    // Log della query
    print("Esecuzione della query: $updateQuery");
    print("Parametri della query: $parameters");

    var result = await conn.query(updateQuery, parameters);

    if (result.affectedRows == 1) {
      // Log di successo
      print("Le impostazioni utente sono state aggiornate con successo.");
      return 'Impostazioni utente aggiornate con successo';
    } else {
      // Log di nessun cambiamento
      print("Nessun cambiamento effettuato per l'utente con ID: $userId");
      return 'Nessun cambiamento effettuato';
    }
  } catch (e) {
    // Log dell'errore
    print("Errore durante l'aggiornamento delle impostazioni: $e");
    return 'Errore: $e';
  }
}

}
