#!/bin/bash

echo "🚀 Setting up Realove AI Flutter App"
echo "======================================"

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed. Please install Flutter SDK first."
    echo "   Visit: https://docs.flutter.dev/get-started/install"
    exit 1
fi

echo "✅ Flutter found!"

# Check Flutter version
flutter --version

echo ""
echo "📦 Installing dependencies..."
flutter pub get

echo ""
echo "🏗️  Generating code..."
flutter packages pub run build_runner build --delete-conflicting-outputs

echo ""
echo "🌍 Generating localizations..."
flutter gen-l10n

echo ""
echo "🔍 Running analysis..."
flutter analyze

echo ""
echo "🧪 Running tests..."
flutter test

echo ""
echo "✅ Setup complete!"
echo ""
echo "🏃‍♂️ To run the app:"
echo "   flutter run"
echo ""
echo "📱 To build for release:"
echo "   flutter build apk --release  # Android"
echo "   flutter build ios --release   # iOS"
echo ""
echo "Happy coding! 🎉"