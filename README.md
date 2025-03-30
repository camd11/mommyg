# MommyG - An Emotionally Supportive AI Mother App

MommyG is a Flutter application that provides emotional support and guidance through an AI mother figure. The app offers a nurturing and empathetic experience, helping users manage their emotional well-being through various features.

[![MommyG App Demo](https://img.youtube.com/vi/oAcuuIn8QVg/0.jpg)](https://www.youtube.com/watch?v=oAcuuIn8QVg)

## Features

- **Chat with MommyG**: Engage in supportive conversations with an AI mother figure powered by Google's Gemini AI
- **Voice Interaction**: Speak to MommyG and hear her responses through high-quality text-to-speech
- **Mood Tracker**: Track your emotional state over time with a visual chart
- **Journal**: Record your thoughts and feelings
- **Guided Meditation**: Access calming guided meditations narrated by MommyG
- **Daily Affirmations**: Receive positive affirmations to boost your mental well-being
- **Multilingual Support**: Available in English, Spanish, Chinese, Hindi, and Korean

## Getting Started

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK
- Android Studio or VS Code with Flutter extensions

### API Keys

MommyG requires two API keys to function properly:

1. **Google Gemini API Key**: For the AI conversation capabilities
   - Sign up at [Google AI Studio](https://makersuite.google.com/app/apikey)
   - Create an API key for Gemini

2. **ElevenLabs API Key**: For high-quality text-to-speech
   - Sign up at [ElevenLabs](https://elevenlabs.io/)
   - Create an API key in your account settings

### Environment Setup

1. Clone the repository:
   ```
   git clone https://github.com/camd11/mommyg.git
   cd mommyg
   ```

2. Copy the `.env.example` file to `.env` and add your API keys:
   ```
   cp .env.example .env
   ```
   Then edit the `.env` file to replace the placeholder values with your actual API keys.

3. Install dependencies:
   ```
   flutter pub get
   ```

4. Run the app:
   ```
   flutter run
   ```

## Building for Production

### Android

```
flutter build apk --release
```

The APK will be available at `build/app/outputs/flutter-apk/app-release.apk`

### iOS

```
flutter build ios --release
```

Then use Xcode to archive and distribute the app.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
