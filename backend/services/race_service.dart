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


  // Funzione per assegnare un bonus/malus a una razza
  Future<String> assignRaceAbility(int raceId, int? abilityId, int value) async {
    try {
      final conn = await DatabaseHelper().connection;

      // Se abilityId è null, verifica che non ci sia già un bonus generico per la razza
      if (abilityId == null) {
        var check = await conn.query(
          'SELECT COUNT(*) as count FROM path_race_ability WHERE race_id = ? AND ability_id IS NULL',
          [raceId]
        );
        if (check.first['count'] > 0) {
          return 'Errore: Esiste già un bonus generico per questa razza';
        }
      } else {
        // Verifica se esiste già un bonus/malus per quella razza e abilità specifica
        var check = await conn.query(
          'SELECT id FROM path_race_ability WHERE race_id = ? AND ability_id = ?',
          [raceId, abilityId]
        );
        if (check.isNotEmpty) {
          return 'Errore: Esiste già un bonus per questa razza e abilità';
        }
      }

      var result = await conn.query(
        'INSERT INTO path_race_ability (race_id, ability_id, value) VALUES (?, ?, ?)',
        [raceId, abilityId, value]
      );

      return result.affectedRows == 1 ? 'Bonus assegnato con successo' : 'Errore nell\'assegnazione del bonus';
    } catch (e) {
      return 'Errore: $e';
    }
  }

  // Funzione per rimuovere un bonus/malus da una razza
  Future<String> removeRaceAbility(int raceId, int? abilityId) async {
    try {
      final conn = await DatabaseHelper().connection;
      var result = await conn.query(
        'DELETE FROM path_race_ability WHERE race_id = ? AND (ability_id = ? OR (ability_id IS NULL AND ? IS NULL))',
        [raceId, abilityId, abilityId]
      );

      return result.affectedRows == 1 ? 'Bonus rimosso con successo' : 'Errore nella rimozione del bonus';
    } catch (e) {
      return 'Errore: $e';
    }
  }

  // Funzione per modificare un bonus/malus esistente
  Future<String> updateRaceAbility(int raceId, int? abilityId, int newValue) async {
    try {
      final conn = await DatabaseHelper().connection;

      // Se si sta modificando per assegnare abilityId a NULL, verifica che non esista già un bonus generico
      if (abilityId == null) {
        var check = await conn.query(
          'SELECT COUNT(*) as count FROM path_race_ability WHERE race_id = ? AND ability_id IS NULL',
          [raceId]
        );
        if (check.first['count'] > 0) {
          return 'Errore: Esiste già un bonus generico per questa razza';
        }
      }

      var result = await conn.query(
        'UPDATE path_race_ability SET value = ? WHERE race_id = ? AND (ability_id = ? OR (ability_id IS NULL AND ? IS NULL))',
        [newValue, raceId, abilityId, abilityId]
      );

      return result.affectedRows == 1 ? 'Bonus modificato con successo' : 'Errore nella modifica del bonus';
    } catch (e) {
      return 'Errore: $e';
    }
  }


Future<List<Map<String, dynamic>>> getRaceAbilities(int raceId) async {
  try {
    final conn = await DatabaseHelper().connection;

    var results = await conn.query(
      'SELECT r.id AS race_id, r.name AS race_name, '
      'IFNULL(a.id, "") AS ability_id, '
      'IFNULL(a.name, "choose one ability") AS ability_name, '
      'pra.value '
      'FROM path_race_ability pra '
      'JOIN path_race r ON pra.race_id = r.id '
      'LEFT JOIN path_ability a ON pra.ability_id = a.id ' // Cambiato in LEFT JOIN
      'WHERE pra.race_id = ?',
      [raceId]
    );

    return results
        .map((row) => {
              'race_id': row['race_id'],
              'race_name': row['race_name'],
              'ability_id': row['ability_id'],
              'ability_name': row['ability_name'],
              'value': row['value']
            })
        .toList();
  } catch (e) {
    throw Exception('Errore nel recupero delle abilità per la razza: $e');
  }
}

Future<List<Map<String, dynamic>>> getRacesByAbility(int abilityId) async {
  try {
    final conn = await DatabaseHelper().connection;

    var results = await conn.query(
      'SELECT r.id AS race_id, r.name AS race_name, '
      'IFNULL(a.id, "") AS ability_id, '
      'IFNULL(a.name, "choose one ability") AS ability_name, '
      'pra.value '
      'FROM path_race_ability pra '
      'JOIN path_race r ON pra.race_id = r.id '
      'LEFT JOIN path_ability a ON pra.ability_id = a.id ' // Cambiato in LEFT JOIN
      'WHERE pra.ability_id = ?',
      [abilityId]
    );

    return results
        .map((row) => {
              'race_id': row['race_id'],
              'race_name': row['race_name'],
              'ability_id': row['ability_id'],
              'ability_name': row['ability_name'],
              'value': row['value']
            })
        .toList();
  } catch (e) {
    throw Exception('Errore nel recupero delle razze per l\'abilità: $e');
  }
}

}

