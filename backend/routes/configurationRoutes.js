// routes/configurationRoute.js

const express = require('express');
const router = express.Router();
const Configuration = require('../models/configurationModel');

// Rotta per ottenere la configurazione
router.get('/get', async (req, res) => {
  try {
    const config = await Configuration.findOne({ where: { key: 'appTitle' } });
    if (config) {
      res.json(config);
    } else {
      res.status(404).send('Configuration not found');
    }
  } catch (error) {
    console.error('Error fetching configuration:', error);
    res.status(500).send('Error fetching configuration');
  }
});

// Rotta per aggiornare la configurazione
router.post('/set', async (req, res) => {
  const { key, value } = req.body;
  try {
    const config = await Configuration.upsert(
      { key, value },
      { where: { key } }
    );
    res.json(config);
  } catch (error) {
    console.error('Error updating configuration:', error);
    res.status(500).send('Error updating configuration');
  }
});

module.exports = router;
