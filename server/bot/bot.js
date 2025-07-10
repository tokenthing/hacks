const { Client, GatewayIntentBits } = require('discord.js');
const axios = require('axios');

const client = new Client({ intents: [GatewayIntentBits.Guilds, GatewayIntentBits.GuildMessages, GatewayIntentBits.MessageContent] });

const TOKEN = 'MTM5Mjg0MTE0NTA0NTg3Njc1Nw.GB88Z2.aQSm8Oi3wiXuHWjavBTWFZVweh-pUp8hRTOiOE';
const CONTROL_SERVER = 'http://localhost:3001/send-command';

client.on('messageCreate', async (message) => {
  if (!message.content.startsWith('!command') || message.author.bot) return;

  const [cmd, id, ...action] = message.content.split(' ');
  const command = action.join(' ');

  try {
    await axios.post(CONTROL_SERVER, {
      player: id,
      command
    });
    message.reply(`✅ Sent \`${command}\` to ID \`${id}\``);
  } catch (e) {
    message.reply(`❌ Error: ${e.message}`);
  }
});

client.login(TOKEN);
