import '../database.dart';
import 'dart:convert';  // Per utf8.decode()
import 'dart:typed_data';  // Per Uint8List

class ClassService {
  Future<String> addClass(String name, String description) async {
    try {
      final conn = await DatabaseHelper().connection;
      var result = await conn.query(
        'INSERT INTO path_class (name, description, is_active) VALUES (?, ?, ?)',
        [name, description, true]
      );

      if (result.affectedRows == 1) {
        return 'Classe aggiunta con successo';
      } else {
        return 'Errore nell\'aggiunta della classe';
      }
    } catch (e) {
      return 'Errore: $e';
    }
  }

  Future<String> editClass(int id, String newName, String newDescription) async {
    try {
      final conn = await DatabaseHelper().connection;
      var result = await conn.query(
        'UPDATE path_class SET name = ?, description = ? WHERE id = ?',
        [newName, newDescription, id]
      );

      return result.affectedRows == 1 
          ? 'Classe modificata con successo' 
          : 'Errore nella modifica della classe';
    } catch (e) {
      return 'Errore: $e';
    }
  }

  Future<String> inactivateClass(int id) async {
    try {
      final conn = await DatabaseHelper().connection;
      var result = await conn.query(
        'UPDATE path_class SET is_active = ? WHERE id = ?',
        [false, id]
      );

      return result.affectedRows == 1 
          ? 'Classe disattivata con successo' 
          : 'Errore nella disattivazione della classe';
    } catch (e) {
      return 'Errore: $e';
    }
  }

  // Nuova funzione per ottenere tutte le classi
  Future<List<Map<String, dynamic>>> getAllClasses() async {
    try {
      final conn = await DatabaseHelper().connection;
      var results = await conn.query('SELECT * FROM path_class');

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

  // Nuova funzione per ottenere una classe per ID
  Future<Map<String, dynamic>?> getClassById(int id) async {
    try {
      final conn = await DatabaseHelper().connection;
      var result = await conn.query('SELECT * FROM path_class WHERE id = ?', [id]);
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


  Future<String> addClassLevel(int classId, {int? level, required String baseAttackBonus, required int fortSave, required int refSave, required int willSave}) async {
    try {
      final conn = await DatabaseHelper().connection;
      
      if (level == null) {
        var result = await conn.query('SELECT MAX(level) FROM path_class_level WHERE class_id = ?', [classId]);
        level = (result.first[0] as int? ?? 0) + 1;
      }
      
      if (level < 1 || level > 20) {
        return 'Errore: Il livello deve essere compreso tra 1 e 20';
      }
      
      var result = await conn.query(
        'INSERT INTO path_class_level (class_id, level, base_attack_bonus, fort_save, ref_save, will_save) VALUES (?, ?, ?, ?, ?, ?)',
        [classId, level, baseAttackBonus, fortSave, refSave, willSave]
      );
      
      return result.affectedRows == 1 
          ? 'Livello aggiunto con successo' 
          : 'Errore nell\'aggiunta del livello';
    } catch (e) {
      return 'Errore: $e';
    }
  }

  Future<String> removeClassLevel(int classId, int level) async {
    try {
      final conn = await DatabaseHelper().connection;
      var result = await conn.query(
        'DELETE FROM path_class_level WHERE class_id = ? AND level = ?',
        [classId, level]
      );
      
      return result.affectedRows == 1 
          ? 'Livello rimosso con successo' 
          : 'Errore nella rimozione del livello';
    } catch (e) {
      return 'Errore: $e';
    }
  }

  Future<List<Map<String, dynamic>>> getClassLevels(int classId) async {
    try {
      final conn = await DatabaseHelper().connection;
      var results = await conn.query('SELECT * FROM path_class_level WHERE class_id = ? ORDER BY level', [classId]);
      
      return results.map((row) => {
        'id': row['id'],
        'class_id': row['class_id'],
        'level': row['level'],
        'base_attack_bonus': row['base_attack_bonus'],
        'fort_save': row['fort_save'],
        'ref_save': row['ref_save'],
        'will_save': row['will_save']
      }).toList();
    } catch (e) {
      throw 'Errore: $e';
    }
  }

  Future<Map<String, dynamic>?> getClassLevel(int classId, int level) async {
    try {
      final conn = await DatabaseHelper().connection;
      var result = await conn.query('SELECT * FROM path_class_level WHERE class_id = ? AND level = ?', [classId, level]);
      
      if (result.isNotEmpty) {
        var row = result.first;
        return {
          'id': row['id'],
          'class_id': row['class_id'],
          'level': row['level'],
          'base_attack_bonus': row['base_attack_bonus'],
          'fort_save': row['fort_save'],
          'ref_save': row['ref_save'],
          'will_save': row['will_save']
        };
      } else {
        return null;
      }
    } catch (e) {
      throw 'Errore: $e';
    }
  }



}


