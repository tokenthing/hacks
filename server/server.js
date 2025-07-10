const express = require('express');
const app = express();
app.use(express.json());

const commands = {};
const registeredClients = new Set();

app.post('/register', (req, res) => {
  const { id } = req.body;
  if (!id) return res.status(400).send('Missing ID');
  registeredClients.add(id);
  commands[id] = null;
  console.log(`[SERVER] Registered ID: ${id}`);
  res.send('Registered');
});

app.post('/send-command', (req, res) => {
  const { player, command } = req.body;
  if (!player || !command) return res.status(400).send('Missing player or command');
  if (!registeredClients.has(player)) return res.status(404).send('Unknown ID');
  commands[player] = command;
  console.log(`[SERVER] Command set for ${player}: ${command}`);
  res.send('Command saved');
});

app.get('/get-command/:id', (req, res) => {
  const id = req.params.id;
  const command = commands[id] || null;
  commands[id] = null;
  res.json({ command });
});

app.listen(3001, () => console.log('[SERVER] Running at http://localhost:3001'));
