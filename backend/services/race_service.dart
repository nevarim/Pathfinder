import '../database.dart';
import 'dart:convert';  // Per utf8.decode()
import 'dart:typed_data';  // Per Uint8List

class RaceService {
  Future<String> addRace(String name, String description) async {
    try {
      final conn = await DatabaseHelper().connection;
      var result = await conn.query(
        'INSERT INTO path_race (name, description, is_active) VALUES (?, ?, ?)',
        [name, description, true]
      );

      if (result.affectedRows == 1) {
        return 'Razza aggiunta con successo';
      } else {
        return 'Errore nell\'aggiunta della razza';
      }
    } catch (e) {
      return 'Errore: $e';
    }
  }

  Future<String> editRace(int id, String newName, String newDescription) async {
    try {
      final conn = await DatabaseHelper().connection;
      var result = await conn.query(
        'UPDATE path_race SET name = ?, description = ? WHERE id = ?',
        [newName, newDescription, id]
      );

      return result.affectedRows == 1 
          ? 'Razza modificata con successo' 
          : 'Errore nella modifica della razza';
    } catch (e) {
      return 'Errore: $e';
    }
  }

  Future<String> inactivateRace(int id) async {
    try {
      final conn = await DatabaseHelper().connection;
      var result = await conn.query(
        'UPDATE path_race SET is_active = ? WHERE id = ?',
        [false, id]
      );

      return result.affectedRows == 1 
          ? 'Razza disattivata con successo' 
          : 'Errore nella disattivazione della razza';
    } catch (e) {
      return 'Errore: $e';
    }
  }

  // Nuova funzione per ottenere tutte le razze
  Future<List<Map<String, dynamic>>> getAllRaces() async {
    try {
      final conn = await DatabaseHelper().connection;
      var results = await conn.query('SELECT * FROM path_race');

      return results.map((row) {
        var description = row['description'];

        // Conversione corretta della descrizione (se BLOB/TEXT)
        if (description is Uint8List) {
          description = utf8.decode(description);
        } else if (description != null) {
          description = description.toString();
        }

        return {
          'id': row['id'],
          'name': row['name'].toString(),
          'description': description,
          'is_active': (row['is_active'] == 1),  // Converte 1/0 in bool
        };
      }).toList();
    } catch (e) {
      throw 'Errore: $e';
    }
  }

  // Nuova funzione per ottenere una razza per ID
  Future<Map<String, dynamic>?> getRaceById(int id) async {
    try {
      final conn = await DatabaseHelper().connection;
      var result = await conn.query('SELECT * FROM path_race WHERE id = ?', [id]);
      if (result.isNotEmpty) {
        var row = result.first;
        return {
          'id': row['id'],
          'name': row['name'],
          'description': row['description'],
          'is_active': row['is_active']
        };
      } else {
        return null;
      }
    } catch (e) {
      throw 'Errore: $e';
    }
  }
}

