# Realove AI Flutter App 💝

An emotionally immersive voice companion that comforts users through emotionally tuned voice replies.

## Features ✨

- **Multi-language Support**: Hindi and English languages
- **Voice Gender Toggle**: Male/female voice options
- **CDN Voice Playback**: High-quality audio responses
- **Persistent Preferences**: User settings saved with SharedPreferences
- **JWT Authentication**: Secure user authentication
- **Emotional UX Design**: Orange-themed interface with smooth animations
- **Chat History**: Review and replay past conversations
- **Real-time Audio**: Interactive voice conversations

## Architecture 🏗️

### Core Components

- **Models**: Data structures for prompts, preferences, and authentication
- **Services**: 
  - `AudioService`: Voice playback functionality
  - `MemoryService`: Local data persistence
  - `AuthService`: JWT token management
  - `ApiService`: Secure backend communication
  - `PromptRepository`: Sample data management

### UI Pages

- **OnboardingPage**: Welcome screen with emotional animations
- **VoicePage**: Main chat interface with microphone and voice controls
- **SettingsPage**: Language and gender preference management
- **HistoryPage**: Past conversations with replay functionality

## Getting Started 🚀

### Prerequisites

- Flutter SDK (>=3.10.0)
- Dart SDK (>=3.0.0)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/Raghav8130/realove-backend.git
   cd realove-backend
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code** (if needed)
   ```bash
   flutter packages pub run build_runner build
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

## Project Structure 📁

```
lib/
├── flutter_gen/           # Generated localization files
├── l10n/                  # Localization resources
├── models/                # Data models
├── pages/                 # UI screens
├── services/              # Business logic services
├── widgets/               # Reusable UI components
└── main.dart             # App entry point

assets/
├── prompts/              # Sample conversation data
└── images/               # App images and icons
```

## Key Technologies 🛠️

- **Flutter**: Cross-platform mobile framework
- **Provider**: State management
- **SharedPreferences**: Local data storage
- **AudioPlayers**: Voice playback
- **GoRouter**: Navigation
- **JWT Decoder**: Authentication handling
- **Flutter Localizations**: Multi-language support

## Features in Detail 📱

### Voice Interface
- Tap-to-speak microphone with visual feedback
- Real-time audio processing animations
- Gender-specific voice responses
- Audio playback controls

### Personalization
- Language switching (English/Hindi)
- Voice gender preferences (Male/Female)
- Dark/Light theme toggle
- Persistent user settings

### Chat History
- Chronological conversation history
- Replay functionality for past responses
- Emotional context indicators
- Time-stamped entries

### Authentication
- JWT-based secure authentication
- Token expiration handling
- Automatic session management

## API Integration 🌐

The app is designed to work with the Realove AI backend API:

- **Base URL**: `https://api.realove.ai`
- **Endpoints**:
  - `GET /prompts`: Fetch conversation prompts
  - `POST /user/preferences`: Save user settings
  - `GET /user/chat-history`: Retrieve conversation history
  - `POST /user/chat-history`: Save new conversations

## Customization 🎨

### Theme Colors
- Primary: Orange (`#FF6B35`)
- Secondary: Dark Orange (`#E55A2B`)
- Customizable through `ThemeData` in `main.dart`

### Localization
- Add new languages by creating `.arb` files in `lib/l10n/`
- Update `supportedLocales` in `main.dart`
- Run `flutter gen-l10n` to generate translation files

## Development Notes 📝

### Code Generation
Some files are generated automatically:
- `lib/models/models.g.dart`: JSON serialization
- `lib/flutter_gen/`: Localization files

### Testing
- Unit tests for services and models
- Widget tests for UI components
- Integration tests for complete user flows

## Contributing 🤝

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License 📄

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support 💬

For support and questions:
- Create an issue on GitHub
- Contact the Realove AI team

---

Made with ❤️ by the Realove AI Team
