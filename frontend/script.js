document.addEventListener('DOMContentLoaded', () => {
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
          headers: {
            'Content-Type': 'application/json'
          },
          body: JSON.stringify(data)
        });

        const resultElement = document.getElementById('registration-result');
        if (response.ok) {
          resultElement.textContent = 'Registration successful!';
          loadContent('/'); // Ricarica la pagina principale dopo la registrazione
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

  function loadContent(page) {
    fetch(page)
      .then(response => response.text())
      .then(data => {
        document.getElementById('page-content').innerHTML = data;
      })
      .catch(error => {
        console.error('Error loading content:', error);
      });
  }
});

function loadContent(page) {
  fetch(`/${page}`)
    .then(response => response.text())
    .then(data => {
      document.getElementById('page-content').innerHTML = data;
    })
    .catch(error => {
      console.error('Error loading content:', error);
    });
}
