import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'services/memory_service.dart';
import 'services/auth_service.dart';
import 'services/audio_service.dart';
import 'services/prompt_repository.dart';
import 'services/api_service.dart';
import 'pages/onboarding_page.dart';
import 'pages/voice_page.dart';
import 'pages/settings_page.dart';
import 'pages/history_page.dart';
import 'models/models.dart';
import 'flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  runApp(const RealoveApp());
}

class RealoveApp extends StatelessWidget {
  const RealoveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<MemoryService>(create: (_) => MemoryService()),
        Provider<PromptRepository>(create: (_) => PromptRepository()),
        Provider<AudioService>(create: (_) => AudioService()),
        ProxyProvider<MemoryService, AuthService>(
          update: (_, memoryService, __) => AuthService(memoryService),
        ),
        ProxyProvider<AuthService, ApiService>(
          update: (_, authService, __) => ApiService(
            baseUrl: 'https://api.realove.ai',
            authService: authService,
          ),
        ),
        ChangeNotifierProvider<AppState>(
          create: (context) => AppState(
            memoryService: context.read<MemoryService>(),
          ),
        ),
      ],
      child: Consumer<AppState>(
        builder: (context, appState, child) {
          return MaterialApp.router(
            title: 'Realove AI',
            debugShowCheckedModeBanner: false,
            theme: _buildTheme(appState.isDarkMode),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'),
              Locale('hi'),
            ],
            locale: Locale(appState.language),
            routerConfig: _router,
          );
        },
      ),
    );
  }

  ThemeData _buildTheme(bool isDarkMode) {
    const orange = Color(0xFFFF6B35);
    const darkOrange = Color(0xFFE55A2B);
    
    return ThemeData(
      useMaterial3: true,
      brightness: isDarkMode ? Brightness.dark : Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: orange,
        brightness: isDarkMode ? Brightness.dark : Brightness.light,
      ).copyWith(
        primary: orange,
        secondary: darkOrange,
        surface: isDarkMode ? const Color(0xFF1A1A1A) : Colors.white,
        onSurface: isDarkMode ? Colors.white : Colors.black87,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: orange,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: orange,
        foregroundColor: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: orange,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}

final GoRouter _router = GoRouter(
  initialLocation: '/onboarding',
  routes: [
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingPage(),
    ),
    GoRoute(
      path: '/voice',
      builder: (context, state) => const VoicePage(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsPage(),
    ),
    GoRoute(
      path: '/history',
      builder: (context, state) => const HistoryPage(),
    ),
  ],
);

class AppState extends ChangeNotifier {
  final MemoryService _memoryService;
  
  UserPreferences _preferences = const UserPreferences(
    language: 'en',
    voiceGender: 'female',
    isDarkMode: false,
  );

  AppState({required MemoryService memoryService}) : _memoryService = memoryService {
    _loadPreferences();
  }

  UserPreferences get preferences => _preferences;
  String get language => _preferences.language;
  String get voiceGender => _preferences.voiceGender;
  bool get isDarkMode => _preferences.isDarkMode;

  Future<void> _loadPreferences() async {
    try {
      _preferences = await _memoryService.getUserPreferences();
      notifyListeners();
    } catch (e) {
      // Use default preferences if loading fails
    }
  }

  Future<void> updatePreferences(UserPreferences newPreferences) async {
    _preferences = newPreferences;
    await _memoryService.saveUserPreferences(_preferences);
    notifyListeners();
  }

  Future<void> setLanguage(String language) async {
    await updatePreferences(_preferences.copyWith(language: language));
  }

  Future<void> setVoiceGender(String gender) async {
    await updatePreferences(_preferences.copyWith(voiceGender: gender));
  }

  Future<void> setDarkMode(bool isDark) async {
    await updatePreferences(_preferences.copyWith(isDarkMode: isDark));
  }
}