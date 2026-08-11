require('dotenv').config();
const express = require('express');
const bodyParser = require('body-parser');

const app = express();
const PORT = process.env.PORT || 4000;
const WEBHOOK_SECRET = process.env.WEBHOOK_SECRET || '';

app.use(bodyParser.json());

app.post('/webhook/instagram', (req, res) => {
  const headerSecret = req.get('X-Wakeup-Secret') || '';
  if (!WEBHOOK_SECRET || headerSecret !== WEBHOOK_SECRET) {
    console.warn('Secret mismatch:', { expected: WEBHOOK_SECRET ? 'set' : 'not-set', received: headerSecret });
    return res.status(401).json({ error: 'Unauthorized' });
  }

  const payload = req.body || {};
  console.log('Webhook recibido:', JSON.stringify(payload, null, 2));

  // Aquí puedes integrar con Botpress u otro servicio.
  res.json({ status: 'ok', received: payload });
});

app.get('/', (req, res) => {
  res.send('WakeUp-bot webhook server running');
});

app.listen(PORT, () => {
  console.log(`Webhook servidor en puerto ${PORT}`);
});
