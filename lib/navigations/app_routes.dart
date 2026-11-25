/// Pusat definisi seluruh alamat rute (URL path) aplikasi Matrix Sphere
/// dan modul-modul di dalam monorepo.
class AppRoutes {
  // Mencegah instansiasi kelas karena seluruh properti bersifat static const
  AppRoutes._();

  // ===========================================================================
  // 1. AUTHENTICATION & ONBOARDING
  // ===========================================================================
  static const String login = '/login';
  static const String loginOption = '/login-option';
  static const String forgotPassword = '/forgot-password';
  static const String userRegistration = '/user-registration';
  static const String shopRegistration = '/shop-registration';
  static const String verifyEmail = '/verify-email';

  // ===========================================================================
  // 2. SECURITY & ACCESS CONTROL
  // ===========================================================================
  static const String resetPassword = '/reset-password';
  static const String permissions = '/permissions';
  static const String security = '/security';
  static const String roles = '/roles';

  // ===========================================================================
  // 3. MAIN & SHELL ROUTES
  // ===========================================================================
  static const String home = '/';
  static const String caseOScreen = '/case0';
  static const String case1Screen = '/case1';
  static const String case2Screen = '/case2';
  static const String case3Screen = '/case3';
  static const String case4Screen = '/case4';

  // ===========================================================================
  // 4. PROFILE & EDIT PROFILE (USER, COMPANY, SHOP)
  // ===========================================================================
  static const String profile = '/profile';
  static const String userProfile = '/user-profile';
  static const String companyProfile = '/company-profile';
  static const String shopProfile = '/shop-profile';

  // Rute untuk halaman Edit Profil (umum maupun spesifik per entitas)
  static const String editProfile = '/edit-profile';
  static const String editUserProfile = '/edit-user-profile';
  static const String editCompanyProfile = '/edit-company-profile';
  static const String editShopProfile = '/edit-shop-profile';

  // Alias kompatibilitas jika kode lama masih memanggil nama huruf kecil ini
  static const String editprofile = '/editprofile';

  // ===========================================================================
  // 5. MATRIX SPHERE
  // ===========================================================================
  static const String analytics = '/analytics';
  static const String approvals = '/approvals';
static const String system = '/system';
  static const String attendance = '/attendance';
  static const String transaction = '/transaction';
  static const String transactions = '/transactions';

  // ===========================================================================
  // 6. SELLER SPHERE
  // ===========================================================================
  static const String financial = '/financial';
  static const String management = '/management';
  static const String sellers = '/sellers';

  // ===========================================================================
  // 7. SHOP SPHERE
  // ===========================================================================
  static const String feedback = '/feedback';
  static const String searching = '/searching';
  static const String account = '/account';

  // ===========================================================================
  // 8. CLIENT CONNECTIVITY & ADMIN MIKROTIK
  // ===========================================================================
  // Tambahkan rute khusus Client Connectivity & Admin Mikrotik di sini bila diperlukan

  // ===========================================================================
  // 9. OPERATIONAL, TOOLS & GENERAL FEATURES
  // ===========================================================================
  static const String apiKeys = '/api-keys';
  static const String assets = '/assets';
  static const String attendanceHistory = '/attendance-history';
  static const String auditLog = '/audit-log';
  static const String billing = '/billing';
  static const String calendar = '/calendar';
  static const String contacts = '/contacts';
  static const String files = '/files';
  static const String integrations = '/integrations';
  static const String marketing = '/marketing';
  static const String messages = '/messages';
  static const String notifications = '/notifications';
  static const String reports = '/reports';
  static const String returns = '/returns';
  static const String reviews = '/reviews';
  static const String scanFace = '/scan-face';
  static const String scanQr = '/scan-qr';
  static const String settings = '/settings';
  static const String simulation = '/simulation';
  static const String stream = '/stream';
  static const String subscription = '/subscription';
  static const String support = '/support';
  static const String tasks = '/tasks';
  static const String team = '/team';
  static const String templates = '/templates';
  static const String users = '/users';
  static const String vendors = '/vendors';
  static const String webhooks = '/webhooks';
  static const String workCalendar = '/work-calendar';

  static const String userManagement = '/user-management';
}