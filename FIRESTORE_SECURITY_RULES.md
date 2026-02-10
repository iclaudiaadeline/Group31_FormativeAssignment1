# Firestore Security Rules

## Current Status
The app now has Firebase Authentication implemented, but Firestore security rules need to be updated to ensure users can only access their own data.

## Required Firestore Rules

Go to [Firebase Console](https://console.firebase.google.com/project/group31-formative-assignment1/firestore/rules) and update the rules to:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Users collection - users can only read/write their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Assignments collection - users can only access their own assignments
    match /assignments/{assignmentId} {
      allow read: if request.auth != null && resource.data.userId == request.auth.uid;
      allow create: if request.auth != null && request.resource.data.userId == request.auth.uid;
      allow update, delete: if request.auth != null && resource.data.userId == request.auth.uid;
    }
    
    // Sessions collection - users can only access their own sessions
    match /sessions/{sessionId} {
      allow read: if request.auth != null && resource.data.userId == request.auth.uid;
      allow create: if request.auth != null && request.resource.data.userId == request.auth.uid;
      allow update, delete: if request.auth != null && resource.data.userId == request.auth.uid;
    }
    
    // Attendance collection - users can only access their own attendance records
    match /attendance/{attendanceId} {
      allow read: if request.auth != null && resource.data.userId == request.auth.uid;
      allow create: if request.auth != null && request.resource.data.userId == request.auth.uid;
      allow update, delete: if request.auth != null && resource.data.userId == request.auth.uid;
    }
  }
}
```

## Temporary Development Rules (NOT for production)

If you want to test without authentication temporarily:

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

**WARNING**: The above rules allow anyone to read/write all data. Only use for development/testing!

## What These Rules Do

1. **Authentication Required**: All operations require a logged-in user (`request.auth != null`)
2. **User Isolation**: Each user can only access documents where `userId` matches their auth UID
3. **Create Protection**: When creating documents, the `userId` field must match the authenticated user
4. **Update/Delete Protection**: Users can only modify/delete their own documents

## Next Steps

After updating the rules, the app services need to be updated to:
1. Add `userId` field to all documents when creating
2. Filter queries by `userId` when reading
3. Ensure the current user's ID is used in all operations

This ensures complete data isolation between users.
