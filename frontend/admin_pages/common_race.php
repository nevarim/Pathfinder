<?php

// Funzione per ottenere tutte le razze
function getRaces() {
    $url = 'http://localhost:8080/race/list';
    $response = @file_get_contents($url);

    if ($response === FALSE) {
        $error = error_get_last();
        echo "<p>Error fetching race data: {$error['message']}</p>";
        return [];
    } else {
        return json_decode($response, true);
		echo json_decode($response, true);
    }
}

// Funzione per ottenere i dettagli di una razza dato il suo ID
function getRaceById($id) {
    $url = "http://localhost:8080/race/{$id}";
    $response = @file_get_contents($url);

    if ($response === FALSE) {
        $error = error_get_last();
        echo "<p>Error fetching race data: {$error['message']}</p>";
        return null;
    } else {
        return json_decode($response, true);
    }
}

// Funzione per aggiungere una nuova razza
function addRace($name, $description) {
    $url = 'http://localhost:8080/race/add';
    $data = array('name' => $name, 'description' => $description);
    $json_data = json_encode($data);

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
        echo "<p>Error adding race: {$error['message']}</p>";
        return false;
    } else {
        return json_decode($result, true);
    }
}

// Funzione per modificare una razza
function editRace($id, $name, $description) {
    $url = 'http://localhost:8080/race/edit';
    $data = array('id' => $id, 'name' => $name, 'description' => $description);
    $json_data = json_encode($data);

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
        echo "<p>Error editing race: {$error['message']}</p>";
        return false;
    } else {
        return json_decode($result, true);
    }
}

// Funzione per disattivare una razza
function inactivateRace($id) {
    $url = 'http://localhost:8080/race/inactivate';
    $data = array('id' => $id);
    $json_data = json_encode($data);

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
        echo "<p>Error inactivating race: {$error['message']}</p>";
        return false;
    } else {
        return json_decode($result, true);
    }
}

// Gestione delle richieste POST
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $action = $_POST['action'];
    switch ($action) {
        case 'add_race':
            $name = $_POST['race_name'];
            $description = $_POST['race_description'];
            addRace($name, $description);
            break;
        case 'edit_race':
            $id = $_POST['race_id'];
            $name = $_POST['race_name'];
            $description = $_POST['race_description'];
            editRace($id, $name, $description);
            break;
        case 'inactivate_race':
            $id = $_POST['race_id'];
            inactivateRace($id);
            break;
    }
}
?>
