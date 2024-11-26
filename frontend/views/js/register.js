document.addEventListener("DOMContentLoaded", function() {
    document.body.classList.add('register-body');
  });
  
  document.getElementById("register-form").addEventListener("submit", function(event) {
    event.preventDefault();
  
    const username = event.target.username.value;
    const password = event.target.password.value;
  
    // Logica per la registrazione (esempio)
    if (username && password) {
      document.getElementById("registration-result").innerText = "Registrazione completata con successo!";
    } else {
      document.getElementById("registration-result").innerText = "Compila tutti i campi!";
    }
  });
  