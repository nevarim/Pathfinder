<?php
// Non includiamo `session_start()` perché la sessione è già attiva
// Non includiamo `common_tools.php` perché è già incluso in `index.php`

function hasPermission($permission) {
    return in_array($permission, $_SESSION['user_permissions'] ?? []);
}

// Recupera le informazioni dell'utente tramite il nome utente
$username = $_SESSION['username'] ?? null; // Assicurati che il nome utente sia memorizzato in sessione come 'username'
if ($username === null) {
    echo "<p>Errore: nome utente non trovato nella sessione.</p>";
    exit;
}

$user_data = getUserByUsername($username);

if ($user_data === null) {
    $user_data = ['is_active' => false, 'is_debug' => false, 'username' => '']; // Valori predefiniti in caso di errore
}
?>

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Impostazioni Utente - PathProject</title>
    <link rel="stylesheet" href="pages/usersettings.css">
</head>
<body>
    <div class="usersettings-container">
        <h2>Impostazioni Utente</h2>
        <form action="index.php" method="post">
            <input type="hidden" name="action" value="update_user">
            <table class="usersettings-table">
                <tr>
                    <td><label for="username">Username:</label></td>
                    <td><input type="text" id="username" name="username" required value="<?php echo htmlspecialchars($user_data['username']); ?>"></td>
                </tr>
                <tr>
                    <td><label for="password">Password:</label></td>
                    <td><input type="password" id="password" name="password"></td>
                </tr>
                <tr>
                    <td><label for="confirm-password">Conferma Password:</label></td>
                    <td><input type="password" id="confirm-password" name="confirm-password"></td>
                </tr>
                <?php if (hasPermission('IsAdmin')): ?>
                    <tr>
                        <td><label for="is-debug">Modalità Debug:</label></td>
                        <td><input type="checkbox" id="is-debug" name="is_debug" <?php echo $user_data['is_debug'] ? 'checked' : ''; ?>></td>
                    </tr>
                    <tr>
                        <td><label for="is-active">Attivo:</label></td>
                        <td><input type="checkbox" id="is-active" name="is_active" <?php echo $user_data['is_active'] ? 'checked' : ''; ?>></td>
                    </tr>
                <?php else: ?>
                    <input type="hidden" id="is-debug" name="is_debug" value="<?php echo $user_data['is_debug'] ? '1' : '0'; ?>">
                    <input type="hidden" id="is-active" name="is_active" value="<?php echo $user_data['is_active'] ? '1' : '0'; ?>">
                <?php endif; ?>
            </table>
            <button type="submit">Salva</button>
        </form>
    </div>
    <p id="error-message" class="usersettings-error"></p>
    <script src="pages/usersettings.js"></script>
</body>
</html>
