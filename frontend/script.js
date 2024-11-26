document.addEventListener('DOMContentLoaded', () => {
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
            loadContent('register'); // Ricarica la pagina principale dopo la registrazione
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
  loadContent('home');
});

function loadContent(page) {
  fetch('views/' + page + '.ejs')
      .then(response => {
          if (!response.ok) {
              throw new Error('Network response was not ok ' + response.statusText);
          }
          return response.text();
      })
      .then(data => {
          document.getElementById('page-content').innerHTML = data;
      })
      .catch(error => {
          console.error('There was a problem with the fetch operation:', error);
      });
}
