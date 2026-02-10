# ALU Student Academic Platform

<div align="center">

**Group 31 - Formative Assignment 1**

A comprehensive Flutter mobile application designed to help African Leadership University students manage their academic responsibilities efficiently.

[![Flutter](https://img.shields.io/badge/Flutter-3.0+-02569B?logo=flutter)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Firestore-FFCA28?logo=firebase)](https://firebase.google.com)
[![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?logo=dart)](https://dart.dev)

</div>

---

## 📱 Overview

The ALU Student Academic Platform is a mobile application that empowers students to:
- Track assignments with priority levels and due dates
- Manage class schedules and academic sessions
- Record and monitor attendance with automatic percentage calculation
- Access all data offline with automatic cloud synchronization
- View a comprehensive dashboard with academic insights

Built with Flutter and Firebase, the app provides a seamless, responsive experience across Android and iOS devices.

---

## ✨ Key Features

### 📊 Dashboard
- **Current Date & Academic Week**: Always know where you are in the semester
- **Today's Sessions**: Quick view of all classes and meetings scheduled for today
- **Upcoming Assignments**: See assignments due in the next 7 days
- **Attendance Monitor**: Real-time attendance percentage with visual warnings below 75%
- **Pending Tasks**: Count of incomplete assignments at a glance

### 📝 Assignment Management
- Create, edit, and delete assignments
- Set priority levels (High, Medium, Low) with color coding
- Track completion status with one-tap toggle
- Automatic sorting by due date
- Course-based organization

### 📅 Session Scheduling
- Manage all academic sessions (Classes, Mastery Sessions, Study Groups, PSL Meetings)
- Week-by-week navigation
- Time and location tracking
- Session type badges for easy identification
- Edit and delete functionality

### ✅ Attendance Tracking
- Record attendance as Present or Absent
- Automatic percentage calculation
- Visual warnings when attendance drops below 75%
- Complete attendance history
- Real-time dashboard updates

### ☁️ Cloud & Offline Support
- Firebase Firestore for cloud storage
- Automatic offline persistence
- Real-time synchronization across devices
- Optimistic updates for instant UI feedback
- Sync status indicator

---

## 🔧 Prerequisites

Before you begin, ensure you have the following installed:

### Required Software
- **Flutter SDK**: Version 3.0.0 or higher
  - [Installation Guide](https://docs.flutter.dev/get-started/install)
- **Dart SDK**: Version 3.0.0 or higher (included with Flutter)
- **Git**: For version control
- **Code Editor**: VS Code or Android Studio recommended

### Platform-Specific Requirements

#### For Android Development
- **Android Studio**: Latest stable version
- **Android SDK**: API level 21 (Android 5.0) or higher
- **Java Development Kit (JDK)**: Version 11 or higher

#### For iOS Development (macOS only)
- **Xcode**: Latest stable version
- **CocoaPods**: For iOS dependency management
- **iOS Simulator** or physical iOS device

### Firebase Requirements
- **Firebase Account**: Free tier is sufficient
  - [Create Firebase Account](https://firebase.google.com)
- **Firebase CLI**: For project configuration
  ```bash
  npm install -g firebase-tools
  ```
- **FlutterFire CLI**: For Flutter-Firebase integration
  ```bash
  dart pub global activate flutterfire_cli
  ```

### Verification
Verify your installation by running:
```bash
flutter doctor
```
Ensure all required components show a checkmark (✓).

---

## 🚀 Installation

Follow these steps to set up the project on your local machine:

### 1. Clone the Repository

```bash
git clone <repository-url>
cd Group31_FormativeAssignment1
```

### 2. Install Flutter Dependencies

```bash
flutter pub get
```

This will install all required packages:
- `firebase_core`: Firebase initialization
- `cloud_firestore`: Cloud database
- `provider`: State management
- `intl`: Date/time formatting
- `connectivity_plus`: Network status monitoring

### 3. Verify Flutter Setup

```bash
flutter doctor -v
```

Resolve any issues reported before proceeding.

---

## 🔥 Firebase Configuration

The app requires Firebase Firestore for data storage. Follow these steps carefully:

### Step 1: Create a Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Click **"Add project"** or **"Create a project"**
3. Enter project name: `alu-academic-platform` (or your preferred name)
4. Disable Google Analytics (optional for this project)
5. Click **"Create project"** and wait for setup to complete

### Step 2: Enable Firestore Database

1. In Firebase Console, navigate to **Build** → **Firestore Database**
2. Click **"Create database"**
3. Select **"Start in test mode"** (for development)
   ```
   rules_version = '2';
   service cloud.firestore {
     match /databases/{database}/documents {
       match /{document=**} {
         allow read, write: if true;
       }
     }
   }
   ```
   ⚠️ **Note**: For production, implement proper security rules
4. Choose a Firestore location (select closest to your region)
5. Click **"Enable"**

### Step 3: Configure Flutter App with Firebase

#### Option A: Using FlutterFire CLI (Recommended)

1. **Login to Firebase**:
   ```bash
   firebase login
   ```

2. **Configure FlutterFire**:
   ```bash
   flutterfire configure
   ```

3. **Follow the prompts**:
   - Select your Firebase project
   - Choose platforms: Android and iOS
   - The CLI will automatically generate `firebase_options.dart`

#### Option B: Manual Configuration

##### For Android:

1. In Firebase Console, click **"Add app"** → **Android**
2. Enter Android package name: `com.example.alu_academic_platform`
   - Find in `android/app/build.gradle` under `applicationId`
3. Download `google-services.json`
4. Place file in `android/app/` directory
5. Ensure `android/build.gradle` includes:
   ```gradle
   dependencies {
       classpath 'com.google.gms:google-services:4.3.15'
   }
   ```
6. Ensure `android/app/build.gradle` includes:
   ```gradle
   apply plugin: 'com.google.gms.google-services'
   ```

##### For iOS:

1. In Firebase Console, click **"Add app"** → **iOS**
2. Enter iOS bundle ID: `com.example.aluAcademicPlatform`
   - Find in `ios/Runner.xcodeproj/project.pbxproj`
3. Download `GoogleService-Info.plist`
4. Open `ios/Runner.xcworkspace` in Xcode
5. Drag `GoogleService-Info.plist` into `Runner` folder in Xcode
6. Ensure "Copy items if needed" is checked

### Step 4: Verify Firebase Configuration

1. **Check `firebase_options.dart` exists**:
   ```bash
   ls lib/firebase_options.dart
   ```

2. **Run the app**:
   ```bash
   flutter run
   ```

3. **Verify in Firebase Console**:
   - Go to Firestore Database
   - Create a test assignment or session in the app
   - Check if data appears in Firestore collections

### Step 5: Configure Firestore Indexes (Optional but Recommended)

For optimal query performance, create these composite indexes:

1. Go to **Firestore Database** → **Indexes** tab
2. Click **"Create Index"**

**Index 1: Assignments by completion and due date**
- Collection ID: `assignments`
- Fields:
  - `isCompleted` (Ascending)
  - `dueDate` (Ascending)
- Query scope: Collection

**Index 2: Sessions by date and time**
- Collection ID: `sessions`
- Fields:
  - `date` (Ascending)
  - `startTime` (Ascending)
- Query scope: Collection

**Index 3: Sessions with attendance**
- Collection ID: `sessions`
- Fields:
  - `attendanceStatus` (Ascending)
  - `date` (Descending)
- Query scope: Collection

> **Note**: The app will suggest creating these indexes automatically when you run queries that need them.

---

## 🏃 Running the App

### Start an Emulator/Simulator

#### Android Emulator:
```bash
# List available emulators
flutter emulators

# Launch an emulator
flutter emulators --launch <emulator-id>
```

Or open Android Studio → AVD Manager → Start emulator

#### iOS Simulator (macOS only):
```bash
open -a Simulator
```

### Run the Application

```bash
# Run on default device
flutter run

# List all connected devices
flutter devices

# Run on specific device
flutter run -d <device-id>

# Run in debug mode (default)
flutter run --debug

# Run in release mode (optimized)
flutter run --release

# Run with hot reload enabled
flutter run --hot
```

### Expected Behavior

On first launch:
1. App initializes Firebase connection
2. Empty dashboard appears (no data yet)
3. Bottom navigation shows three tabs: Dashboard, Assignments, Schedule
4. You can create assignments and sessions
5. Data automatically syncs to Firestore

---

## 🧪 Running Tests

The project includes comprehensive test coverage:

### Run All Tests

```bash
flutter test
```

### Run Specific Test Files

```bash
# Model tests
flutter test test/models/assignment_test.dart

# Widget tests
flutter test test/widget_test.dart

# Edge cases tests
flutter test test/edge_cases_test.dart

# Offline support tests
flutter test test/offline_support_test.dart

# Utility tests
flutter test test/utils_test.dart
```

### Run Tests with Coverage

```bash
# Generate coverage report
flutter test --coverage

# View coverage (requires lcov)
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### Test Categories

- **Unit Tests**: Test individual functions and classes
- **Widget Tests**: Test UI components in isolation
- **Integration Tests**: Test complete user workflows
- **Edge Case Tests**: Test boundary conditions and error handling
- **Offline Tests**: Test offline persistence and sync

---

## 📁 Project Structure

```
Group31_FormativeAssignment1/
├── lib/
│   ├── config/
│   │   ├── theme.dart              # App theme and color constants
│   │   └── animations.dart         # Animation configurations
│   ├── models/
│   │   ├── assignment.dart         # Assignment data model
│   │   ├── assignment_validator.dart
│   │   ├── session.dart            # Session data model
│   │   ├── session_validator.dart
│   │   └── dashboard_summary.dart  # Dashboard data model
│   ├── services/
│   │   ├── assignment_service.dart # Assignment Firestore operations
│   │   ├── session_service.dart    # Session Firestore operations
│   │   └── attendance_service.dart # Attendance calculations
│   ├── providers/
│   │   ├── assignment_provider.dart # Assignment state management
│   │   ├── session_provider.dart    # Session state management
│   │   ├── dashboard_provider.dart  # Dashboard state management
│   │   └── connectivity_provider.dart # Network status
│   ├── screens/
│   │   ├── dashboard_screen.dart    # Main dashboard
│   │   ├── assignments_screen.dart  # Assignment list
│   │   ├── assignment_form_dialog.dart
│   │   ├── schedule_screen.dart     # Session schedule
│   │   ├── session_form_dialog.dart
│   │   └── attendance_dialog.dart
│   ├── widgets/
│   │   ├── assignment_card.dart     # Assignment display card
│   │   ├── session_card.dart        # Session display card
│   │   ├── attendance_status_widget.dart
│   │   ├── priority_badge.dart
│   │   ├── session_type_badge.dart
│   │   ├── date_picker_field.dart
│   │   ├── time_picker_field.dart
│   │   └── sync_status_indicator.dart
│   ├── utils/
│   │   ├── error_handler.dart       # Error handling utilities
│   │   ├── debouncer.dart          # Input debouncing
│   │   └── text_utils.dart         # Text formatting helpers
│   ├── firebase_options.dart        # Firebase configuration
│   └── main.dart                    # App entry point
├── test/
│   ├── widget_test.dart
│   ├── edge_cases_test.dart
│   ├── offline_support_test.dart
│   └── utils_test.dart
├── android/                         # Android-specific files
├── ios/                            # iOS-specific files
├── pubspec.yaml                    # Dependencies
└── README.md                       # This file
```

---

## 🎨 Architecture

The app follows a **clean architecture** pattern with clear separation of concerns:

### Layers

1. **Presentation Layer** (`screens/`, `widgets/`)
   - UI components and user interactions
   - Consumes data from providers
   - No direct business logic

2. **State Management Layer** (`providers/`)
   - Manages application state using Provider pattern
   - Coordinates between UI and services
   - Handles loading states and errors

3. **Service Layer** (`services/`)
   - Encapsulates Firebase Firestore operations
   - Provides clean API for CRUD operations
   - Handles data transformation

4. **Data Layer** (Firebase Firestore)
   - Cloud-based NoSQL database
   - Real-time synchronization
   - Offline persistence

### State Management

The app uses the **Provider** pattern for state management:
- `ChangeNotifier` for reactive state updates
- `Consumer` widgets for efficient rebuilds
- `MultiProvider` for dependency injection

### Data Flow

```
User Action → Widget → Provider → Service → Firestore
                ↓         ↓         ↓          ↓
            UI Update ← Notify ← Stream ← Real-time Sync
```

---

## 🛠️ Tech Stack

| Category | Technology | Purpose |
|----------|-----------|---------|
| **Framework** | Flutter 3.0+ | Cross-platform mobile development |
| **Language** | Dart 3.0+ | Programming language |
| **Database** | Firebase Firestore | Cloud NoSQL database |
| **State Management** | Provider 6.1+ | Reactive state management |
| **Date/Time** | intl 0.19+ | Internationalization and formatting |
| **Connectivity** | connectivity_plus 6.0+ | Network status monitoring |
| **Authentication** | Firebase Auth | User authentication (future) |

---

## 👥 Development Team

| Developer | Role | Responsibilities |
|-----------|------|------------------|
| **Developer 1 (Ryan)** | Backend & Assignments | Firebase setup, Assignment features, data models |
| **Developer 2 (Ryan)** | Sessions & Attendance | Session scheduling, Attendance tracking, calculations |
| **Developer 3 (Samuel)** | UI/UX & Dashboard | Dashboard design, Visual polish, Responsive layouts |
| **Developer 4 (Claudia)** | Integration & Testing | Navigation, Testing, Documentation, Integration |

---

## 🔄 Git Workflow

### Branch Structure

```
main                    # Production-ready code
├── dev                # Development integration branch
    ├── feature/assignments      # Assignment features
    ├── feature/sessions        # Session and attendance
    ├── feature/dashboard       # Dashboard and UI
    └── feature/navigation      # Navigation and integration
```

### Commit Convention

Follow conventional commits format:

```
<type>: <description>

[optional body]
[optional footer]
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `test`: Adding or updating tests
- `refactor`: Code refactoring
- `docs`: Documentation changes
- `style`: Code style changes (formatting)
- `perf`: Performance improvements
- `chore`: Maintenance tasks

**Examples:**
```bash
feat: add assignment creation form
fix: resolve attendance percentage calculation bug
test: add unit tests for session validation
docs: update README with Firebase setup instructions
```

### Workflow

1. **Create feature branch**:
   ```bash
   git checkout dev
   git pull origin dev
   git checkout -b feature/your-feature-name
   ```

2. **Make changes and commit**:
   ```bash
   git add .
   git commit -m "feat: add your feature"
   ```

3. **Push to remote**:
   ```bash
   git push origin feature/your-feature-name
   ```

4. **Create Pull Request** to `dev` branch

5. **Merge to dev** after review

6. **Merge dev to main** for releases

---

## 📦 Building for Production

### Android APK

```bash
# Build release APK
flutter build apk --release

# Output location
# build/app/outputs/flutter-apk/app-release.apk

# Build split APKs (smaller size)
flutter build apk --split-per-abi

# Install on connected device
flutter install
```

### Android App Bundle (for Play Store)

```bash
# Build app bundle
flutter build appbundle --release

# Output location
# build/app/outputs/bundle/release/app-release.aab
```

### iOS

```bash
# Build iOS app
flutter build ios --release

# Open in Xcode for signing
open ios/Runner.xcworkspace

# Archive and distribute through Xcode
```

---

## 🐛 Troubleshooting

### Common Issues and Solutions

#### 1. Firebase Connection Issues

**Problem**: App can't connect to Firebase

**Solutions**:
- Verify `firebase_options.dart` exists and is properly configured
- Check internet connection
- Ensure Firestore is enabled in Firebase Console
- Verify Firebase project ID matches configuration
- Check Firebase Console for any service outages

```bash
# Reconfigure Firebase
flutterfire configure
```

#### 2. Build Errors

**Problem**: Build fails with dependency errors

**Solutions**:
```bash
# Clean build cache
flutter clean

# Remove pub cache
flutter pub cache repair

# Reinstall dependencies
flutter pub get

# Rebuild
flutter run
```

#### 3. Gradle Build Failures (Android)

**Problem**: Android build fails

**Solutions**:
```bash
# Navigate to android directory
cd android

# Clean Gradle cache
./gradlew clean

# Return to project root
cd ..

# Rebuild
flutter run
```

#### 4. CocoaPods Issues (iOS)

**Problem**: iOS build fails with CocoaPods errors

**Solutions**:
```bash
# Navigate to iOS directory
cd ios

# Remove Pods
rm -rf Pods Podfile.lock

# Reinstall pods
pod install --repo-update

# Return to project root
cd ..

# Rebuild
flutter run
```

#### 5. Firestore Permission Denied

**Problem**: Firestore operations fail with permission errors

**Solutions**:
- Check Firestore security rules in Firebase Console
- Ensure rules allow read/write access (for development)
- For production, implement proper authentication and rules

```javascript
// Development rules (Firebase Console → Firestore → Rules)
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if true;
    }
  }
}
```

#### 6. Hot Reload Not Working

**Problem**: Changes don't appear after hot reload

**Solutions**:
- Try hot restart: Press `R` in terminal or `Cmd/Ctrl + Shift + F5`
- Stop and restart the app
- Check for syntax errors in console

#### 7. Emulator Performance Issues

**Problem**: App runs slowly on emulator

**Solutions**:
- Enable hardware acceleration (Intel HAXM for Android)
- Allocate more RAM to emulator (2GB minimum)
- Use physical device for better performance
- Close other resource-intensive applications

#### 8. Dependency Version Conflicts

**Problem**: Package version conflicts

**Solutions**:
```bash
# Update all dependencies
flutter pub upgrade

# Check for outdated packages
flutter pub outdated

# Update specific package
flutter pub upgrade <package_name>
```

#### 9. Firebase Initialization Errors

**Problem**: Firebase fails to initialize

**Solutions**:
- Ensure `WidgetsFlutterBinding.ensureInitialized()` is called before Firebase initialization
- Check `main.dart` has proper async initialization
- Verify platform-specific configuration files exist

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}
```

#### 10. Offline Mode Not Working

**Problem**: App doesn't work offline

**Solutions**:
- Verify Firestore offline persistence is enabled in code
- Check connectivity provider is properly initialized
- Test with airplane mode enabled
- Clear app data and restart

---

## 🔒 Security Considerations

### For Development
- Test mode Firestore rules allow all read/write operations
- Suitable for development and testing only

### For Production
- Implement proper authentication (Firebase Auth)
- Configure strict Firestore security rules
- Validate all user inputs server-side
- Use environment variables for sensitive configuration
- Enable App Check for additional security

---

## 🚀 Future Enhancements

Potential features for future versions:
- User authentication and multi-user support
- Push notifications for upcoming assignments and sessions
- Calendar integration
- Grade tracking and GPA calculation
- Study timer and productivity analytics
- Dark mode support
- Export data to PDF/CSV
- Collaborative study groups
- Assignment reminders
- Course materials management

---

## 📄 License

This project is developed for the **ALU Mobile Development Module - January 2026**.

**Academic Use Only**: This project is submitted as part of academic coursework at African Leadership University.

---

## 🤝 Contributing

This is an academic project. For questions or suggestions:

1. Create an issue in the repository
2. Contact the development team
3. Submit a pull request with detailed description

---

## 📞 Support

For technical support or questions:

- **Email**: Contact your course instructor
- **Issues**: Create an issue in the repository
- **Documentation**: Refer to additional documentation files in the project

---

## 🙏 Acknowledgments

- **African Leadership University**: For providing the learning opportunity
- **Flutter Team**: For the excellent framework and documentation
- **Firebase Team**: For the robust backend infrastructure
- **Course Instructors**: For guidance and support

---

<div align="center">

**Built with ❤️ by Group 31**

*Empowering ALU students to excel academically*

</div>
