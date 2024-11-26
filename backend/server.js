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
app.use(session({ secret: 'secret', resave: false, saveUninitialized: true }));

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
