document.getElementById('register-form').addEventListener('submit', function(event) {
    var password = document.getElementById('password').value;
    var confirmPassword = document.getElementById('confirm-password').value;
    var errorMessage = document.getElementById('error-message');

    if (password !== confirmPassword) {
        errorMessage.textContent = "Le password non coincidono.";
        event.preventDefault();
    }
    
    var fields = ['username', 'email', 'password', 'confirm-password'];
    for (var i = 0; i < fields.length; i++) {
        if (document.getElementById(fields[i]).value === '') {
            errorMessage.textContent = "Tutti i campi sono obbligatori.";
            event.preventDefault();
            return;
        }
    }
});

function checkAvailability(field, value, callback) {
    var url = '';
    if (field === 'username') {
        url = 'http://localhost:8080/user/get-by-username/' + value;
    } else if (field === 'email') {
        url = 'http://localhost:8080/user/get-by-email/' + value;
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

document.getElementById('username').addEventListener('blur', function() {
    var username = document.getElementById('username').value;
    var errorMessage = document.getElementById('error-message');

    checkAvailability('username', username, function(isAvailable) {
        if (!isAvailable) {
            errorMessage.textContent = "Username già esistente.";
            document.getElementById('register-button').disabled = true;
            document.getElementById('register-button').classList.remove('enabled');
        } else {
            errorMessage.textContent = "";
            validateForm();
        }
    });
});

document.getElementById('email').addEventListener('blur', function() {
    var email = document.getElementById('email').value;
    var errorMessage = document.getElementById('error-message');

    checkAvailability('email', email, function(isAvailable) {
        if (!isAvailable) {
            errorMessage.textContent = "Email già esistente.";
            document.getElementById('register-button').disabled = true;
            document.getElementById('register-button').classList.remove('enabled');
        } else {
            errorMessage.textContent = "";
            validateForm();
        }
    });
});

function validateForm() {
    var allFilled = true;
    var password = document.getElementById('password').value;
    var confirmPassword = document.getElementById('confirm-password').value;
    var errorMessage = document.getElementById('error-message');

    document.querySelectorAll('#register-form input').forEach(function(input) {
        if (input.value === '') {
            allFilled = false;
        }
    });

    if (allFilled && password === confirmPassword) {
        document.getElementById('register-button').disabled = false;
        document.getElementById('register-button').classList.add('enabled');
    } else {
        document.getElementById('register-button').disabled = true;
        document.getElementById('register-button').classList.remove('enabled');
    }
}

document.querySelectorAll('#register-form input').forEach(function(input) {
    input.addEventListener('input', function() {
        validateForm();
    });
});
