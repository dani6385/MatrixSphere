const admin = require('firebase-admin');
const express = require('express');
const app = express();

app.use(express.json());

// Inisialisasi Firebase Admin (Hubungkan ke Database MatrixSphere)
admin.initializeApp({
  credential: admin.credential.applicationDefault(),
  databaseURL: "https://matrixsphere-shop-default-rtdb.firebaseio.com" 
});

const db = admin.database();

// Endpoint untuk menerima data IoT MikroTik
app.post('/api/mikrotik-iot', async (req, res) => {
  try {
    const dataIoT = req.body; // Mengambil data yang dikirim MikroTik
    
    // Simpan ke Realtime Database Firebase
    await db.ref('mikrotik_iot/status').set({
      cpu_load: dataIoT.cpu,
      uptime: dataIoT.uptime,
      timestamp: new Date().toISOString()
    });

    return res.status(200).send({ message: "Data berhasil disimpan ke Firebase!" });
  } catch (error) {
    return res.status(500).send({ error: error.message });
  }
});

app.listen(3000, () => console.log('Server Jembatan IoT Aktif!'));