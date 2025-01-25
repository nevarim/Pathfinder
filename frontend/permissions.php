<?php
require_once('common_tools.php');
require_once('Menu.php');

if (isLoggedIn()) {
    $user_id = $_SESSION['user_id'];

    // Recupera i permessi dell'utente
    $url = 'http://localhost:8080/user-permissions/' . $user_id;
    //echo "<p>URL della richiesta: $url</p>";
    $response = @file_get_contents($url);

    if ($response === FALSE) {
        $error = error_get_last();
        echo "<p>Error fetching permissions: {$error['message']}</p>";
    } else {
        $permissions_data = json_decode($response, true);
        //echo "<p>Risposta della richiesta: " . json_encode($permissions_data) . "</p>";

        // Estrai i nomi dei permessi
        $_SESSION['user_permissions'] = array_column($permissions_data, 'permission_name');
        //echo "<p>Lista dei permessi: " . implode(", ", $_SESSION['user_permissions']) . "</p>";

        // Controlla se l'utente ha il permesso 'IsUser'
        if (!in_array('IsUser', $_SESSION['user_permissions'])) {
            // Assegna automaticamente il permesso 'IsUser'
            $result = addPermissionForUser($user_id, 'IsUser', 'Permesso utente base');
            echo "<p>Permesso 'IsUser' assegnato: $result</p>";
        } else {
            //echo "<p>IsUser è già stato assegnato</p>";
        }

        // Utilizza l'array del menu per aggiungere i permessi
        foreach ($menu as $block => $items) {
            foreach ($items as $menuItem) {
                $permission_name = 'view_page_' . $menuItem->page;
                if (!in_array($permission_name, $_SESSION['user_permissions'])) {
                    $result = addPermissionForUser($user_id, $permission_name, $menuItem->description);
                    echo "<p>Permesso aggiunto: $permission_name - $result</p>";
                }
            }
        }
    }
}
?>
