const http = require('http');
const os = require('os');
const Redis = require('ioredis');

const PORT = 3000;
const REDIS_HOST = process.env.REDIS_HOST || 'localhost';
const REDIS_PORT = 6379;

const redis = new Redis({
  host: REDIS_HOST,
  port: REDIS_PORT,
});

const server = http.createServer(async (req, res) => {
  if (req.url === '/favicon.ico') {
    res.writeHead(204);
    res.end();
    return;
  }

  try {
    const totalVisits = await redis.incr('global_visits');
    const hostname = os.hostname();

    res.writeHead(200, { 'Content-Type': 'text/plain; charset=utf-8' });
    res.end(`hostname=${hostname} | global_visits=${totalVisits}\n`);
  } catch (error) {
    res.writeHead(500, { 'Content-Type': 'text/plain; charset=utf-8' });
    res.end(`Error al acceder a Redis: ${error.message}\n`);
  }
});

server.listen(PORT, () => {
  console.log(`Servidor escuchando en puerto ${PORT}, redis en ${REDIS_HOST}:${REDIS_PORT}`);
});
