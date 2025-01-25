<?php

function getPermissionId($permission_name) {
    $url = 'http://localhost:8080/permissions/get-id';
    $data = array('permission_name' => $permission_name);

    // Stampa i dati JSON per verificarli
    //echo "<p>URL della richiesta per ottenere l'ID del permesso: $url</p>";
    //echo "<pre>";
    //echo "Dati JSON inviati: ";
    print_r(json_encode($data));
    //echo "</pre>";

    $options = array(
        'http' => array(
            'header' => "Content-type: application/json\r\n",
            'method' => 'POST',
            'content' => json_encode($data),
        ),
    );

    $context = stream_context_create($options);
    $result = @file_get_contents($url, false, $context);

    if ($result === FALSE) {
        $error = error_get_last();
        echo "<p>Error fetching permission ID: {$error['message']}</p>";
        return false;
    } else {
        $response_data = json_decode($result, true);
        echo "<p>Risposta della richiesta per ID permesso: " . json_encode($response_data) . "</p>";
        if (isset($response_data['permission_id'])) {
            return $response_data['permission_id'];
        } else {
            //echo "<p>Permission non trovata</p>";
            return false;
        }
    }
}

function createPermission($user_id, $permission_name, $description) {
    $url = 'http://localhost:8080/permissions/add';
    $data = array('user_id' => $user_id, 'permission_name' => $permission_name, 'description' => $description);

    // Stampa i dati JSON per verificarli
    //echo "<p>URL della richiesta per creare il permesso: $url</p>";
    //echo "<pre>";
    //echo "Dati JSON inviati: ";
    //print_r(json_encode($data));
    //echo "</pre>";

    $options = array(
        'http' => array(
            'header' => "Content-type: application/json\r\n",
            'method' => 'POST',
            'content' => json_encode($data),
        ),
    );

    $context = stream_context_create($options);
    $result = @file_get_contents($url, false, $context);

    if ($result === FALSE) {
        $error = error_get_last();
        echo "<p>Error creating permission: {$error['message']}</p>";
        return false;
    } else {
        $response_data = json_decode($result, true);
        echo "<p>Risposta della richiesta per creare permesso: " . json_encode($response_data) . "</p>";
        if (isset($response_data['permission_id'])) {
            return $response_data['permission_id'];
        } else {
            echo "<p>Failed to create permission</p>";
            return false;
        }
    }
}

function addPermissionForUser($user_id, $permission_name, $description) {
    $permission_id = getPermissionId($permission_name);
    if ($permission_id === false) {
        $permission_id = createPermission($user_id, $permission_name, $description);
        if ($permission_id === false) {
            return false;
        }
    }

    $url = 'http://localhost:8080/user-permissions/assign';
    $data = array(
        'user_id' => $user_id,
        'target_user_id' => $user_id,
        'permission_id' => $permission_id
    );

    // Stampa i dati JSON per verificarli
    //echo "<p>URL della richiesta per assegnare permesso: $url</p>";
    //echo "<pre>";
    //echo "Dati JSON inviati: ";
    //print_r(json_encode($data));
    //echo "</pre>";

    $options = array(
        'http' => array(
            'header' => "Content-type: application/json\r\n",
            'method' => 'POST',
            'content' => json_encode($data),
        ),
    );

    $context = stream_context_create($options);
    $result = @file_get_contents($url, false, $context);

    if ($result === FALSE) {
        $error = error_get_last();
        echo "<p>Error adding permission: {$error['message']}</p>";
    } else {
        echo "<p>Permesso aggiunto: $result</p>";
    }
}

function isLoggedIn() {
    return isset($_SESSION['username']);
}
?>
