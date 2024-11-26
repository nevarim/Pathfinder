document.addEventListener('DOMContentLoaded', () => {
  window.loadContent = function(page) {  // Rendi la funzione accessibile globalmente
    fetch(`/${page}_content`)
      .then(response => response.text())
      .then(data => {
        document.getElementById('page-content').innerHTML = data;
        attachRegisterFormHandler(); // Assicura che il gestore dell'evento sia allegato
      })
      .catch(error => {
        console.error('Error loading content:', error);
      });
  }

  function attachRegisterFormHandler() {
    const registerForm = document.getElementById('register-form');
    if (registerForm) {
      registerForm.addEventListener('submit', async (event) => {
        event.preventDefault(); // Previene il comportamento predefinito del form
        const formData = new FormData(registerForm);
        const data = {
          username: formData.get('username'),
          password: formData.get('password')
        };

        try {
          const response = await fetch('/api/users/register', {
            method: 'POST',
            headers: {
              'Content-Type': 'application/json'
            },
            body: JSON.stringify(data)
          });

          const resultElement = document.getElementById('registration-result');
          if (response.ok) {
            resultElement.textContent = 'Registration successful!';
            loadContent('index'); // Ricarica la pagina principale dopo la registrazione
          } else {
            const errorText = await response.text();
            resultElement.textContent = `Error: ${errorText}`;
          }
        } catch (error) {
          console.error('Error during registration:', error);
          resultElement.textContent = 'Error during registration. Please try again.';
        }
      });
    }
  }

  // Carica la pagina iniziale e allega il gestore dell'evento per il modulo di registrazione
  loadContent('index');
});
