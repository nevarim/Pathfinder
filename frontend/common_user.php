<?php
	function getUserByEmail($email) {
	//    $url = 'http://localhost:8080/user/get-by-email/' . urlencode($email);
		$url = 'http://localhost:8080/user/get-by-email/' . ($email);
		$response = @file_get_contents($url);

		if ($response === FALSE) {
			$error = error_get_last();
			echo "<p>Error fetching user data: {$error['message']}</p>";
			return null;
		} else {
			return json_decode($response, true);
		}
	}

	function getUserByUsername($username) {
		$url = 'http://localhost:8080/user/get-by-username/' . urlencode($username);
		$response = @file_get_contents($url);

		if ($response === FALSE) {
			$error = error_get_last();
			echo "<p>Error fetching user data: {$error['message']}</p>";
			return null;
		} else {
			return json_decode($response, true);
		}
	}

	function updateUser($user_id, $username, $password, $is_debug, $is_active) {
    $url = 'http://localhost:8080/user/update';
    $data = array(
        'user_id' => $user_id,
        'username' => $username,
        'password' => $password,
        'is_debug' => $is_debug,
        'is_active' => $is_active
    );

    // Stampa i dati JSON per verificarli
    //echo "<p>URL della richiesta per aggiornare l'utente: $url</p>";
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
        echo "<p>Error updating user: {$error['message']}</p>";
        return false;
    } else {
        $response_data = json_decode($result, true);
        echo "<p>Risposta della richiesta per aggiornare l'utente: " . json_encode($response_data) . "</p>";
        return $response_data;
    }
}
?>