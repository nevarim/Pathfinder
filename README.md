here there is a quick usage of backend for handle pathfinder backend

**Lista Completa degli Endpoint per la Gestione dei Permessi**

---

### **1. Registrazione Utente**
**Endpoint:** `POST /register`
- **URL:** `http://localhost:8080/register`
- **Descrizione:** Registra un nuovo utente.
- **Richiesta JSON:**
```json
{
  "username": "test_user",
  "password": "securepassword",
  "email": "test@example.com"
}
```

---

### **2. Login Utente**
**Endpoint:** `POST /login`
- **URL:** `http://localhost:8080/login`
- **Descrizione:** Effettua il login di un utente.
- **Richiesta JSON:**
```json
{
  "identifier": "test_user",
  "password": "securepassword"
}
```

---

### **3. Logout Utente**
**Endpoint:** `POST /logout`
- **URL:** `http://localhost:8080/logout`
- **Descrizione:** Effettua il logout dell'utente attuale.
- **Richiesta JSON:**
```json
{
  "session_token": "abc123xyz"
}
```

---

### **4. Aggiungere un Permesso**
**Endpoint:** `POST /permissions/add`
- **URL:** `http://localhost:8080/permissions/add`
- **Descrizione:** Aggiunge un nuovo permesso al sistema.
- **Richiesta JSON:**
```json
{
  "user_id": 1,
  "permission_name": "add_permission",
  "description": "Permesso per aggiungere nuovi permessi"
}
```

---

### **5. Modificare un Permesso**
**Endpoint:** `POST /permissions/edit`
- **URL:** `http://localhost:8080/permissions/edit`
- **Descrizione:** Modifica un permesso esistente.
- **Richiesta JSON:**
```json
{
  "user_id": 1,
  "permission_id": 3,
  "new_permission_name": "edit_permission",
  "description": "Permesso aggiornato"
}
```

---

### **6. Disabilitare un Permesso**
**Endpoint:** `POST /permissions/disable`
- **URL:** `http://localhost:8080/permissions/disable`
- **Descrizione:** Disabilita un permesso senza eliminarlo.
- **Richiesta JSON:**
```json
{
  "user_id": 1,
  "permission_id": 3
}
```

---

### **7. Assegnare un Permesso a un Utente**
**Endpoint:** `POST /user-permissions/assign`
- **URL:** `http://localhost:8080/user-permissions/assign`
- **Descrizione:** Assegna un permesso a un utente specifico.
- **Richiesta JSON:**
```json
{
  "user_id": 1,
  "target_user_id": 2,
  "permission_id": 3
}
```

---

### **8. Rimuovere un Permesso da un Utente**
**Endpoint:** `POST /user-permissions/remove`
- **URL:** `http://localhost:8080/user-permissions/remove`
- **Descrizione:** Rimuove un permesso da un utente specifico.
- **Richiesta JSON:**
```json
{
  "user_id": 1,
  "target_user_id": 2,
  "permission_id": 3
}
```

---

### **9. Assegnare una Pagina a un Utente**
**Endpoint:** `POST /permission-pages/assign`
- **URL:** `http://localhost:8080/permission-pages/assign`
- **Descrizione:** Assegna una pagina specifica a un utente.
- **Richiesta JSON:**
```json
{
  "user_id": 1,
  "target_user_id": 2,
  "page_id": 5
}
```

---

### **10. Rimuovere una Pagina da un Utente**
**Endpoint:** `POST /permission-pages/remove`
- **URL:** `http://localhost:8080/permission-pages/remove`
- **Descrizione:** Rimuove l'accesso di un utente a una pagina specifica.
- **Richiesta JSON:**
```json
{
  "user_id": 1,
  "target_user_id": 2,
  "page_id": 5
}
```

---

### **11. Visualizzare i Permessi di un Utente**
**Endpoint:** `GET /user-permissions/{user_id}`
- **URL:** `http://localhost:8080/user-permissions/2`
- **Descrizione:** Restituisce la lista dei permessi assegnati a un utente.
- **Risposta JSON:**
```json
[
  {
    "id": 3,
    "permission_name": "edit_permission",
    "is_active": true
  },
  {
    "id": 5,
    "permission_name": "delete_permission",
    "is_active": false
  }
]
```

