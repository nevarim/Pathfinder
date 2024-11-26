function loadContent(page) {
  fetch('/views/' + page + '.ejs')
    .then(response => {
      if (!response.ok) {
        throw new Error('Network response was not ok');
      }
      return response.text();
    })
    .then(data => {
      document.getElementById('page-content').innerHTML = data;

      // Inizializza comportamenti in base alla pagina caricata
      if (page === 'configuration') attachConfigurationFormHandler();
      if (page === 'register') attachRegisterFormHandler();
      attachLoginFormHandler();
      attachLogoutHandler();
    })
    .catch(error => console.error('Error loading content:', error));
}

// Handler per la registrazione
export function attachRegisterFormHandler() {
  const registerForm = document.getElementById('register-form');
  if (registerForm) {
    registerForm.addEventListener('submit', async (event) => {
      event.preventDefault();
      const formData = new FormData(registerForm);
      const data = {
        username: formData.get('username'),
        password: formData.get('password')
      };

      try {
        const response = await fetch('/api/users/register', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify(data),
        });

        const resultElement = document.getElementById('registration-result');
        if (response.ok) {
          resultElement.textContent = 'Registration successful!';
        } else {
          const errorText = await response.text();
          resultElement.textContent = `Error: ${errorText}`;
        }
      } catch (error) {
        console.error('Error during registration:', error);
      }
    });
  }
}

// Handler per il login
export function attachLoginFormHandler() {
  const loginForm = document.getElementById('login-form');
  if (loginForm) {
    loginForm.addEventListener('submit', async (event) => {
      event.preventDefault();
      const formData = new FormData(loginForm);
      const data = {
        username: formData.get('username'),
        password: formData.get('password')
      };

      try {
        const response = await fetch('/api/users/login', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify(data),
        });

        if (response.ok) {
          loadContent('home');
          refreshHeader();
        } else {
          console.error('Login failed');
        }
      } catch (error) {
        console.error('Error during login:', error);
      }
    });
  }
}

// Handler per il logout
export function attachLogoutHandler() {
  const logoutButton = document.getElementById('logout');
  if (logoutButton) {
    logoutButton.addEventListener('click', async () => {
      try {
        const response = await fetch('/api/users/logout', { method: 'POST' });
        if (response.ok) {
          loadContent('home');
          refreshHeader();
        }
      } catch (error) {
        console.error('Error during logout:', error);
      }
    });
  }
}

// Funzione per aggiornare l'header
export function refreshHeader() {
  fetch('/header')
    .then(response => response.text())
    .then(html => {
      document.querySelector('header').innerHTML = html;
      attachLoginFormHandler();
      attachLogoutHandler();
    })
    .catch(error => console.error('Error refreshing header:', error));
}
