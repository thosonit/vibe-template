import 'package:shared_preferences/shared_preferences.dart';

/// Typed wrapper over [SharedPreferences] for non-sensitive data only:
/// feature flags, UI preferences, onboarding flags, cached IDs.
///
/// No raw string-key access (`prefs.getString('x')`) outside this file.
class PreferencesStore {
  PreferencesStore(this._prefs);

  final SharedPreferences _prefs;

  static const _onboardingCompleteKey = 'onboarding_complete';

  bool getOnboardingComplete() => _prefs.getBool(_onboardingCompleteKey) ?? false;

  Future<void> setOnboardingComplete(bool value) =>
      _prefs.setBool(_onboardingCompleteKey, value);
}
