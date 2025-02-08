import '../database.dart';
import '../models/class.dart';

class ClassService {
  Future<List<Class>> getAllClasses() async {
    final conn = await DatabaseHelper().connection;
    final results = await conn.query('SELECT id, name, is_active FROM classes');
    return results.map((row) => Class.fromJson(row.fields)).toList();
  }

  Future<Class?> getClassById(int id) async {
    final conn = await DatabaseHelper().connection;
    final results = await conn.query(
      'SELECT id, name, is_active FROM classes WHERE id = ?',
      [id],
    );
    if (results.isNotEmpty) {
      return Class.fromJson(results.first.fields);
    }
    return null;
  }

  Future<void> addClass(String name) async {
    final conn = await DatabaseHelper().connection;
    await conn.query('INSERT INTO classes (name, is_active) VALUES (?, ?)', [name, 1]);
  }

  Future<void> updateClass(int id, String name) async {
    final conn = await DatabaseHelper().connection;
    await conn.query('UPDATE classes SET name = ? WHERE id = ?', [name, id]);
  }

  Future<void> deactivateClass(int id) async {
    final conn = await DatabaseHelper().connection;
    await conn.query('UPDATE classes SET is_active = 0 WHERE id = ?', [id]);
  }
}
