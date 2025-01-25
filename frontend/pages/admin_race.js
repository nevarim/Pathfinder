document.querySelector('form').addEventListener('submit', function(event) {
    var raceName = document.getElementById('race-name').value.trim();
    var raceDescription = document.getElementById('race-description').value.trim();
    var errorMessage = document.getElementById('error-message');

    if (raceName === '' || raceDescription === '') {
        event.preventDefault();
        if (!errorMessage) {
            errorMessage = document.createElement('p');
            errorMessage.id = 'error-message';
            errorMessage.textContent = 'Tutti i campi sono obbligatori.';
            errorMessage.style.color = 'red';
            document.querySelector('.admin-race-container').appendChild(errorMessage);
        } else {
            errorMessage.textContent = 'Tutti i campi sono obbligatori.';
        }
    }
});

document.querySelectorAll('.edit-button').forEach(function(button) {
    button.addEventListener('click', function() {
        var id = this.dataset.id;
        // Logica per modificare la razza con l'ID specificato
        console.log('Modifica razza con ID:', id);
    });
});

document.querySelectorAll('.deactivate-button').forEach(function(button) {
    button.addEventListener('click', function() {
        var id = this.dataset.id;
        // Logica per rendere inattiva la razza con l'ID specificato
        console.log('Rendi inattiva razza con ID:', id);
    });
});
