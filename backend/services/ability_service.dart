import '../database.dart';
import 'dart:convert';
import 'dart:typed_data';

class AbilityService {
  Future<String> addAbility(String name, String description) async {
    try {
      final conn = await DatabaseHelper().connection;
      var result = await conn.query(
        'INSERT INTO path_ability (name, description, is_active) VALUES (?, ?, ?)',
        [name, description, true]
      );

      return result.affectedRows == 1 
          ? 'Abilità aggiunta con successo' 
          : 'Errore nell\'aggiunta dell\'abilità';
    } catch (e) {
      return 'Errore: $e';
    }
  }

  Future<String> editAbility(int id, String newName, String newDescription) async {
    try {
      final conn = await DatabaseHelper().connection;
      var result = await conn.query(
        'UPDATE path_ability SET name = ?, description = ? WHERE id = ?',
        [newName, newDescription, id]
      );

      return result.affectedRows == 1 
          ? 'Abilità modificata con successo' 
          : 'Errore nella modifica dell\'abilità';
    } catch (e) {
      return 'Errore: $e';
    }
  }

  Future<String> inactivateAbility(int id) async {
    try {
      final conn = await DatabaseHelper().connection;
      var result = await conn.query(
        'UPDATE path_ability SET is_active = ? WHERE id = ?',
        [false, id]
      );

      return result.affectedRows == 1 
          ? 'Abilità disattivata con successo' 
          : 'Errore nella disattivazione dell\'abilità';
    } catch (e) {
      return 'Errore: $e';
    }
  }

  Future<List<Map<String, dynamic>>> getAllAbilities() async {
    try {
      final conn = await DatabaseHelper().connection;
      var results = await conn.query('SELECT * FROM path_ability');

      return results.map((row) {
        var description = row['description'];

        if (description is Uint8List) {
          description = utf8.decode(description);
        } else if (description != null) {
          description = description.toString();
        }

        return {
          'id': row['id'],
          'name': row['name'].toString(),
          'description': description,
          'is_active': (row['is_active'] == 1),
        };
      }).toList();
    } catch (e) {
      throw 'Errore: $e';
    }
  }

  Future<Map<String, dynamic>?> getAbilityById(int id) async {
    try {
      final conn = await DatabaseHelper().connection;
      var result = await conn.query('SELECT * FROM path_ability WHERE id = ?', [id]);

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
