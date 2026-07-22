/// Env key constants loaded from `.env.*` via `flutter_dotenv`.
///
/// Raw `dotenv.env['KEY']` access is forbidden outside this file and
/// `app_config.dart` — everything else reads through [AppConfig].
class Env {
  Env._();

  static const String apiBaseUrl = 'API_BASE_URL';
  static const String apiTimeoutMs = 'API_TIMEOUT_MS';
}
