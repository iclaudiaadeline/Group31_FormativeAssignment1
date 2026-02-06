# Group 31 - Formative Assignment 1

## Project Information

**Group Name:** Group 31  
**Assignment:** Formative Assignment 1  
**Course:** Mobile Application Development  
**Institution:** African Leadership University (ALU)  
**Project Name:** ALU Student Academic Platform  
**Submission Format:** Group31_FormativeAssignment1

## Team Members

| Developer | Role | Responsibilities |
|-----------|------|------------------|
| Developer 1 | Firebase & Assignments | Firebase setup, Assignment features, Assignment models & services |
| Developer 2 | Sessions & Attendance | Session scheduling, Attendance tracking, Session models & services |
| Developer 3 | Dashboard & UI/UX | Dashboard implementation, Theme configuration, UI polish |
| Developer 4 | Navigation & Integration | App navigation, Integration testing, Documentation |

## Project Overview

The ALU Student Academic Platform is a mobile application designed to help ALU students manage their academic responsibilities effectively. The app provides tools for:

- **Assignment Management**: Track assignments with due dates, priorities, and completion status
- **Session Scheduling**: Manage class schedules and academic sessions
- **Attendance Tracking**: Record and monitor attendance with automatic percentage calculation
- **Dashboard**: View summary of today's sessions, upcoming assignments, and attendance status

## Technical Architecture

### Technology Stack

- **Framework**: Flutter 3.38.5
- **Language**: Dart 3.10.4
- **Database**: Firebase Firestore (Cloud NoSQL)
- **State Management**: Provider pattern
- **Date Handling**: intl package

### Architecture Pattern

The application follows a clean architecture with clear separation of concerns:

```
Presentation Layer (UI)
    ↓
State Management Layer (Providers)
    ↓
Service Layer (Business Logic)
    ↓
Data Layer (Firebase Firestore)
```

### Folder Structure

```
lib/
├── config/          # Theme and app configuration
├── models/          # Data models (Assignment, Session, DashboardSummary)
├── providers/       # State management (ChangeNotifier providers)
├── screens/         # UI screens (Dashboard, Assignments, Schedule)
├── services/        # Business logic and Firebase operations
├── utils/           # Utility functions and helpers
├── widgets/         # Reusable UI components
├── firebase_options.dart  # Firebase configuration
└── main.dart        # App entry point
```

## Key Features Implementation

### 1. Dashboard (Requirement 1)
- Displays current date and academic week
- Shows today's scheduled sessions
- Lists assignments due in next 7 days
- Displays attendance percentage with warning if < 75%
- Shows count of pending assignments

### 2. Assignment Management (Requirement 2)
- Create assignments with title, course, due date, priority
- View all assignments sorted by due date
- Mark assignments as completed
- Edit and delete assignments
- Input validation for all fields

### 3. Session Scheduling (Requirement 3)
- Create sessions with title, date, time range, location, type
- View weekly schedule
- Session types: Class, Mastery Session, Study Group, PSL Meeting
- Edit and delete sessions
- Time range validation (end time > start time)

### 4. Attendance Tracking (Requirement 4)
- Record attendance as Present or Absent
- Automatic attendance percentage calculation
- Visual alert when attendance < 75%
- Attendance history view

### 5. Firebase Integration (Requirement 6 & 10)
- Real-time data synchronization
- Offline persistence enabled
- Automatic sync when connectivity restored
- Error handling for network issues

## Code Quality Standards

### Documentation
- All files include header comments with group and assignment info
- All classes have comprehensive doc comments
- All public methods have doc comments explaining purpose and parameters
- Complex logic includes inline comments

### Naming Conventions
- Classes: PascalCase (e.g., `AssignmentProvider`)
- Variables/Methods: camelCase (e.g., `createAssignment`)
- Constants: camelCase with const (e.g., `const primaryColor`)
- Private members: prefix with underscore (e.g., `_assignments`)

### Code Organization
- One class per file
- Related functionality grouped in folders
- Reusable widgets extracted to widgets folder
- Business logic separated from UI

## Testing Strategy

### Unit Tests
- Model serialization/deserialization
- Validation logic
- Service layer operations
- Provider state management

### Widget Tests
- Screen rendering
- User interactions
- Form validation
- Navigation flow

### Property-Based Tests
- Data persistence round-trips
- Calculation accuracy (attendance percentage)
- Sorting and filtering operations
- Validation edge cases

## Development Timeline

### Day 1 (Hours 0-24)
- Phase 1: Project setup and Firebase configuration
- Phase 2: Core models and validation
- Phase 3: Service layer implementation
- Phase 4: State management with providers
- Phase 5: Reusable widget components

### Day 2 (Hours 24-48)
- Phase 6: Main screens implementation
- Phase 7: Navigation and app structure
- Phase 8: Error handling and edge cases
- Phase 9: UI polish and responsive design
- Phase 10: Testing and quality assurance
- Phase 11: Documentation and deliverables

## Deliverables

1. **Source Code**: Complete Flutter project with all features implemented
2. **Documentation**: README, setup guides, code comments
3. **Demo Video**: Walkthrough of features and code explanation
4. **Write-up**: Challenges faced and solutions implemented
5. **Group Contribution Tracker**: Individual contributions documented

## Git Workflow

### Branches
- `main`: Production-ready code
- `dev`: Development integration branch
- `feature/assignments`: Assignment features
- `feature/sessions`: Session and attendance features
- `feature/dashboard`: Dashboard and UI
- `feature/navigation`: Navigation and integration

### Commit Messages
Format: `<type>: <description>`

Types:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation
- `style`: Code formatting
- `refactor`: Code restructuring
- `test`: Adding tests

Example: `feat: implement assignment creation form with validation`

## Challenges and Solutions

### Challenge 1: Firebase Configuration
**Problem**: Setting up Firebase for both Android and iOS  
**Solution**: Used FlutterFire CLI for automated configuration

### Challenge 2: Offline Data Persistence
**Problem**: App needs to work without internet  
**Solution**: Enabled Firestore offline persistence with unlimited cache

### Challenge 3: State Management
**Problem**: Keeping UI in sync with Firestore data  
**Solution**: Used Provider with real-time Firestore streams

### Challenge 4: Time Validation
**Problem**: Ensuring end time is after start time  
**Solution**: Implemented custom validator comparing TimeOfDay values

## Future Enhancements

- Push notifications for upcoming assignments
- Calendar integration
- Study group collaboration features
- Performance analytics and insights
- Dark mode support
- Multi-language support

## References

- [Flutter Documentation](https://docs.flutter.dev/)
- [Firebase Documentation](https://firebase.google.com/docs)
- [Provider Package](https://pub.dev/packages/provider)
- [Material Design Guidelines](https://m3.material.io/)

## Contact

For questions or issues, please contact the Group 31 development team.

---

**Last Updated**: February 5, 2026  
**Version**: 1.0.0  
**Status**: In Development
