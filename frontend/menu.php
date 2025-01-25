<?php
class MenuItem {
    public $title;
    public $description;
    public $page;

    public function __construct($title, $description, $page) {
        $this->title = $title;
        $this->description = $description;
        $this->page = $page;
    }
}

$menu = [
    'Pathfinder' => [
        new MenuItem('Sheet List', 'Lista delle schede del personaggio', 'sheetlist'),
        new MenuItem('Create Sheet', 'Crea una nuova scheda', 'createsheet')
    ],
    'User' => [
        new MenuItem('User Settings', 'Settaggi utente', 'usersettings')
    ],
    'Administration' => [
        new MenuItem('User List', 'Pagina amministrazione utenti e permessi', 'userlist'),
		new MenuItem('Race List', 'Pagina gestione delle razze', 'admin_race')
    ],
    'General' => [
        new MenuItem('Home', 'Accesso alla pagina Home', 'home'),
        new MenuItem('Registrati', 'Accedi alla registrazione', 'register'),
        new MenuItem('Credits', 'Accesso alla pagina Credits', 'credits')
    ]
];

function generateMenu($menu, $user_permissions) {
    echo '<aside id="sidebar">';
    foreach ($menu as $block => $items) {
        // Controlla i permessi per visualizzare il blocco
        $show_block = false;
        if ($block === 'Pathfinder' || $block === 'User') {
            $show_block = in_array('IsUser', $user_permissions);
        } elseif ($block === 'Administration') {
            $show_block = in_array('IsAdmin', $user_permissions);
        } elseif ($block === 'General') {
            $show_block = true; // General sempre visibile
        } else {
            $show_block = true;
        }

        if ($show_block) {
            echo '<div class="menu-block">';
            echo '<h3>' . $block . '</h3>';
            echo '<ul>';
            foreach ($items as $menuItem) {
                echo '<li><a href="index.php?page=' . $menuItem->page . '" data-description="' . $menuItem->description . '">' . $menuItem->title . '</a></li>';
            }
            echo '</ul>';
            echo '</div>';
        }
    }
    echo '</aside>';
}
?>
