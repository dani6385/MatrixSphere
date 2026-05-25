document.addEventListener('DOMContentLoaded', function () {
    // Setel status awal ke 'voucher'
    showInput('voucher');

    const allButtons = document.querySelectorAll('[data-type]');
    allButtons.forEach(btn => {
        btn.addEventListener('click', (e) => {
            const type = e.currentTarget.dataset.type;

            // Hentikan pemindaian kamera jika beralih tab
            if (window.localStream) {
                window.localStream.getTracks().forEach(track => track.stop());
            }

            // Kelola status aktif untuk tombol opsi
            if (e.currentTarget.classList.contains('option-btn')) {
                document.querySelectorAll('.option-btn').forEach(innerBtn => innerBtn.classList.remove('active'));
                e.currentTarget.classList.add('active');
                document.querySelector('.trial-btn').classList.remove('active');
            }

            // Kelola status aktif untuk tombol trial
            if (e.currentTarget.classList.contains('trial-btn')) {
                document.querySelectorAll('.option-btn').forEach(innerBtn => innerBtn.classList.remove('active'));
                e.currentTarget.classList.add('active');
            }

            showInput(type);
        });
    });
});


function showInput(type) {
    const inputArea = document.getElementById('input-area');
    let content = '';

    switch (type) {
        case 'voucher':
            content = `
                <div class="form-group">
                    <label for="voucher-code">MASUKKAN KODE VOUCHER</label>
                    <input type="text" id="voucher-code" name="username" placeholder="KODE . . ." required>
                    <input type="hidden" name="password">
                </div>
                <button type="submit" class="submit-btn">LOGIN SEKARANG <i class="fas fa-arrow-right"></i></button>
            `;
            break;
        case 'member':
            content = `
                <div class="form-group">
                    <label for="username">USERNAME MEMBER</label>
                    <input type="text" id="username" name="username" placeholder="ID PENGGUNA" required>
                </div>
                <div class="form-group">
                    <label for="password">PASSWORD</label>
                    <input type="password" id="password" name="password" placeholder="••••••••" required>
                </div>
                <button type="submit" class="submit-btn">LOGIN SEKARANG <i class="fas fa-arrow-right"></i></button>
            `;
            break;
        case 'trial':
            content = `
                <div class="trial-info">
                    <h3><i class="fas fa-bolt"></i> AKSES TRIAL GRATIS</h3>
                    <p>Nikmati akses internet berkecepatan tinggi selama 30 menit tanpa dipungut biaya.</p>
                </div>
            `;
            break;
        case 'scan':
            content = `
                <div id="qr-scanner-container" class="qr-scanner-container">
                    <video id="qr-video" playsinline style="display:none;"></video>
                    <div id="qr-status-message" class="qr-status-message"></div>
                    <input type="file" id="qr-file-input" accept="image/*" style="display: none;">
                    <div class="qr-controls">
                        <button type="button" id="upload-qr-btn" class="control-btn" style="display:none;">Unggah Gambar</button>
                        <button type="button" id="switch-camera-btn" class="control-btn" style="display:none;">Ganti Kamera</button>
                     </div>
                </div>
            `;
            setTimeout(initializeQrScanner, 50);
            break;
        case 'pay':
             content = `<p style="text-align: center; color: #a0aec0; margin-top: 20px;">Fitur ini sedang dalam pengembangan.</p>`;
             break;
    }

    inputArea.innerHTML = content;

    if (type === 'voucher') {
        const u = inputArea.querySelector('input[name="username"]');
        const p = inputArea.querySelector('input[name="password"]');
        if (u && p) {
            u.oninput = () => { p.value = u.value; };
        }
    }
}