---

### **12. Ottenere l'ID di una Pagina dal Nome**
**Endpoint:** `POST /user-pages/get-id`
- **URL:** `http://localhost:8080/user-pages/get-id`
- **Descrizione:** Restituisce l'ID di una pagina dato il suo nome.
- **Richiesta JSON:**
```json
{
  "page_name": "Dashboard"
}
```
- **Risposta JSON:**
```json
{
  "page_id": 3
}
```
Se la pagina non esiste:
```json
Pagina non trovata
```

---

### **13. Ottenere Informazioni di un Utente per Nome Utente**
**Endpoint:** `GET /user/get-by-username/{username}
- **URL:** `http://localhost:8080/user/get-by-username/test_user`
- **Descrizione:** Restituisce le informazioni di un utente dato il suo nome utente.
- **Risposta JSON:**
```json
{
  "id": 1,
  "username": "test_user",
  "email": "test@example.com",
  "is_active": true,
  "is_debug": false
}

```

---

### **14. Ottenere Informazioni di un Utente per Email**
**Endpoint:** `GET /user/get-by-email/{email}
- **URL:** `http://localhost:8080/user/get-by-email/test@example.com`
- **Descrizione:** Restituisce le informazioni di un utente dato il suo indirizzo email.
- **Risposta JSON:**
```json
{
  "id": 1,
  "username": "test_user",
  "email": "test@example.com",
  "is_active": true,
  "is_debug": false
}


```

### **15. Aggiornare le Impostazioni dell'Utente**
**Endpoint:** `POST /user-settings/update`
- **URL:** `http://localhost:8080/user-settings/update`
- **Descrizione:** Aggiorna le impostazioni dell'utente (nome utente, password, stato IsDebug e IsActive.
- **Body JSON:**
```json
{
  "user_id": 1,
  "username": "new_username",
  "password": "new_password",
  "is_debug": true,
  "is_active": false
}


```

### **16. Aggiungere una Razza**
**Endpoint:** `POST /race/add'

- **URL:** `http://localhost:8080/race/add`
- **Descrizione:** Aggiunge una nuova razza al sistema.
- **Richiesta JSON:**
```json
{
  "name": "Elfo",
  "description": "Una razza robusta e resistente, abile nell'arte della forgia."
}
```


### **17. Modificare una Razza**
**Endpoint:** `POST /race/edit`

- **URL:** `http://localhost:8080/race/edit`
- **Descrizione:** Modifica il nome di una razza esistente.
- **Richiesta JSON:**
```json
{
  "id": 1,
  "name": "Elfo Scuro"
  "description": "Una razza robusta e resistente, abile nell'arte della forgia."
}
```
### **18. Disattivare una Razza**
**Endpoint:** `POST /race/inactivate`

- **URL:** `http://localhost:8080/race/inactivate`
- **Descrizione:** Disattiva una razza senza cancellarla.
- **Richiesta JSON:**
```json
{
  "id": 1
}
```


### **19. Ottenere Tutte le Razze**
**Endpoint:** GET /race/list

- **URL: `http://localhost:8080/race/list`
- **Descrizione:** Restituisce l'elenco di tutte le razze presenti nel sistema, attive e non.
- **Risposta JSON:**
```json
[
  {
    "id": 1,
    "name": "Elfo",
	"description": "Una razza robusta e resistente, abile nell'arte della forgia.",
    "is_active": true
  },
  {
    "id": 2,
    "name": "Nano",
	"description": "Una razza robusta e resistente, abile nell'arte della forgia.",
    "is_active": false
  }
]
```

### **20. Ottenere una Razza per ID**
**Endpoint: GET /race/{id}**

- **URL:** `http://localhost:8080/race/1`
- **Descrizione:** Restituisce i dettagli di una razza dato il suo ID.
- **Risposta JSON:**
```json
{
  "id": 1,
  "name": "Elfo",
  "description": "Una razza longeva con sensi acuti e affinità per la magia.",
  "is_active": true
}
```
