// Fungsi Enkripsi agar login Member/Admin sukses
function doLogin() {
    var form = document.forms['login'];
    if (!form) return false;

    var password = form.password.value;
    var chapId = document.getElementById('chap-id').value;
    var chapChallenge = document.getElementById('chap-challenge').value;

    // Melakukan hashing password jika library md5.js sudah dimuat
    if (chapId && chapChallenge && typeof hexMD5 === 'function') {
        form.password.value = hexMD5(chapId + password + chapChallenge);
    }
    return true;
}

window.onload = function() {
    const inputArea = document.getElementById('input-area');
    const trialSource = document.getElementById('trial-link');
    
    if (inputArea && trialSource) {
        const trialUrl = trialSource.getAttribute('href');
        inputArea.innerHTML = `
            <div style="margin-top: 10px;">
                <a href="${trialUrl}" class="btn" style="background-color: #6c757d; text-decoration: none; display: block; text-align: center; color: white; padding: 12px; border-radius: 5px; font-weight: bold;">
                    COBA GRATIS (TRIAL)
                </a>
            </div>
        `;
    }
};

function showInput(type) {
    const inputArea = document.getElementById('input-area');
    if (!inputArea) return;

    if (type === 'voucher') {
        inputArea.innerHTML = `
            <div style="margin-top: 15px;">
                <input type="text" name="username" placeholder="Masukkan Kode Voucher" required autofocus
                       class="auth-input">
                <input type="hidden" name="password">
                <button type="submit" class="btn btn-voucher auth-button">LOGIN VOUCHER</button>
            </div>
        `;
        const u = inputArea.querySelector('input[name="username"]');
        const p = inputArea.querySelector('input[name="password"]');
        u.oninput = function() { p.value = u.value; };
    } else if (type === 'member') {
        inputArea.innerHTML = `
            <div style="margin-top: 15px;">
                <input type="text" name="username" placeholder="Username" required
                       class="auth-input">
                <input type="password" name="password" placeholder="Kata Sandi" required
                       class="auth-input">
                <button type="submit" class="btn btn-member auth-button">LOGIN MEMBER</button>
            </div>
        `;
    }
}
function showMethod(type) {
    var area = document.getElementById('login-form-area');
    if(type === 'voucher') {
        area.innerHTML = '<input type="text" class="form-control-md" placeholder="Kode Voucher...">'; // + tombol submit
    } else if(type === 'member') {
        area.innerHTML = '<input type="text" class="form-control-md" placeholder="Username..."><input type="password" class="form-control-md mr-t-5" placeholder="Password...">'; // + tombol submit
    }
    // ... dan seterusnya untuk QRIS atau Bayar
}
function searchHandler(event) {
    if (event.key === 'Enter') executeSearch();
}

function executeSearch() {
    const val = document.getElementById('search-input').value.toLowerCase();
    // Ganti '.card' dengan class kartu paket Anda (misal .card-paket)
    const items = document.querySelectorAll('.card'); 
    
    items.forEach(item => {
        const text = item.innerText.toLowerCase();
        item.style.display = text.includes(val) ? "block" : "none";
    });
}
// Tambahkan library jsQR di bagian atas file atau lewat CDN di HTML
// <script src="https://cdn.jsdelivr.net/npm/jsqr@1.4.0/dist/jsQR.min.js"></script>

function handleQuickScan(event) {
    const file = event.target.files[0];
    if (!file) return;

    const reader = new FileReader();
    reader.onload = function(e) {
        const image = new Image();
        image.onload = function() {
            // Gambar diolah dalam canvas untuk dibaca datanya
            const canvas = document.createElement('canvas');
            const context = canvas.getContext('2d');
            canvas.width = image.width;
            canvas.height = image.height;
            context.drawImage(image, 0, 0, image.width, image.height);
            
            const imageData = context.getImageData(0, 0, canvas.width, canvas.height);
            const code = jsQR(imageData.data, imageData.width, imageData.height);

            if (code) {
                alert("QR Berhasil Discan: " + code.data);
                // Masukkan hasil ke form login
                showInput('voucher');
                const userInp = document.querySelector('input[name="username"]');
                if(userInp) {
                    userInp.value = code.data;
                    document.querySelector('input[name="password"]').value = code.data;
                }
            } else {
                alert("QR Code tidak terdeteksi. Pastikan gambar jelas.");
            }
        };
        image.src = e.target.result;
    };
    reader.readAsDataURL(file);
}