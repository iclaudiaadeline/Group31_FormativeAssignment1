# Firebase Setup Guide

## Step 1: Create Firebase Project

1. Go to https://console.firebase.google.com/
2. Click "Add project" or "Create a project"
3. Enter project name: `alu-academic-platform`
4. Disable Google Analytics (optional for this project)
5. Click "Create project"

## Step 2: Configure FlutterFire

Once your Firebase project is created, run this command from the project root:

```bash
cd Group31_FormativeAssignment1
flutterfire configure
```

This will:
- Prompt you to select your Firebase project
- Automatically generate `firebase_options.dart`
- Configure Android and iOS apps
- Add necessary configuration files

## Step 3: Enable Firestore

1. In Firebase Console, go to "Firestore Database"
2. Click "Create database"
3. Choose "Start in test mode" (for development)
4. Select a location (choose closest to your region)
5. Click "Enable"

## Step 4: Update Firestore Rules (Optional - for production)

In Firestore Rules tab, you can update rules later:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if true; // For development only!
    }
  }
}
```

## Step 5: Test the Setup

Run the app to verify Firebase is working:

```bash
flutter run
```

If you see "ALU Academic Platform - Setup in Progress" without errors, Firebase is configured correctly!

## Troubleshooting

- If you get "No Firebase project found", make sure you're logged in: `firebase login`
- If FlutterFire configure fails, try: `dart pub global activate flutterfire_cli`
- Make sure you have the latest Flutter: `flutter upgrade`
