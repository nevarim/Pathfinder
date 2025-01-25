import '../database.dart';

class UserPageService {
  // Assegnare una pagina a un utente
  Future<String> assignPageToUser(int userId, int pageId) async {
    final conn = await DatabaseHelper().connection;

    // Verifica se la relazione esiste già
    var check = await conn.query(
        'SELECT * FROM user_pages WHERE user_id = ? AND page_id = ?', 
        [userId, pageId]);

    if (check.isNotEmpty) {
      return 'Errore: La pagina è già associata a questo utente';
    }

    // Aggiungi la relazione
    var result = await conn.query(
        'INSERT INTO user_pages (user_id, page_id) VALUES (?, ?)',
        [userId, pageId]);

    return result.affectedRows == 1 ? 'Pagina assegnata all\'utente con successo' : 'Errore nell\'assegnazione';
  }

  // Rimuovere la pagina da un utente
  Future<String> removePageFromUser(int userId, int pageId) async {
    final conn = await DatabaseHelper().connection;

    // Rimuovi la relazione
    var result = await conn.query(
        'DELETE FROM user_pages WHERE user_id = ? AND page_id = ?', 
        [userId, pageId]);

    return result.affectedRows == 1 ? 'Pagina rimossa dall\'utente con successo' : 'Errore nella rimozione';
  }

  // Visualizzare le pagine assegnate a un utente
  Future<List<Map<String, dynamic>>> getUserPages(int userId) async {
    final conn = await DatabaseHelper().connection;

    var result = await conn.query(
        '''
        SELECT p.page_name, up.page_id
        FROM pages p
        JOIN user_pages up ON p.id = up.page_id
        WHERE up.user_id = ?
        ''', 
        [userId]);

    return result.map((row) => {
      'page_id': row[1],
      'page_name': row[0],
    }).toList();
  }

  Future<int?> getPageIdByName(String pageName) async {
  final conn = await DatabaseHelper().connection;

  var result = await conn.query(
      'SELECT id FROM pages WHERE page_name = ?',
      [pageName]);

  if (result.isNotEmpty) {
    return result.first[0]; // Restituisce l'ID della pagina
  } else {
    return null; // Nessuna pagina trovata
  }
}

}
