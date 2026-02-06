# Group 31 - Formative Assignment 1: ALU Student Academic Platform

**Group Name:** Group 31  
**Assignment:** Formative Assignment 1  
**Project:** ALU Student Academic Platform

A Flutter mobile application for African Leadership University students to manage their academic responsibilities including assignments, class schedules, and attendance tracking.

## Features

- **Dashboard**: View today's sessions, upcoming assignments, and attendance status
- **Assignment Management**: Create, edit, and track assignments with priorities
- **Session Scheduling**: Manage class schedules and academic sessions
- **Attendance Tracking**: Record and monitor attendance with automatic percentage calculation
- **Firebase Integration**: Cloud-based data storage with offline support

## Prerequisites

- Flutter SDK (3.10.4 or higher)
- Dart SDK (3.10.4 or higher)
- Firebase account
- Android Studio / Xcode (for mobile development)
- Firebase CLI
- FlutterFire CLI

## Installation

### 1. Clone the repository

```bash
git clone <repository-url>
cd Group31_FormativeAssignment1
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Configure Firebase

Follow the instructions in [FIREBASE_SETUP.md](FIREBASE_SETUP.md) to:
- Create a Firebase project
- Run `flutterfire configure`
- Enable Firestore Database

### 4. Run the app

```bash
# Run on connected device or emulator
flutter run

# Run on specific device
flutter devices
flutter run -d <device-id>
```

## Project Structure

```
lib/
├── config/          # Theme and configuration files
├── models/          # Data models (Assignment, Session, etc.)
├── providers/       # State management (Provider pattern)
├── screens/         # UI screens
├── services/        # Firebase and business logic services
├── utils/           # Utility functions and helpers
├── widgets/         # Reusable UI components
├── firebase_options.dart  # Firebase configuration
└── main.dart        # App entry point
```

## Development Team

- **Developer 1**: Firebase setup + Assignment features
- **Developer 2**: Session scheduling + Attendance tracking
- **Developer 3**: Dashboard + UI/UX polish
- **Developer 4**: Navigation + Integration + Testing

## Tech Stack

- **Framework**: Flutter 3.38.5
- **Language**: Dart 3.10.4
- **Database**: Firebase Firestore
- **State Management**: Provider
- **Date Handling**: intl package

## Git Workflow

### Branch Structure

- `main`: Production-ready code
- `dev`: Development branch
- `feature/assignments`: Assignment features
- `feature/sessions`: Session and attendance features
- `feature/dashboard`: Dashboard and UI
- `feature/navigation`: Navigation and integration

### Commit Convention

- `feat`: New feature
- `fix`: Bug fix
- `test`: Adding tests
- `refactor`: Code refactoring
- `docs`: Documentation changes
- `style`: Code style changes

Example: `feat: add assignment creation form`

## Running Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/models/assignment_test.dart

# Run with coverage
flutter test --coverage
```

## Building for Production

### Android

```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

### iOS

```bash
flutter build ios --release
# Open in Xcode for signing and distribution
```

## Troubleshooting

### Firebase Connection Issues

- Verify `firebase_options.dart` is properly configured
- Check internet connection
- Ensure Firestore is enabled in Firebase Console

### Build Errors

```bash
# Clean build
flutter clean
flutter pub get
flutter run
```

### Dependency Issues

```bash
# Update dependencies
flutter pub upgrade
```

## License

This project is developed for the ALU Mobile Development Module January 2026.

## Contact

For questions or issues, contact the development team.
