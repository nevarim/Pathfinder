document.getElementById('menu-toggle').addEventListener('click', function() {
    var sidebar = document.getElementById('sidebar');
    if (sidebar.style.display === 'none' || sidebar.style.display === '') {
        sidebar.style.display = 'block';
    } else {
        sidebar.style.display = 'none';
    }
});

function loadPage(page) {
    var contentDiv = document.getElementById('content');
    if (page === 'home') {
        contentDiv.innerHTML = '<h2>Home</h2><p>Benvenuto nella pagina Home!</p>';
    }
    // Aggiungi altre pagine se necessario
}
