import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../flutter_gen/gen_l10n/app_localizations.dart';
import '../main.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final appState = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settingsPageTitle),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Language Setting
          _buildSettingCard(
            context: context,
            title: l10n.language,
            subtitle: appState.language == 'en' ? l10n.english : l10n.hindi,
            icon: Icons.language,
            onTap: () => _showLanguageDialog(context, appState, l10n),
          ),

          const SizedBox(height: 16),

          // Voice Gender Setting
          _buildSettingCard(
            context: context,
            title: l10n.voiceGender,
            subtitle: appState.voiceGender == 'male' ? l10n.male : l10n.female,
            icon: Icons.record_voice_over,
            onTap: () => _showGenderDialog(context, appState, l10n),
          ),

          const SizedBox(height: 16),

          // Dark Mode Setting
          _buildSettingCard(
            context: context,
            title: 'Dark Mode',
            subtitle: appState.isDarkMode ? 'Enabled' : 'Disabled',
            icon: appState.isDarkMode ? Icons.dark_mode : Icons.light_mode,
            onTap: () => appState.setDarkMode(!appState.isDarkMode),
            trailing: Switch(
              value: appState.isDarkMode,
              onChanged: appState.setDarkMode,
            ),
          ),

          const SizedBox(height: 32),

          // Account Section Header
          Text(
            'Account',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          // Login Setting
          _buildSettingCard(
            context: context,
            title: l10n.loginWithJWT,
            subtitle: 'Manage authentication',
            icon: Icons.login,
            onTap: () => _showLoginDialog(context, l10n),
          ),

          const SizedBox(height: 16),

          // Logout Setting (if logged in)
          _buildSettingCard(
            context: context,
            title: l10n.logout,
            subtitle: 'Sign out of your account',
            icon: Icons.logout,
            iconColor: Colors.red,
            onTap: () => _showLogoutDialog(context, l10n),
          ),

          const SizedBox(height: 32),

          // App Info Section
          Text(
            'About',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          _buildInfoCard(
            context: context,
            title: 'App Version',
            value: '1.0.0',
            icon: Icons.info_outline,
          ),

          const SizedBox(height: 8),

          _buildInfoCard(
            context: context,
            title: 'Developer',
            value: 'Realove AI Team',
            icon: Icons.code,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
    Widget? trailing,
    Color? iconColor,
  }) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: (iconColor ?? theme.colorScheme.primary).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: iconColor ?? theme.colorScheme.primary,
            size: 24,
          ),
        ),
        title: Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        trailing: trailing ?? const Icon(Icons.chevron_right),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required BuildContext context,
    required String title,
    required String value,
    required IconData icon,
  }) {
    final theme = Theme.of(context);

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: theme.colorScheme.onSurface.withOpacity(0.7),
        ),
        title: Text(
          title,
          style: theme.textTheme.bodyMedium,
        ),
        trailing: Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 4,
        ),
      ),
    );
  }

  void _showLanguageDialog(
    BuildContext context,
    AppState appState,
    AppLocalizations l10n,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.language),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: Text(l10n.english),
              value: 'en',
              groupValue: appState.language,
              onChanged: (value) {
                if (value != null) {
                  appState.setLanguage(value);
                  Navigator.of(context).pop();
                }
              },
            ),
            RadioListTile<String>(
              title: Text(l10n.hindi),
              value: 'hi',
              groupValue: appState.language,
              onChanged: (value) {
                if (value != null) {
                  appState.setLanguage(value);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showGenderDialog(
    BuildContext context,
    AppState appState,
    AppLocalizations l10n,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.voiceGender),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: Text(l10n.female),
              value: 'female',
              groupValue: appState.voiceGender,
              onChanged: (value) {
                if (value != null) {
                  appState.setVoiceGender(value);
                  Navigator.of(context).pop();
                }
              },
            ),
            RadioListTile<String>(
              title: Text(l10n.male),
              value: 'male',
              groupValue: appState.voiceGender,
              onChanged: (value) {
                if (value != null) {
                  appState.setVoiceGender(value);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showLoginDialog(BuildContext context, AppLocalizations l10n) {
    final TextEditingController tokenController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.loginWithJWT),
        content: TextField(
          controller: tokenController,
          decoration: const InputDecoration(
            labelText: 'JWT Token',
            hintText: 'Paste your JWT token here',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement JWT login
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Login functionality coming soon')),
              );
            },
            child: Text(l10n.login),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.logout),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement logout
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Logged out successfully')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text(l10n.logout),
          ),
        ],
      ),
    );
  }
}