const express = require('express');
const session = require('express-session');
const bodyParser = require('body-parser');
const path = require('path');
const userRoutes = require('../backend/routes/userRoutes');

const app = express();

app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, '../frontend'));

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(session({
  secret: 'secret',
  resave: false,
  saveUninitialized: true,
  cookie: { secure: false } // Assicurati di impostare secure: true in produzione su HTTPS
}));

// Middleware per loggare le richieste
app.use((req, res, next) => {
  console.log(`Richiesta ricevuta: ${req.method} ${req.url}`);
  next();
});

app.get('/api/configuration/get', (req, res) => {
  // Esempio di risposta JSON per la configurazione
  res.json({ message: 'Configuration data retrieved successfully.' });
});


app.post('/api/configuration/set', (req, res) => {
  // Recupera i dati inviati nella richiesta (assicurati che il corpo della richiesta sia JSON)
  const configurationData = req.body;

  // Qui gestisci la logica per salvare o aggiornare la configurazione
  console.log('Received configuration data:', configurationData);

  // Rispondi con un messaggio di successo
  res.json({ message: 'Configuration set successfully' });
});





app.use('/api/users', userRoutes);

app.use(express.static(path.join(__dirname, '../frontend')));

app.use((req, res, next) => {
  res.locals.user = req.session.user;
  next();
});

app.get('/', (req, res) => {
  res.render('index');
});

app.get('/:page', (req, res) => {
  const page = req.params.page;
  res.render(page);
});

app.listen(3000, () => {
  console.log('Server is running on http://localhost:3000');
});
