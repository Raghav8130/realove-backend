import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../flutter_gen/gen_l10n/app_localizations.dart';
import '../services/audio_service.dart';
import '../services/prompt_repository.dart';
import '../services/memory_service.dart';
import '../models/models.dart';
import '../main.dart';

class VoicePage extends StatefulWidget {
  const VoicePage({super.key});

  @override
  State<VoicePage> createState() => _VoicePageState();
}

class _VoicePageState extends State<VoicePage> with TickerProviderStateMixin {
  late AnimationController _micController;
  late AnimationController _rippleController;
  late Animation<double> _micAnimation;
  late Animation<double> _rippleAnimation;

  bool _isListening = false;
  bool _isProcessing = false;
  int _replyCount = 0;
  Prompt? _currentPrompt;

  @override
  void initState() {
    super.initState();
    
    _micController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _rippleController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _micAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _micController,
      curve: Curves.easeInOut,
    ));

    _rippleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _rippleController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _micController.dispose();
    _rippleController.dispose();
    super.dispose();
  }

  Future<void> _handleMicTap() async {
    if (_isListening || _isProcessing) return;

    setState(() {
      _isListening = true;
    });

    _micController.forward();
    _rippleController.repeat();

    // Simulate listening for 2 seconds
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isListening = false;
      _isProcessing = true;
    });

    _rippleController.stop();
    
    // Simulate processing and get a response
    await _processUserInput();
  }

  Future<void> _processUserInput() async {
    try {
      final promptRepo = context.read<PromptRepository>();
      final audioService = context.read<AudioService>();
      final memoryService = context.read<MemoryService>();
      final appState = context.read<AppState>();

      // Get a random prompt based on gender preference
      final prompt = await promptRepo.getRandomPromptByGender(
        appState.voiceGender
      );

      if (prompt != null) {
        setState(() {
          _currentPrompt = prompt;
          _replyCount++;
        });

        // Save to history
        await memoryService.addToHistory(prompt);

        // Play audio response
        try {
          await audioService.playPrompt(prompt);
        } catch (e) {
          // Handle audio playback error silently
          debugPrint('Audio playback failed: $e');
        }
      }
    } catch (e) {
      debugPrint('Failed to process input: $e');
    } finally {
      setState(() {
        _isProcessing = false;
      });
      _micController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final appState = context.watch<AppState>();
    final audioService = context.watch<AudioService>();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.voicePageTitle),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => context.push('/settings'),
            icon: const Icon(Icons.settings),
          ),
          IconButton(
            onPressed: () => context.push('/history'),
            icon: const Icon(Icons.history),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.primary.withOpacity(0.1),
              theme.colorScheme.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                // Status toggles
                _buildStatusToggles(l10n, appState),
                
                const SizedBox(height: 40),
                
                // Reply counter
                if (_replyCount > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      l10n.replyCounter(_replyCount),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                const Spacer(),

                // Current prompt display
                if (_currentPrompt != null)
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          _currentPrompt!.emotion,
                          style: const TextStyle(fontSize: 32),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _currentPrompt!.text,
                          style: theme.textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                const Spacer(),

                // Microphone button
                _buildMicrophoneButton(l10n, theme, audioService),

                const SizedBox(height: 40),

                // Status text
                _buildStatusText(l10n, theme),

                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusToggles(AppLocalizations l10n, AppState appState) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildToggleChip(
          label: appState.voiceGender == 'male' ? l10n.male : l10n.female,
          isSelected: true,
          onTap: () async {
            final newGender = appState.voiceGender == 'male' ? 'female' : 'male';
            await appState.setVoiceGender(newGender);
          },
        ),
        _buildToggleChip(
          label: appState.language == 'en' ? l10n.english : l10n.hindi,
          isSelected: true,
          onTap: () async {
            final newLang = appState.language == 'en' ? 'hi' : 'en';
            await appState.setLanguage(newLang);
          },
        ),
      ],
    );
  }

  Widget _buildToggleChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: theme.colorScheme.primary,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : theme.colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildMicrophoneButton(
    AppLocalizations l10n,
    ThemeData theme,
    AudioService audioService,
  ) {
    return GestureDetector(
      onTap: _handleMicTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Ripple effect
          if (_isListening)
            AnimatedBuilder(
              animation: _rippleAnimation,
              builder: (context, child) {
                return Container(
                  width: 160 + (40 * _rippleAnimation.value),
                  height: 160 + (40 * _rippleAnimation.value),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.colorScheme.primary.withOpacity(
                      0.3 * (1 - _rippleAnimation.value),
                    ),
                  ),
                );
              },
            ),

          // Main microphone button
          AnimatedBuilder(
            animation: _micAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _micAnimation.value,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.primary.withOpacity(0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Icon(
                    _isListening ? Icons.mic : Icons.mic_none_outlined,
                    color: Colors.white,
                    size: 48,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatusText(AppLocalizations l10n, ThemeData theme) {
    String statusText;
    if (_isListening) {
      statusText = l10n.listening;
    } else if (_isProcessing) {
      statusText = l10n.processing;
    } else {
      statusText = l10n.tapToSpeak;
    }

    return Text(
      statusText,
      style: theme.textTheme.bodyLarge?.copyWith(
        color: theme.colorScheme.primary,
        fontWeight: FontWeight.w600,
      ),
      textAlign: TextAlign.center,
    );
  }
}