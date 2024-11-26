const express = require('express');
const router = express.Router();
const User = require('../models/userModel');
const bcrypt = require('bcrypt');

// Rotta di Registrazione
router.post('/register', async (req, res) => {
  console.log('Received POST request for /register'); // Log per verificare la ricezione della richiesta
  const { username, password } = req.body;
  try {
    if (!username || !password) {
      return res.status(400).send('Username and password are required');
    }
    const hashedPassword = await bcrypt.hash(password, 10);
    console.log('Hashed Password:', hashedPassword); // Log per vedere l'hash della password
    const user = await User.create({ username, password: hashedPassword });
    res.status(201).send('User Registered');
  } catch (error) {
    console.error('Error registering user:', error);
    res.status(400).send('Error Registering User');
  }
});


router.post('/logout', (req, res) => {
  console.log('Received POST request for /logout'); // Log per verificare la ricezione della richiesta
  req.session.destroy((err) => {
    if (err) {
      console.error('Error during logout:', err);
      return res.status(500).send('Error during logout');
    }
    res.clearCookie('connect.sid'); // Pulisci il cookie di sessione
    res.status(200).send('Logout successful');
  });
});


// Rotta di Login
router.post('/login', async (req, res) => {
  console.log('Received POST request for /login'); // Log per verificare la ricezione della richiesta
  const { username, password } = req.body;
  console.log(`Username: ${username}, Password: ${password}`); // Log per verificare i dati ricevuti
  try {
    if (!username || !password) {
      console.log('Missing username or password');
      return res.status(400).send('Username and password are required');
    }
    const user = await User.findOne({ where: { username } });
    console.log('User found:', user); // Log per vedere il risultato della query
    if (!user) {
      console.log('User not found');
      return res.status(400).send('Invalid username or password');
    }
    const passwordMatch = await bcrypt.compare(password, user.password);
    console.log('Password match:', passwordMatch); // Log per vedere se la password corrisponde
    if (!passwordMatch) {
      console.log('Invalid password');
      return res.status(400).send('Invalid username or password');
    }
    req.session.user = user;
    console.log('Session user set:', req.session.user); // Log per verificare che la sessione sia stata impostata
    res.status(200).json({ message: 'Login successful' }); // Risposta con JSON
  } catch (error) {
    console.error('Error during login:', error);
    res.status(400).send('Error during login');
  }
});




module.exports = router;

