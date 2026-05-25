import { App } from '@capacitor/app';

// Jalankan fungsi pendengar tautan (Deep Link Listener)
App.addListener('appUrlOpen', (data) => {
    console.log('Aplikasi dibuka lewat link MikroTik:', data.url);
    
    // Membaca alamat parameter (?mac=...&ip=...)
    try {
        const urlObj = new URL(data.url);
        const searchParams = urlObj.search; 

        if (searchParams) {
            // Alihkan WebView internal aplikasi langsung ke Firebase Connectivity Anda
            window.location.href = "https://connectivity-matrixsphere.web.app/" + searchParams;
        }
    } catch (error) {
        console.error('Gagal membaca parameter URL:', error);
    }
});