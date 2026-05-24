const express = require('express');
const path = require('path');

const app = express();

const port = parseInt(process.env.PORT) || process.argv[3] || 8080;

// Konfigurasi folder statis dan template engine
app.use(express.static(path.join(__dirname, 'public')))
  .set('views', path.join(__dirname, 'views'))
  .set('view engine', 'ejs');

// Rute Halaman Utama
app.get('/', (req, res) => {
  res.render('index');
});

// Rute Baru: Menampilkan halaman login/pembayaran voucher dari folder public
app.get('/login', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'login.html'));
});

// Rute API untuk test koneksi
app.get('/api', (req, res) => {
  res.json({ "msg": "Hello world" });
});

// Jalankan Server
app.listen(port, () => {
  console.log(`Listening on http://localhost:${port}`);
});