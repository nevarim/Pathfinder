import { attachMenuToggleHandler } from './menu.js';
import { attachConfigurationFormHandler } from './configuration.js';
import { attachRegisterFormHandler, attachLoginFormHandler, attachLogoutHandler } from './auth.js';


document.addEventListener('DOMContentLoaded', () => {
  // Funzione che carica il contenuto di una pagina
  const loadContent = (page) => {
    fetch('/views/' + page + '.ejs')
      .then(response => {
        if (!response.ok) {
          throw new Error('Network response was not ok');
        }
        return response.text();
      })
      .then(data => {
        // Carica il contenuto nel div con id 'page-content'
        document.getElementById('page-content').innerHTML = data;

        // Inizializza i gestori di eventi specifici per la pagina
        if (page === 'configuration') attachConfigurationFormHandler();
        if (page === 'register') attachRegisterFormHandler();
        attachLoginFormHandler();
        attachLogoutHandler();
      })
      .catch(error => console.error('Error loading content:', error));
  }

  // Inizializza il menu e le funzionalità di login/logout
  attachMenuToggleHandler();
  attachLoginFormHandler();
  attachLogoutHandler();

  // Carica la pagina home al caricamento iniziale
  loadContent('home');
});



document.addEventListener('DOMContentLoaded', () => {
  const configurationButton = document.getElementById('configuration-button');
  if (configurationButton) {
    configurationButton.addEventListener('click', () => {
      loadContent('configuration');
    });
  }
});
