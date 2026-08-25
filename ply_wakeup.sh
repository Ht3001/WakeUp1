#!/usr/bin/env bash
set -euo pipefail

# GitHub Copilot Chat Assistant - Script to create/update WakeUp-bot files and commit them.
# Save as apply_wakeup.sh, make executable and run from repo root.

REPO_ROOT="$(pwd)"

echo "== WakeUp-bot auto-installer =="
echo "Working directory: $REPO_ROOT"
echo

# Check for git
if ! command -v git >/dev/null 2>&1; then
  echo "Error: git no está instalado o no está en PATH. Instálalo y vuelve a intentarlo."
  exit 1
fi

# Are we inside a git repo?
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  read -rp "No estás dentro de un repo git. ¿Inicializar uno aquí? (y/N): " INIT_ANS
  if [[ "$INIT_ANS" =~ ^[Yy]$ ]]; then
    git init
    echo "Repositorio git inicializado."
  else
    echo "Abortando. Sitúate en la raíz de tu repo y vuelve a ejecutar este script."
    exit 1
  fi
fi

BRANCH="$(git rev-parse --abbrev-ref HEAD || echo 'HEAD')"
echo "Rama actual: $BRANCH"
echo

# Files to create/update
echo "Creando/actualizando archivos..."

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

Descripción
Un servidor webhook mínimo para recibir eventos desde Instagram (ej. un servicio que reenvía mensajes a tu bot).

Instalación y prueba local
1. Clona el repo:
   git clone <repo-url>
   cd ht3001

2. Instala dependencias:
   npm install

3. Crea tu .env local (no lo comitees). Puedes basarte en .env.template:
   cp .env.template .env
   # Edita .env y coloca tus valores reales (BOT_TOKEN, BOTPRESS_URL, etc.)

4. Arranca el servidor:
   npm start
   # o
   node index.js

5. Prueba el webhook desde otra terminal:
   curl -i -X POST "http://localhost:4000/webhook/instagram" \
     -H "Content-Type: application/json" \
     -H "X-Wakeup-Secret: <valor_de_WEBHOOK_SECRET_en_.env>" \
     -d '{"from":"test_user_123","sender_name":"Heidy","message":"¿Qué es WakeUp?","attachments":null,"platform":"instagram"}'

Permisos del script
Para marcar create_wakeup.sh ejecutable (localmente):
git update-index --add --chmod=+x create_wakeup.sh
# Luego:
git add create_wakeup.sh LICENSE .env.template README.md
git commit -m "Add MIT license, .env.template and improve README; make create_wakeup.sh executable"
git push origin HEAD

Seguridad
- NO subas .env ni node_modules. .gitignore ya excluye ambos.
- Gestiona secrets en variables de entorno del hosting (Vercel, Render, Heroku, etc.), no en el repo.
EOF

cat > create_wakeup.sh <<'EOF'
#!/usr/bin/env bash
set -e

# Si quieres generar el proyecto desde cero en una carpeta WakeUp-bot:
mkdir -p WakeUp-bot
cd WakeUp-bot

cat > package.json <<'EOP'
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
EOP

cat > index.js <<'EOP'
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
EOP

cat > .gitignore <<'EOP'
node_modules
.env
EOP

cat > README.md <<'EOP'
WakeUp-bot - servidor webhook mínimo
Instrucciones: crear .env y ejecutar `npm install` luego `node index.js`
EOP

echo "Proyecto WakeUp-bot creado en ./WakeUp-bot"
EOF

cat > LICENSE <<'EOF'
MIT License

Copyright (c) YEAR WakeUp1

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
EOF

cat > .env.template <<'EOF'
# Copia este archivo a .env y completa los valores antes de ejecutar localmente.
BOTPRESS_URL=https://tu-botpress
BOT_ID=wakeup
BOT_TOKEN=TU_TOKEN_AQUI
SUPPORT_EMAIL=tu@correo.com
WEBHOOK_SECRET=8f3b9c2d7a4e1f6b9c0d3a7e5b2c1f4a
PORT=4000
EOF

# Make create_wakeup.sh executable
chmod +x create_wakeup.sh

echo
echo "Archivos escritos: package.json, index.js, .gitignore, README.md, create_wakeup.sh, LICENSE, .env.template"
echo

# Git add / commit
git add package.json index.js .gitignore README.md create_wakeup.sh LICENSE .env.template

if git diff --staged --quiet; then
  echo "No hay cambios para commitear."
else
  git commit -m "Add WakeUp-bot webhook minimal files, LICENSE and .env.template"
  echo "Commit creado."
fi

# Ensure git knows the script is executable
git update-index --add --chmod=+x create_wakeup.sh >/dev/null 2>&1 || true

# Ask to push
read -rp "¿Quieres pushear los cambios a origin HEAD ahora? (y/N): " PUSH_ANS
if [[ "$PUSH_ANS" =~ ^[Yy]$ ]]; then
  set +e
  git push origin HEAD
  PUSH_EXIT=$?
  set -e
  if [[ $PUSH_EXIT -ne 0 ]]; then
    echo
    echo "git push falló. Posibles causas:"
    echo "- No existe remote 'origin' configurado."
    echo "- No tienes permisos para push."
    echo "- La rama remota tiene cambios (conflicto)."
    echo
    echo "Sugerencias:"
    echo "- Asegúrate de que 'origin' apunta al repo correcto: git remote -v"
    echo "- Si no hay origin, agrégalo: git remote add origin <url>"
    echo "- Si la push falla por no fast-forward: git pull --rebase origin HEAD, resuelve conflictos, luego git push origin HEAD"
    exit 1
  else
    echo "Push completado."
  fi
else
  echo "No se hizo push. Revisa los cambios localmente y push cuando quieras."
fi

echo
echo "== Listo =="
echo "Recuerda: NO comitees .env ni node_modules. Usa .env.template como referencia."
exit 0
