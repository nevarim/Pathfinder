document.getElementById('usersettings-form').addEventListener('submit', function(event) {
    var password = document.getElementById('password').value;
    var confirmPassword = document.getElementById('confirm-password').value;
    var errorMessage = document.getElementById('error-message');

    if (password !== '' && password !== confirmPassword) {
        errorMessage.textContent = "Le password non coincidono.";
        event.preventDefault();
    }
    
    var fields = ['username', 'password', 'confirm-password'];
    for (var i = 0; i < fields.length; i++) {
        if (document.getElementById(fields[i]).value === '' && fields[i] !== 'password' && fields[i] !== 'confirm-password') {
            errorMessage.textContent = "Tutti i campi obbligatori devono essere compilati.";
            event.preventDefault();
            return;
        }
    }
});

function checkAvailability(field, value, callback) {
    var url = '';
    if (field === 'username') {
        url = 'http://localhost:8080/user/get-by-username/' + value;
    }

    // Log del JSON utilizzato per la richiesta
    console.log("URL della richiesta per " + field + ": " + url);

    fetch(url)
        .then(response => response.json())
        .then(data => {
            console.log("Risposta della richiesta per " + field + ": ", data);
            if (data.id) {
                callback(false); // Se l'utente esiste già
            } else {
                callback(true);
            }
        })
        .catch(error => {
            console.error('Errore durante la verifica della disponibilità:', error);
            callback(true); // In caso di errore, permetti comunque la registrazione
        });
}

document.querySelectorAll('#usersettings-form input').forEach(function(input) {
    input.addEventListener('input', function() {
        var allFilled = true;
        var password = document.getElementById('password').value;
        var confirmPassword = document.getElementById('confirm-password').value;
        var errorMessage = document.getElementById('error-message');

        document.querySelectorAll('#usersettings-form input').forEach(function(input) {
            if (input.value === '' && input.id !== 'password' && input.id !== 'confirm-password') {
                allFilled = false;
            }
        });

        if (allFilled && (password === confirmPassword || password === '' && confirmPassword === '')) {
            var username = document.getElementById('username').value;

            checkAvailability('username', username, function(isAvailable) {
                if (!isAvailable) {
                    errorMessage.textContent = "Username già esistente.";
                    document.getElementById('usersettings-button').disabled = true;
                    document.getElementById('usersettings-button').classList.remove('enabled');
                } else {
                    errorMessage.textContent = "";
                    document.getElementById('usersettings-button').disabled = false;
                    document.getElementById('usersettings-button').classList.add('enabled');
                }
            });
        } else {
            document.getElementById('usersettings-button').disabled = true;
            document.getElementById('usersettings-button').classList.remove('enabled');
        }
    });
});
