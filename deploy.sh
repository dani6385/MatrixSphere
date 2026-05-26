#!/bin/bash
# Mengambil waktu sekarang
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
# Pesan commit otomatis
MSG="build: auto update $TIMESTAMP"

git add .
git commit -m "$MSG"
git push origin main

echo "✅ Berhasil push dengan pesan: $MSG"