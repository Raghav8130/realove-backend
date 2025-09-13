import 'app_localizations.dart';

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Realove AI';

  @override
  String get voicePageTitle => 'Voice Companion';

  @override
  String get settingsPageTitle => 'Settings';

  @override
  String get historyPageTitle => 'Chat History';

  @override
  String get onboardingTitle => 'Welcome to Realove AI';

  @override
  String get onboardingSubtitle => 'Your emotionally tuned voice companion';

  @override
  String get startChatting => 'Start Chatting';

  @override
  String get tapToSpeak => 'Tap to speak';

  @override
  String get listening => 'Listening...';

  @override
  String get processing => 'Processing...';

  @override
  String get male => 'Male';

  @override
  String get female => 'Female';

  @override
  String get english => 'English';

  @override
  String get hindi => 'Hindi';

  @override
  String get language => 'Language';

  @override
  String get voiceGender => 'Voice Gender';

  @override
  String replyCounter(int count) {
    return 'Reply $count';
  }

  @override
  String get noHistory => 'No chat history yet';

  @override
  String get login => 'Login';

  @override
  String get logout => 'Logout';

  @override
  String get settings => 'Settings';

  @override
  String get history => 'History';

  @override
  String get replay => 'Replay';

  @override
  String get loginWithJWT => 'Login with JWT Token';
}