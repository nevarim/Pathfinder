// Funzione per inizializzare l'editor WYSIWYG
function wysiwyg(editorId, toolbarId) {
    const editor = document.getElementById(editorId);
    const toolbar = document.getElementById(toolbarId);
    if (!editor || !toolbar) return;

    // Pulsanti della toolbar
    const toolbarButtons = [
        { command: 'bold', icon: '<b>B</b>', tooltip: 'Grassetto' },
        { command: 'italic', icon: '<i>I</i>', tooltip: 'Corsivo' },
        { command: 'underline', icon: '<u>U</u>', tooltip: 'Sottolineato' },
        { command: 'strikeThrough', icon: '<s>S</s>', tooltip: 'Barrato' },
        { command: 'insertOrderedList', icon: '🔢', tooltip: 'Lista numerata' },
        { command: 'insertUnorderedList', icon: '•', tooltip: 'Lista puntata' },
        { command: 'justifyLeft', icon: '⬅', tooltip: 'Allinea a sinistra' },
        { command: 'justifyCenter', icon: '⬆', tooltip: 'Allinea al centro' },
        { command: 'justifyRight', icon: '➡', tooltip: 'Allinea a destra' }
    ];

    toolbarButtons.forEach(button => {
        const btn = document.createElement('button');
        btn.innerHTML = button.icon;
        btn.title = button.tooltip;
        btn.onclick = () => execCmd(editor, button.command);
        toolbar.appendChild(btn);
    });

    // Selettore per il font
    const fontSelect = document.createElement("select");
    fontSelect.title = "Seleziona il font";
    const fonts = ['Arial', 'Georgia', 'Courier New', 'Verdana', 'Times New Roman'];
    fonts.forEach(font => {
        const option = document.createElement("option");
        option.value = font;
        option.innerText = font;
        fontSelect.appendChild(option);
    });
    fontSelect.onchange = () => execCmd(editor, 'fontName', fontSelect.value);
    toolbar.appendChild(fontSelect);

    // Selettore per la dimensione del font
    const sizeSelect = document.createElement("select");
    sizeSelect.title = "Seleziona la dimensione del font";
    for (let i = 1; i <= 7; i++) {
        const option = document.createElement("option");
        option.value = i;
        option.innerText = i;
        sizeSelect.appendChild(option);
    }
    sizeSelect.onchange = () => execCmd(editor, 'fontSize', sizeSelect.value);
    toolbar.appendChild(sizeSelect);

    // Pulsante per il toggle HTML
    const toggleHtml = document.createElement("button");
    toggleHtml.innerText = "HTML";
    toggleHtml.title = "Mostra/Nasconde HTML";
    toggleHtml.onclick = () => toggleHtmlView(editor);
    toolbar.appendChild(toggleHtml);
}

// Funzione per eseguire i comandi di formattazione
function execCmd(editor, command, value = null) {
    editor.focus();
    document.execCommand(command, false, value);
}

// Funzione per il toggle HTML
function toggleHtmlView(editor) {
    if (editor.getAttribute("contenteditable") === "true") {
        editor.innerText = editor.innerHTML;  // Mostra il codice HTML
        editor.setAttribute("contenteditable", "false");
    } else {
        editor.innerHTML = editor.innerText;  // Ritorna alla visualizzazione formattata
        editor.setAttribute("contenteditable", "true");
    }
}
