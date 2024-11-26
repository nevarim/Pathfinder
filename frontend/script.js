document.addEventListener('DOMContentLoaded', () => {
  function loadContent(page) {
    fetch('/views/' + page + '.ejs')
      .then(response => {
        if (!response.ok) {
          throw new Error('Network response was not ok ' + response.statusText);
        }
        return response.text();
      })
      .then(data => {
        document.getElementById('page-content').innerHTML = data;
        if (page === 'configuration') {
          attachConfigurationFormHandler();
        } else if (page === 'register') {
          attachRegisterFormHandler(); // Riattacca il gestore degli eventi al caricamento del contenuto
        }
        attachLoginFormHandler();
        attachLogoutHandler();
      })
      .catch(error => {
        console.error('There was a problem with the fetch operation:', error);
      });
  }

  function attachConfigurationFormHandler() {
    const configurationForm = document.getElementById('configuration-form');
    if (configurationForm) {
      configurationForm.addEventListener('submit', async (event) => {
        event.preventDefault(); // Previene il comportamento predefinito del form
        const formData = new FormData(configurationForm);
        const data = {
          key: 'appTitle',
          value: formData.get('appTitle')
        };

        try {
          const response = await fetch('/api/configuration/set', {
            method: 'POST',
            headers: {
              'Content-Type': 'application/json'
            },
            body: JSON.stringify(data)
          });

          const resultElement = document.getElementById('configuration-result');
          if (response.ok) {
            resultElement.textContent = 'Configuration saved successfully!';
          } else {
            const errorText = await response.text();
            resultElement.textContent = `Error: ${errorText}`;
          }
        } catch (error) {
          console.error('Error saving configuration:', error);
          resultElement.textContent = 'Error saving configuration. Please try again.';
        }
      });

      // Carica il valore corrente della configurazione al caricamento della pagina
      fetch('/api/configuration/get')
        .then(response => response.json())
        .then(data => {
          document.getElementById('appTitle').value = data.value;
        })
        .catch(error => console.error('Error fetching configuration:', error));
    }
  }

  function attachMenuToggleHandler() {
    document.addEventListener('click', toggleMenu); // Utilizza la delegazione degli eventi per il menu toggle
  }

  function toggleMenu(event) {
    const sidebar = document.getElementById('sidebar');
    if (event.target && event.target.id === 'menu-toggle') {
      console.log('Menu toggle clicked'); // Verifica che il click funzioni
      if (sidebar.classList.contains('hidden')) {
        sidebar.classList.remove('hidden'); // Rendi visibile il menu
        console.log('Sidebar is now visible'); // Log per confermare che il menu è visibile
      } else {
        sidebar.classList.add('hidden'); // Nascondi il menu
        console.log('Sidebar is now hidden'); // Log per confermare che il menu è nascosto
      }
      console.log('Updated Sidebar class list:', sidebar.classList); // Verifica la lista di classi del sidebar
    }
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
            loadContent('home'); // Ricarica la pagina principale dopo la registrazione
            refreshHeader(); // Ricarica l'header
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

  function attachLoginFormHandler() {
    const loginForm = document.getElementById('login-form');
    if (loginForm) {
      loginForm.addEventListener('submit', async (event) => {
        event.preventDefault(); // Previene il comportamento predefinito del form
        const formData = new FormData(loginForm);
        const data = {
          username: formData.get('username'),
          password: formData.get('password')
        };

        try {
          const response = await fetch('/api/users/login', {
            method: 'POST',
            headers: {
              'Content-Type': 'application/json'
            },
            body: JSON.stringify(data)
          });

          const resultElement = document.getElementById('login-result');
          console.log('Response status:', response.status); // Aggiungi log per lo stato della risposta
          const responseBody = await response.json(); // Cambia in JSON per gestire la risposta correttamente
          console.log('Response body:', responseBody); // Aggiungi log per il corpo della risposta
          if (response.ok) {
            console.log('Login successful'); // Log per verificare la risposta positiva
            resultElement.textContent = 'Login successful!';
            loadContent('home'); // Reindirizza alla home page dopo il login
            refreshHeader(); // Ricarica l'header per mostrare il form di logout
          } else {
            console.log('Login failed:', responseBody.message); // Log per verificare la risposta negativa
            resultElement.textContent = `Error: ${responseBody.message}`;
          }
        } catch (error) {
          console.error('Error during login:', error);
          const resultElement = document.getElementById('login-result');
          if (resultElement) {
            resultElement.textContent = 'Error during login. Please try again.';
          }
        }
      });
    }
  }

  function attachLogoutHandler() {
    const logoutButton = document.getElementById('logout');
    if (logoutButton) {
      logoutButton.addEventListener('click', async (event) => {
        event.preventDefault();
        try {
          const response = await fetch('/api/users/logout', {
            method: 'POST'
          });

          if (response.ok) {
            console.log('Logout successful'); // Log per verificare la risposta positiva
            loadContent('home'); // Reindirizza alla home page dopo il logout
            refreshHeader(); // Ricarica l'header per mostrare il form di login
          } else {
            console.error('Error during logout');
          }
        } catch (error) {
          console.error('Error during logout:', error);
        }
      });
    }
  }

  function refreshHeader() {
    fetch('/header') // Supponendo che tu abbia una rotta per ricaricare l'header
      .then(response => response.text())
      .then(html => {
        document.querySelector('header').innerHTML = html;
        attachLoginFormHandler(); // Riattacca il gestore del modulo di login
        attachLogoutHandler(); // Riattacca il gestore del modulo di logout
      })
      .catch(error => console.error('Error refreshing header:', error));
  }

  // Inizializzazione dei gestori degli eventi dopo che il DOM è stato completamente caricato
  attachMenuToggleHandler();
  loadContent('home');
  attachLoginFormHandler();
  attachLogoutHandler();
});