async function initializeQrScanner() {
    const statusMessage = document.getElementById('qr-status-message');
    const uploadBtn = document.getElementById('upload-qr-btn');
    const switchCameraBtn = document.getElementById('switch-camera-btn');
    const video = document.getElementById('qr-video');

    // Periksa koneksi aman (HTTPS)
    if (window.isSecureContext === false) {
        statusMessage.innerHTML = 'Akses kamera memerlukan koneksi aman (HTTPS).<br>Silakan unggah gambar QR.';
        uploadBtn.style.display = 'block';
        document.getElementById('qr-file-input').addEventListener('change', handleFileSelect);
        uploadBtn.addEventListener('click', () => document.getElementById('qr-file-input').click());
        return;
    }

    // Lanjutkan dengan logika kamera jika koneksi aman
    const fileInput = document.getElementById('qr-file-input');
    uploadBtn.addEventListener('click', () => fileInput.click());
    fileInput.addEventListener('change', handleFileSelect);

    if (!navigator.mediaDevices || !navigator.mediaDevices.getUserMedia) {
        statusMessage.textContent = 'Kamera tidak didukung oleh browser Anda.';
        uploadBtn.style.display = 'block';
        return;
    }

    try {
        const devices = await navigator.mediaDevices.enumerateDevices();
        const videoDevices = devices.filter(device => device.kind === 'videoinput');
        
        if (videoDevices.length === 0) {
            throw new Error('Tidak ada kamera yang ditemukan');
        }

        video.style.display = 'block';
        uploadBtn.style.display = 'block';
        let currentDeviceId = videoDevices[0].deviceId;
        switchCameraBtn.style.display = videoDevices.length > 1 ? 'block' : 'none';
        let deviceIndex = 0;

        switchCameraBtn.addEventListener('click', () => {
            deviceIndex = (deviceIndex + 1) % videoDevices.length;
            currentDeviceId = videoDevices[deviceIndex].deviceId;
            startStream(currentDeviceId);
        });

        startStream(currentDeviceId);

    } catch (err) {
        statusMessage.textContent = 'Tidak dapat mengakses kamera. Silakan unggah gambar QR.';
        video.style.display = 'none';
        switchCameraBtn.style.display = 'none';
        uploadBtn.style.display = 'block';
    }
}

async function startStream(deviceId) {
    if (window.localStream) {
        window.localStream.getTracks().forEach(track => track.stop());
    }

    const constraints = { video: { deviceId: { exact: deviceId } } };
    const video = document.getElementById('qr-video');
    const statusMessage = document.getElementById('qr-status-message');
    statusMessage.textContent = 'Arahkan kamera ke QR code...';

    try {
        const stream = await navigator.mediaDevices.getUserMedia(constraints);
        window.localStream = stream;
        video.srcObject = stream;
        await video.play();
        requestAnimationFrame(tick);
    } catch (err) {
        statusMessage.textContent = 'Gagal memulai kamera. Coba ganti kamera atau unggah gambar.';
    }
}

function tick() {
    if (!window.localStream || !window.localStream.active) return;

    const video = document.getElementById('qr-video');
    const canvas = document.createElement('canvas');
    const context = canvas.getContext('2d');

    if (video.readyState === video.HAVE_ENOUGH_DATA) {
        canvas.width = video.videoWidth;
        canvas.height = video.videoHeight;
        context.drawImage(video, 0, 0, canvas.width, canvas.height);
        const imageData = context.getImageData(0, 0, canvas.width, canvas.height);
        const code = jsQR(imageData.data, imageData.width, imageData.height, { inversionAttempts: 'dontInvert' });

        if (code) {
            handleQrCode(code.data);
            return;
        }
    }
    requestAnimationFrame(tick);
}

function handleFileSelect(event) {
    const file = event.target.files[0];
    if (!file) return;

    const reader = new FileReader();
    reader.onload = (e) => {
        const image = new Image();
        image.onload = () => {
            const canvas = document.createElement('canvas');
            const context = canvas.getContext('2d');
            canvas.width = image.width;
            canvas.height = image.height;
            context.drawImage(image, 0, 0, canvas.width, canvas.height);
            const imageData = context.getImageData(0, 0, canvas.width, canvas.height);
            const code = jsQR(imageData.data, imageData.width, imageData.height);

            if (code) {
                handleQrCode(code.data);
            } else {
                document.getElementById('qr-status-message').textContent = 'QR Code tidak ditemukan pada gambar.';
            }
        };
        image.src = e.target.result;
    };
    reader.readAsDataURL(file);
}

function handleQrCode(data) {
    if (window.localStream) {
        window.localStream.getTracks().forEach(track => track.stop());
    }
    document.querySelector("button[data-type='voucher']").click();

    setTimeout(() => {
        const voucherInput = document.getElementById('voucher-code');
        if (voucherInput) {
            voucherInput.value = data;
            voucherInput.dispatchEvent(new Event('input')); 
        }
    }, 100);
}

function doLogin() {
    const form = document.forms['login'];
    if (!form) return false;

    const password = form.password.value;
    const chapId = form.chapId.value;
    const chapChallenge = form.chapChallenge.value;

    if (chapId && chapChallenge && password && typeof hexMD5 === 'function') {
        form.password.value = hexMD5(chapId + password + chapChallenge);
    }

    return true;
}
