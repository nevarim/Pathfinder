export function attachConfigurationFormHandler() {
    const configurationForm = document.getElementById('configuration-form');
    if (configurationForm) {
      configurationForm.addEventListener('submit', async (event) => {
        event.preventDefault();
        const formData = new FormData(configurationForm);
        const data = {
          key: 'appTitle',
          value: formData.get('appTitle')
        };
  
        try {
          const response = await fetch('/api/configuration/set', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(data),
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
        }
      });
  
      fetch('/api/configuration/get')
        .then(response => response.json())
        .then(data => {
          document.getElementById('appTitle').value = data.value;
        })
        .catch(error => console.error('Error fetching configuration:', error));
    }
  }
  