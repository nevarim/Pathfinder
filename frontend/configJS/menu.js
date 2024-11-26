export function attachMenuToggleHandler() {
    document.addEventListener('click', (event) => {
      const sidebar = document.getElementById('sidebar');
      if (event.target && event.target.id === 'menu-toggle') {
        sidebar.classList.toggle('hidden');
      }
    });
  }
  