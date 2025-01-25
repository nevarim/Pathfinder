<?php

require_once('common_tools.php');
require_once('common_user.php'); // Includi common_user.php per usare la funzione updateUser

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $action = $_POST['action'];
    $url = '';
    $json_data = '';
    $data = [];
    switch ($action) {
        case 'update_user':
            $user_id = $_SESSION['user_id'] ?? null;
            $username = $_POST['username'];
            $password = $_POST['password'];
            $is_debug = isset($_POST['is_debug']);
            $is_active = isset($_POST['is_active']);
            updateUser($user_id, $username, $password, $is_debug, $is_active); // Usa la funzione updateUser
            break;
        case 'register':
            $username = $_POST['username'];
            $email = $_POST['email'];
            $password = $_POST['password'];
            $url = 'http://localhost:8080/register';
            $data = array('username' => $username, 'email' => $email, 'password' => $password);
            break;
        case 'login':
            $identifier = $_POST['identifier'];
            $password = $_POST['password'];
            $url = 'http://localhost:8080/login';
            $data = array('identifier' => $identifier, 'password' => $password);
            break;
        case 'logout':
            $user_id = $_SESSION['user_id'] ?? null;
            $url = 'http://localhost:8080/logout';
            $data = array('user_id' => $user_id);
            break;
    }

    // Codifica i dati in JSON se necessario
    if (!empty($data)) {
        $json_data = json_encode($data);
        // echo "<pre>";
        // print_r($json_data);
        // echo "</pre>";

        $options = array(
            'http' => array(
                'header' => "Content-type: application/json\r\n",
                'method' => 'POST',
                'content' => $json_data,
            ),
        );
        $context = stream_context_create($options);
        $result = @file_get_contents($url, false, $context);

        if ($result === FALSE) {
            $error = error_get_last();
            // echo "<p>Error: {$error['message']}</p>";

            // Forza il logout anche se si verifica un errore
            if ($action === 'logout') {
                session_destroy();
                // echo "<p>Logout effettuato con errore!</p>";
                header("Refresh:0"); // Aggiorna la pagina per riflettere lo stato di logout
            }
        } else {
            $response_data = json_decode($result, true);
            // echo "<pre>";
            // print_r($response_data); // Stampa la risposta JSON per verificarla
            // echo "</pre>";

            if ($action === 'login' && isset($response_data['session_token'])) {
                $_SESSION['username'] = $response_data['username'] ?? $identifier;
                $_SESSION['email'] = $response_data['email'] ?? null; // Assicura che l'email sia presente nella sessione
                $_SESSION['session_token'] = $response_data['session_token'];
                $_SESSION['user_id'] = $response_data['user_id'] ?? null; // Assicura che l'ID utente sia presente nella sessione

                // Verifica immediata della sessione
                echo "<pre>";
                print_r($_SESSION);
                echo "</pre>";

                // echo "<p>Login effettuato con successo!</p>"; // Commentato come richiesto
            } elseif ($action === 'register' && isset($response_data['user_id'])) {
                echo "<p>Registrazione avvenuta con successo!</p>";
            } elseif ($action === 'update_user' && isset($response_data['user_id'])) {
                echo "<p>Impostazioni utente aggiornate con successo!</p>";
            } elseif ($action === 'logout' && isLoggedIn()) {
                session_destroy();
                // echo "<p>Logout effettuato con successo!</p>";
                header("Refresh:0"); // Aggiorna la pagina per riflettere lo stato di logout
            } else {
                // echo "<p>Risultato: $result</p>"; // Commentato come richiesto
            }
        }
    }
}
?>
