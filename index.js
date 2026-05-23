const express = require('express');
const path = require('path')

const app = express();

const port = parseInt(process.env.PORT) || process.argv[3] || 8080;

app.use(express.static(path.join(__dirname, 'public')))
  .set('views', path.join(__dirname, 'views'))
  .set('view engine', 'ejs');

app.get('/', (req, res) => {
  res.render('index');
});

app.get('/api', (req, res) => {
  res.json({ "msg": "Hello world" });
});

app.listen(port, () => {
  console.log(`Listening on http://localhost:${port}`);
})
// Tambahkan listener untuk tombol back Android
document.addEventListener('ionBackButton', (ev) => {
  ev.detail.register(10, () => {
    if (window.location.pathname === '/' || window.location.pathname === '/home') {
      // Jika di halaman utama, baru boleh keluar
      navigator['app'].exitApp();
    } else {
      // Jika di halaman lain, mundur satu langkah
      window.history.back();
    }
  });
});

// Atau jika menggunakan Capacitor App Plugin (Lebih Direkomendasikan)
import { App } from '@capacitor/app';

App.addListener('backButton', ({ canGoBack }) => {
  if (canGoBack) {
    window.history.back();
  } else {
    App.exitApp();
  }
});