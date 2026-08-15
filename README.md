# Romyo - Voice Chat Room

A Flutter-based voice chat application that allows users to make peer-to-peer voice calls with real-time user presence.

## 🚀 Features

- **User Authentication**: Firebase Email/Password authentication
- **User Management**: Real-time user status tracking
- **Voice Calling**: Peer-to-peer voice calls using Agora RTC
- **User Presence**: See online/offline status of users
- **Call Management**: Initiate, mute, and end calls

## 📋 Prerequisites

- Flutter SDK (>=3.0.0)
- Firebase Project
- Agora Account
- Android & iOS development environment

## 🔧 Setup Instructions

### 1. Clone Repository
```bash
git clone https://github.com/merajansari82871-boop/romyo-voice-chat-room.git
cd romyo-voice-chat-room
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Firebase Setup

1. Create a Firebase project at https://firebase.google.com
2. Enable Authentication (Email/Password)
3. Create Firestore Database
4. Download google-services.json (Android) and GoogleService-Info.plist (iOS)
5. Place them in respective directories:
   - Android: `android/app/`
   - iOS: `ios/Runner/`

6. Update `lib/firebase_options.dart` with your Firebase credentials

### 4. Agora Setup

1. Create an Agora account at https://console.agora.io
2. Get your App ID
3. Update `lib/services/agora_service.dart`:
```dart
String agoraAppId = 'YOUR_AGORA_APP_ID';
```

### 5. Permissions (Android)

Add to `android/app/src/main/AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.MICROPHONE" />
<uses-permission android:name="android.permission.INTERNET" />
```

### 6. Permissions (iOS)

Add to `ios/Runner/Info.plist`:
```xml
<key>NSMicrophoneUsageDescription</key>
<string>This app requires microphone access to make voice calls</string>
<key>NSLocalNetworkUsageDescription</key>
<string>This app requires local network access</string>
```

## 📱 Running the App

### Android
```bash
flutter run
```

### iOS
```bash
cd ios
pod install
cd ..
flutter run
```

## 🏗️ Project Structure

```
lib/
├── main.dart                 # App entry point
├── firebase_options.dart     # Firebase configuration
├── models/
│   └── user_model.dart      # User data model
├── services/
│   ├── auth_service.dart    # Authentication logic
│   └── agora_service.dart   # Voice calling logic
└── screens/
    ├── login_screen.dart    # Login/Signup UI
    ├── home_screen.dart     # User list
    └── voice_call_screen.dart # Call UI
```

## 🔐 Security Notes

- Never commit firebase_options.dart with real credentials
- Keep Agora App ID secure
- Use environment variables for sensitive data in production

## 📦 Dependencies

- **firebase_core**: ^2.24.0
- **firebase_auth**: ^4.15.0
- **cloud_firestore**: ^4.14.0
- **agora_rtc_engine**: ^6.2.0
- **permission_handler**: ^11.4.4
- **get**: ^4.6.5

## 🤝 Contributing

Feel free to fork and contribute to this project!

## 📄 License

This project is licensed under the MIT License - see LICENSE file for details.

## 📧 Support

For issues and questions, please create an issue on GitHub.

---

**Happy Coding! 🎉**
