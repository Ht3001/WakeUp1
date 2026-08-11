#!/usr/bin/env bash
set -e

# Si quieres generar el proyecto desde cero en una carpeta WakeUp-bot:
mkdir -p WakeUp-bot
cd WakeUp-bot

cat > package.json <<'EOF'
{
  "name": "wakeup-bot",
  "version": "1.0.0",
  "description": "Webhook simple para WakeUp-bot (Instagram)",
  "main": "index.js",
  "scripts": {
    "start": "node index.js"
  },
  "dependencies": {
    "express": "^4.18.2",
    "dotenv": "^16.0.3",
    "body-parser": "^1.20.2"
  },
  "engines": {
    "node": ">=18"
  }
}
EOF

cat > index.js <<'EOF'
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

  res.json({ status: 'ok', received: payload });
});

app.get('/', (req, res) => {
  res.send('WakeUp-bot webhook server running');
});

app.listen(PORT, () => {
  console.log(`Webhook servidor en puerto ${PORT}`);
});
EOF

cat > .gitignore <<'EOF'
node_modules
.env
EOF

cat > README.md <<'EOF'
WakeUp-bot - servidor webhook mínimo
Instrucciones: crear .env y ejecutar `npm install` luego `node index.js`
EOF

echo "Proyecto WakeUp-bot creado en ./WakeUp-bot"
