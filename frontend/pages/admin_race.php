<?php
$races = getRaces();
?>
    <link rel="stylesheet" href="pages/admin_race.css">
    <div class="admin-race-container">
        <h2>Gestione Razze</h2>
        <table class="admin-race-table">
            <thead>
                <tr>
                    <th>Nome Razza</th>
                    <th>Descrizione</th>
                    <th>Stato</th>
                    <th>Azioni</th>
                </tr>
            </thead>
            <tbody>
                <?php foreach ($races as $race): ?>
                    <tr>
                        <td><?php echo htmlspecialchars($race['name'] ?? ''); ?></td>
                        <td><?php echo htmlspecialchars($race['description'] ?? ''); ?></td>
                        <td><?php echo $race['is_active'] ? 'Attivo' : 'Inattivo'; ?></td>
                        <td>
                            <button class="edit-button" data-id="<?php echo $race['id']; ?>">Modifica</button>
                            <button class="deactivate-button" data-id="<?php echo $race['id']; ?>">Rendi Inattivo</button>
                        </td>
                    </tr>
                <?php endforeach; ?>
            </tbody>
        </table>

        <h2>Aggiungi Nuova Razza</h2>
        <form action="index.php?page=admin_race" method="post">
            <input type="hidden" name="action" value="add_race">
            <label for="race-name">Nome Razza:</label>
            <input type="text" id="race-name" name="race_name" required>
            <label for="race-description">Descrizione Razza:</label>
            <div id="race-description" class="editor" contenteditable="true">
                    <p>Editor 1: Puoi iniziare a scrivere qui...</p>
            </div>
            <button type="submit">Aggiungi Razza</button>
        </form>
    </div>
    <script src="pages/admin_race.js"></script>

