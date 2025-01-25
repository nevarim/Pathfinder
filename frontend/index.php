<?php
session_start();
require_once('common_tools.php'); // Usa require_once per evitare inclusioni multiple
require_once('common_user.php'); // Usa require_once per evitare inclusioni multiple
require_once('Menu.php'); // Includi Menu.php per utilizzare la classe MenuItem
require_once('common_admin.php'); // pagine delle inclusioni per le funzioni di administrator

// Funzione per caricare le pagine dinamiche
function loadPage() {
    if (isset($_GET['page'])) {
        $page = $_GET['page'];
        $file = "pages/{$page}.php";
        if (file_exists($file)) {
            include($file);
        } else {
            echo "<h2>Errore</h2><p>Pagina '{$page}' non trovata.</p>";
        }
    } else {
        echo "<h2>Home</h2><p>Benvenuto nella pagina Home!</p>";
    }
}
require_once('serverpost.php'); // Includi Menu.php per utilizzare la classe MenuItem

// Controlla se l'utente ha il permesso "IsUser" e assegna automaticamente se non presente
if (isLoggedIn()) {
    include('permissions.php');
}

// Se la sessione è attiva ma l'azione non è `login`
if (isset($_SESSION['username']) && !isset($_POST['action'])) {
    // Recupera le informazioni dell'utente tramite il nome utente
    $username = $_SESSION['username'];
    $user_data = getUserByUsername($username);

    if ($user_data !== null) {
        $_SESSION['email'] = $user_data['email'];
        $_SESSION['user_id'] = $user_data['id'];
        $_SESSION['is_active'] = $user_data['is_active'];
        $_SESSION['is_debug'] = $user_data['is_debug'];
    }
}
?>

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PathProject - Gestione Utenti</title>
    <link rel="stylesheet" href="styles.css">
</head>
    <link rel="stylesheet" href="css/wysiwyg.css">
<body>
    <header>
        <button id="menu-toggle">☰</button>
        <h1>PathProject</h1>
        <div id="auth-forms">
            <?php if (!isLoggedIn()): ?>
                <form action="index.php" method="post">
                    <input type="hidden" name="action" value="login">
                    <input type="text" name="identifier" placeholder="Username or Email" required>
                    <input type="password" name="password" placeholder="Password" required>
                    <button type="submit">Login</button>
                </form>
            <?php else: ?>
                <form action="index.php" method="post">
                    <input type="hidden" name="action" value="logout">
                    <input type="hidden" name="user_id" value="<?php echo $_SESSION['user_id']; ?>">
                    <span>Benvenuto, <?php echo $_SESSION['username']; ?>!</span>
                    <button type="submit">Logout</button>
                    <a href="register.php">Register</a>
                </form>
            <?php endif; ?>
        </div>
    </header>
    
    <div id="container">
        <?php 
        if (isset($_SESSION['user_permissions'])) {
            generateMenu($menu, $_SESSION['user_permissions']); // Genera il menu dinamicamente
        } else {
            // Genera il menu "General" anche se non loggato
            echo '<aside id="sidebar">';
            echo '<div class="menu-block">';
            echo '<h3>General</h3>';
            echo '<ul>';
            foreach ($menu['General'] as $menuItem) {
                echo '<li><a href="index.php?page=' . $menuItem->page . '" data-description="' . $menuItem->description . '">' . $menuItem->title . '</a></li>';
            }
            echo '</ul>';
            echo '</div>';
            //echo '<p>Effettua il login per visualizzare il menu completo.</p>';
            echo '</aside>';
        }
        ?>

        <main id="content">
            <?php loadPage(); ?>
        </main>
    </div>
    
    <footer>
        <!-- Footer content -->
    </footer>
    
    <script src="js/wysiwyg.js"></script>
    <script src="script.js"></script>
</body>
</html>
