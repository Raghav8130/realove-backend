import 'app_localizations.dart';

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'रियलव AI';

  @override
  String get voicePageTitle => 'आवाज़ साथी';

  @override
  String get settingsPageTitle => 'सेटिंग्स';

  @override
  String get historyPageTitle => 'चैट इतिहास';

  @override
  String get onboardingTitle => 'रियलव AI में आपका स्वागत है';

  @override
  String get onboardingSubtitle => 'आपका भावनात्मक रूप से ट्यून किया गया आवाज़ साथी';

  @override
  String get startChatting => 'चैट शुरू करें';

  @override
  String get tapToSpeak => 'बोलने के लिए टैप करें';

  @override
  String get listening => 'सुन रहे हैं...';

  @override
  String get processing => 'प्रोसेसिंग...';

  @override
  String get male => 'पुरुष';

  @override
  String get female => 'महिला';

  @override
  String get english => 'अंग्रेजी';

  @override
  String get hindi => 'हिंदी';

  @override
  String get language => 'भाषा';

  @override
  String get voiceGender => 'आवाज़ लिंग';

  @override
  String replyCounter(int count) {
    return 'जवाब $count';
  }

  @override
  String get noHistory => 'अभी तक कोई चैट इतिहास नहीं';

  @override
  String get login => 'लॉगिन';

  @override
  String get logout => 'लॉगआउट';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get history => 'इतिहास';

  @override
  String get replay => 'फिर से चलाएं';

  @override
  String get loginWithJWT => 'JWT टोकन से लॉगिन करें';
}