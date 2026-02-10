# ALU Academic Platform - Architecture Documentation

## Table of Contents
1. [Overview](#overview)
2. [Architecture Diagram](#architecture-diagram)
3. [Folder Structure](#folder-structure)
4. [Layer Responsibilities](#layer-responsibilities)
5. [State Management Approach](#state-management-approach)
6. [Data Flow](#data-flow)
7. [Key Design Patterns](#key-design-patterns)
8. [Firebase Integration](#firebase-integration)
9. [Component Relationships](#component-relationships)

---

## Overview

The ALU Student Academic Platform is a Flutter mobile application built using a **clean architecture pattern** with clear separation of concerns. The application follows a **layered architecture** approach that separates presentation, business logic, and data access into distinct layers.

### Architectural Principles

1. **Separation of Concerns**: Each layer has a single, well-defined responsibility
2. **Dependency Inversion**: Higher layers depend on abstractions, not concrete implementations
3. **Unidirectional Data Flow**: Data flows from services → providers → UI
4. **Reactive Programming**: UI automatically updates when state changes
5. **Firebase-First**: All data operations go through Firestore with offline persistence

### Technology Stack

- **Framework**: Flutter 3.x
- **Language**: Dart
- **State Management**: Provider package
- **Backend**: Firebase Firestore (NoSQL cloud database)
- **Offline Support**: Firestore offline persistence
- **UI Design**: Material Design 3

---

## Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                      PRESENTATION LAYER                          │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐          │
│  │  Dashboard   │  │ Assignments  │  │   Schedule   │          │
│  │   Screen     │  │   Screen     │  │   Screen     │          │
│  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘          │
│         │                  │                  │                  │
│  ┌──────┴──────────────────┴──────────────────┴───────┐         │
│  │              Reusable Widgets                       │         │
│  │  (Cards, Badges, Forms, Dialogs, Inputs)           │         │
│  └─────────────────────────────────────────────────────┘         │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                   STATE MANAGEMENT LAYER                         │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐          │
│  │  Dashboard   │  │  Assignment  │  │   Session    │          │
│  │   Provider   │  │   Provider   │  │   Provider   │          │
│  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘          │
│         │                  │                  │                  │
│  ┌──────┴──────────────────┴──────────────────┴───────┐         │
│  │         Connectivity Provider (Network)             │         │
│  └─────────────────────────────────────────────────────┘         │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                       SERVICE LAYER                              │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐          │
│  │  Assignment  │  │   Session    │  │  Attendance  │          │
│  │   Service    │  │   Service    │  │   Service    │          │
│  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘          │
│         │                  │                  │                  │
│         └──────────────────┴──────────────────┘                 │
│                            │                                     │
└────────────────────────────┼─────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                        DATA LAYER                                │
│  ┌─────────────────────────────────────────────────────┐        │
│  │           Firebase Firestore (Cloud)                │        │
│  │  ┌──────────────┐  ┌──────────────┐                │        │
│  │  │ assignments  │  │   sessions   │                │        │
│  │  │  collection  │  │  collection  │                │        │
│  │  └──────────────┘  └──────────────┘                │        │
│  └─────────────────────────────────────────────────────┘        │
│  ┌─────────────────────────────────────────────────────┐        │
│  │         Local Cache (Offline Persistence)           │        │
│  └─────────────────────────────────────────────────────┘        │
└─────────────────────────────────────────────────────────────────┘
```

---

## Folder Structure

```
Group31_FormativeAssignment1/
├── lib/
│   ├── config/                    # Configuration files
│   │   ├── animations.dart        # Animation configurations
│   │   ├── colors.dart            # Color constants (ALU palette)
│   │   ├── spacing.dart           # Spacing and sizing constants
│   │   └── theme.dart             # Material theme configuration
│   │
│   ├── models/                    # Data models and validators
│   │   ├── assignment.dart        # Assignment model
│   │   ├── assignment_validator.dart
│   │   ├── session.dart           # Session model
│   │   ├── session_validator.dart
│   │   └── dashboard_summary.dart # Dashboard data model
│   │
│   ├── services/                  # Business logic and data access
│   │   ├── assignment_service.dart # Assignment CRUD operations
│   │   ├── session_service.dart    # Session CRUD operations
│   │   └── attendance_service.dart # Attendance calculations
│   │
│   ├── providers/                 # State management
│   │   ├── assignment_provider.dart
│   │   ├── session_provider.dart
│   │   ├── dashboard_provider.dart
│   │   └── connectivity_provider.dart
│   │
│   ├── screens/                   # Full-screen views
│   │   ├── dashboard_screen.dart
│   │   ├── assignments_screen.dart
│   │   ├── schedule_screen.dart
│   │   ├── assignment_form_dialog.dart
│   │   ├── session_form_dialog.dart
│   │   └── attendance_dialog.dart
│   │
│   ├── widgets/                   # Reusable UI components
│   │   ├── cards/                 # Card components
│   │   │   ├── assignment_card.dart
│   │   │   ├── stat_card.dart
│   │   │   ├── announcement_card.dart
│   │   │   ├── course_item.dart
│   │   │   └── risk_percent_card.dart
│   │   ├── banners/               # Banner components
│   │   │   └── risk_warning_banner.dart
│   │   ├── buttons/               # Button components
│   │   │   └── primary_button.dart
│   │   ├── inputs/                # Input components
│   │   │   └── custom_input_field.dart
│   │   ├── session_card.dart
│   │   ├── priority_badge.dart
│   │   ├── session_type_badge.dart
│   │   ├── attendance_status_widget.dart
│   │   ├── date_picker_field.dart
│   │   ├── time_picker_field.dart
│   │   └── sync_status_indicator.dart
│   │
│   ├── utils/                     # Utility functions
│   │   ├── error_handler.dart     # Error handling utilities
│   │   ├── debouncer.dart         # Debouncing utility
│   │   └── text_utils.dart        # Text formatting utilities
│   │
│   ├── firebase_options.dart      # Firebase configuration
│   └── main.dart                  # Application entry point
│
├── test/                          # Test files
│   ├── widget_test.dart
│   ├── edge_cases_test.dart
│   ├── offline_support_test.dart
│   └── utils_test.dart
│
├── android/                       # Android platform files
├── ios/                           # iOS platform files
├── web/                           # Web platform files (not used)
├── pubspec.yaml                   # Dependencies
└── README.md                      # Project documentation
```

### Folder Organization Principles

1. **config/**: Contains all configuration constants (colors, theme, spacing, animations)
2. **models/**: Pure data classes with validation logic, no business logic
3. **services/**: Business logic and Firestore operations, no UI dependencies
4. **providers/**: State management, bridges services and UI
5. **screens/**: Full-screen views that compose widgets
6. **widgets/**: Reusable UI components organized by type
7. **utils/**: Helper functions and utilities

---

## Layer Responsibilities

### 1. Presentation Layer (UI)

**Location**: `lib/screens/` and `lib/widgets/`

**Responsibilities**:
- Render UI components using Flutter widgets
- Handle user input (taps, gestures, form input)
- Display data from providers
- Navigate between screens
- Show loading states and error messages

**Rules**:
- ❌ NO direct Firestore access
- ❌ NO business logic
- ❌ NO data transformation
- ✅ Only consume data from providers
- ✅ Trigger provider methods on user actions
- ✅ Display data and handle UI state

**Example**:
```dart
// AssignmentsScreen displays data from AssignmentProvider
class AssignmentsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AssignmentProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return CircularProgressIndicator();
        }
        return ListView.builder(
          itemCount: provider.assignments.length,
          itemBuilder: (context, index) {
            return AssignmentCard(
              assignment: provider.assignments[index],
              onToggle: () => provider.toggleCompletion(
                provider.assignments[index].id
              ),
            );
          },
        );
      },
    );
  }
}
```

### 2. State Management Layer (Providers)

**Location**: `lib/providers/`

**Responsibilities**:
- Manage application state
- Coordinate between UI and services
- Handle loading and error states
- Notify UI of state changes
- Cache data in memory
- Provide computed properties

**Rules**:
- ✅ Extend `ChangeNotifier`
- ✅ Call `notifyListeners()` after state changes
- ✅ Depend on services, not Firestore directly
- ✅ Handle errors and loading states
- ❌ NO UI code or widgets
- ❌ NO direct Firestore operations

**Example**:
```dart
class AssignmentProvider extends ChangeNotifier {
  final AssignmentService _service;
  List<Assignment> _assignments = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Assignment> get assignments => _assignments;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Initialize and listen to Firestore stream
  void initialize() {
    _service.getAssignmentsStream().listen((assignments) {
      _assignments = assignments;
      notifyListeners();
    });
  }

  // CRUD operations
  Future<void> createAssignment(Assignment assignment) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      await _service.createAssignment(assignment);
      _error = null;
    } catch (e) {
      _error = ErrorHandler.getErrorMessage(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
```

### 3. Service Layer (Business Logic)

**Location**: `lib/services/`

**Responsibilities**:
- Encapsulate all Firestore operations
- Provide clean API for CRUD operations
- Transform data between Firestore and models
- Handle data validation
- Manage queries and filters
- Implement business rules

**Rules**:
- ✅ Direct Firestore access
- ✅ Return Streams for real-time data
- ✅ Return Futures for one-time operations
- ✅ Transform Firestore documents to models
- ❌ NO UI dependencies
- ❌ NO state management (no ChangeNotifier)

**Example**:
```dart
class AssignmentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'assignments';

  // Create
  Future<String> createAssignment(Assignment assignment) async {
    final docRef = await _firestore
        .collection(_collection)
        .add(assignment.toFirestore());
    return docRef.id;
  }

  // Read (real-time stream)
  Stream<List<Assignment>> getAssignmentsStream() {
    return _firestore
        .collection(_collection)
        .orderBy('dueDate', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Assignment.fromFirestore(doc))
            .toList());
  }

  // Update
  Future<void> updateAssignment(Assignment assignment) async {
    await _firestore
        .collection(_collection)
        .doc(assignment.id)
        .update(assignment.toFirestore());
  }

  // Delete
  Future<void> deleteAssignment(String id) async {
    await _firestore.collection(_collection).doc(id).delete();
  }
}
```

### 4. Data Layer (Models)

**Location**: `lib/models/`

**Responsibilities**:
- Define data structures
- Validate data
- Transform between Firestore and Dart objects
- Provide immutable data classes
- Implement equality and hashing

**Rules**:
- ✅ Pure data classes
- ✅ Validation methods
- ✅ Firestore serialization/deserialization
- ✅ Immutable with `copyWith` methods
- ❌ NO business logic
- ❌ NO Firestore operations
- ❌ NO UI dependencies

**Example**:
```dart
class Assignment {
  final String id;
  final String title;
  final String course;
  final DateTime dueDate;
  final PriorityLevel priority;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  Assignment({
    required this.id,
    required this.title,
    required this.course,
    required this.dueDate,
    required this.priority,
    this.isCompleted = false,
    required this.createdAt,
    required this.updatedAt,
  });

  // Firestore serialization
  factory Assignment.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Assignment(
      id: doc.id,
      title: data['title'] ?? '',
      course: data['course'] ?? '',
      dueDate: (data['dueDate'] as Timestamp).toDate(),
      priority: PriorityLevel.values.byName(data['priority']),
      isCompleted: data['isCompleted'] ?? false,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'course': course,
      'dueDate': Timestamp.fromDate(dueDate),
      'priority': priority.name,
      'isCompleted': isCompleted,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  // Immutable updates
  Assignment copyWith({
    String? title,
    String? course,
    DateTime? dueDate,
    PriorityLevel? priority,
    bool? isCompleted,
  }) {
    return Assignment(
      id: id,
      title: title ?? this.title,
      course: course ?? this.course,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}
```

---

## State Management Approach

### Provider Pattern

The application uses the **Provider** package for state management, which implements the **Observer pattern** and provides dependency injection.

### Why Provider?

1. **Simple**: Easy to understand and implement
2. **Performant**: Only rebuilds widgets that depend on changed data
3. **Testable**: Easy to mock providers in tests
4. **Scalable**: Suitable for medium-sized applications
5. **Flutter-native**: Recommended by Flutter team

### Provider Setup

**In `main.dart`**:
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AssignmentProvider(AssignmentService())..initialize(),
        ),
        ChangeNotifierProvider(
          create: (_) => SessionProvider(SessionService())..initialize(),
        ),
        ChangeNotifierProvider(
          create: (_) => DashboardProvider(
            AssignmentService(),
            SessionService(),
            AttendanceService(),
          )..loadDashboard(),
        ),
        ChangeNotifierProvider(
          create: (_) => ConnectivityProvider()..initialize(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}
```

### Consuming State in UI

**Method 1: Consumer Widget** (Recommended for partial rebuilds)
```dart
Consumer<AssignmentProvider>(
  builder: (context, provider, child) {
    return Text('${provider.assignments.length} assignments');
  },
)
```

**Method 2: Provider.of** (For accessing without rebuilding)
```dart
final provider = Provider.of<AssignmentProvider>(context, listen: false);
provider.createAssignment(assignment);
```

**Method 3: context.watch** (For simple cases)
```dart
final assignments = context.watch<AssignmentProvider>().assignments;
```

### State Flow

```
User Action (UI)
    ↓
Provider Method Called
    ↓
Service Method Called
    ↓
Firestore Operation
    ↓
Firestore Stream Updates
    ↓
Provider Receives Update
    ↓
notifyListeners() Called
    ↓
UI Rebuilds Automatically
```

### State Management Best Practices

1. **Initialize providers early**: Call `initialize()` in provider creation
2. **Use streams for real-time data**: Firestore streams automatically update UI
3. **Handle loading states**: Show loading indicators during async operations
4. **Handle errors gracefully**: Display user-friendly error messages
5. **Avoid unnecessary rebuilds**: Use `Consumer` for specific widgets only
6. **Keep providers focused**: Each provider manages one domain (assignments, sessions, etc.)

---

## Data Flow

### Read Flow (Firestore → UI)

```
┌─────────────────┐
│   Firestore     │
│   Collection    │
└────────┬────────┘
         │ Real-time Stream
         ▼
┌─────────────────┐
│    Service      │
│  .getStream()   │
└────────┬────────┘
         │ Stream<List<Model>>
         ▼
┌─────────────────┐
│    Provider     │
│  .initialize()  │
│  listen(stream) │
└────────┬────────┘
         │ notifyListeners()
         ▼
┌─────────────────┐
│   UI Widget     │
│   Consumer      │
│   Rebuilds      │
└─────────────────┘
```

### Write Flow (UI → Firestore)

```
┌─────────────────┐
│   UI Widget     │
│  User Action    │
└────────┬────────┘
         │ Call provider method
         ▼
┌─────────────────┐
│    Provider     │
│  Set loading    │
│  notifyListeners│
└────────┬────────┘
         │ Call service method
         ▼
┌─────────────────┐
│    Service      │
│  Firestore op   │
└────────┬────────┘
         │ Write to Firestore
         ▼
┌─────────────────┐
│   Firestore     │
│   Document      │
└────────┬────────┘
         │ Stream emits update
         ▼
┌─────────────────┐
│    Provider     │
│  Receives update│
│  notifyListeners│
└────────┬────────┘
         │ Automatic rebuild
         ▼
┌─────────────────┐
│   UI Widget     │
│  Shows new data │
└─────────────────┘
```

### Example: Creating an Assignment

1. **User fills form** in `AssignmentFormDialog`
2. **User taps Save** button
3. **Dialog calls** `provider.createAssignment(assignment)`
4. **Provider sets** `_isLoading = true` and calls `notifyListeners()`
5. **UI shows** loading indicator
6. **Provider calls** `_service.createAssignment(assignment)`
7. **Service writes** to Firestore collection
8. **Firestore stream** emits updated list
9. **Provider receives** new list via stream listener
10. **Provider updates** `_assignments` and calls `notifyListeners()`
11. **UI automatically** rebuilds with new assignment

---

## Key Design Patterns

### 1. Repository Pattern (Service Layer)

Services act as repositories that abstract Firestore operations:
- Single source of truth for data access
- Consistent API across the application
- Easy to mock for testing

### 2. Observer Pattern (Provider)

Providers implement the Observer pattern:
- UI observes provider state
- Provider notifies observers on state changes
- Automatic UI updates

### 3. Factory Pattern (Model Creation)

Models use factory constructors for Firestore deserialization:
```dart
factory Assignment.fromFirestore(DocumentSnapshot doc) {
  // Transform Firestore data to Dart object
}
```

### 4. Builder Pattern (UI Construction)

Widgets use builder pattern for dynamic content:
```dart
Consumer<AssignmentProvider>(
  builder: (context, provider, child) {
    // Build UI based on provider state
  },
)
```

### 5. Dependency Injection (Provider)

Providers inject services as dependencies:
```dart
class AssignmentProvider extends ChangeNotifier {
  final AssignmentService _service;
  
  AssignmentProvider(this._service);
}
```

### 6. Singleton Pattern (Services)

Firestore instance is a singleton:
```dart
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
```

---

## Firebase Integration

### Firestore Database Structure

```
firestore (root)
├── assignments (collection)
│   └── {assignmentId} (document)
│       ├── id: string
│       ├── title: string
│       ├── course: string
│       ├── dueDate: timestamp
│       ├── priority: string ("high" | "medium" | "low")
│       ├── isCompleted: boolean
│       ├── createdAt: timestamp
│       └── updatedAt: timestamp
│
└── sessions (collection)
    └── {sessionId} (document)
        ├── id: string
        ├── title: string
        ├── date: timestamp
        ├── startTime: string (HH:mm)
        ├── endTime: string (HH:mm)
        ├── location: string
        ├── type: string ("class" | "mastery" | "study_group" | "psl")
        ├── attendanceStatus: string? ("present" | "absent" | null)
        ├── createdAt: timestamp
        └── updatedAt: timestamp
```

### Offline Persistence

**Configuration** (in `main.dart`):
```dart
FirebaseFirestore.instance.settings = const Settings(
  persistenceEnabled: true,
  cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
);
```

**How it works**:
1. All Firestore data is cached locally
2. Reads are served from cache when offline
3. Writes are queued when offline
4. Automatic sync when connectivity restored
5. UI shows sync status via `ConnectivityProvider`

### Real-time Synchronization

All data access uses Firestore streams:
```dart
Stream<List<Assignment>> getAssignmentsStream() {
  return _firestore
      .collection('assignments')
      .orderBy('dueDate')
      .snapshots()  // Real-time stream
      .map((snapshot) => snapshot.docs
          .map((doc) => Assignment.fromFirestore(doc))
          .toList());
}
```

**Benefits**:
- Automatic UI updates when data changes
- Multi-device synchronization
- Collaborative features possible
- No manual refresh needed

---

## Component Relationships

### Assignment Feature

```
AssignmentsScreen
    ↓ consumes
AssignmentProvider
    ↓ uses
AssignmentService
    ↓ accesses
Firestore 'assignments' collection
```

**Supporting Components**:
- `AssignmentCard` widget (displays assignment)
- `AssignmentFormDialog` (create/edit form)
- `PriorityBadge` widget (shows priority)
- `AssignmentValidator` (validates input)

### Session Feature

```
ScheduleScreen
    ↓ consumes
SessionProvider
    ↓ uses
SessionService
    ↓ accesses
Firestore 'sessions' collection
```

**Supporting Components**:
- `SessionCard` widget (displays session)
- `SessionFormDialog` (create/edit form)
- `AttendanceDialog` (record attendance)
- `SessionTypeBadge` widget (shows type)
- `SessionValidator` (validates input)

### Dashboard Feature

```
DashboardScreen
    ↓ consumes
DashboardProvider
    ↓ uses
AssignmentService + SessionService + AttendanceService
    ↓ accesses
Firestore collections
```

**Supporting Components**:
- `StatCard` widget (displays statistics)
- `AttendanceStatusWidget` (shows attendance %)
- `RiskWarningBanner` (low attendance alert)
- `AnnouncementCard` (upcoming items)

### Navigation Structure

```
main.dart
    ↓ creates
MultiProvider (wraps all providers)
    ↓ provides to
MyApp (MaterialApp)
    ↓ home
MainNavigationScreen (Bottom Navigation)
    ├─ Tab 0: DashboardScreen
    ├─ Tab 1: AssignmentsScreen
    └─ Tab 2: ScheduleScreen
```

### Cross-Cutting Concerns

**Connectivity Monitoring**:
```
ConnectivityProvider
    ↓ monitors
Network Status
    ↓ displays
SyncStatusIndicator (in AppBar)
```

**Error Handling**:
```
Any Service/Provider
    ↓ catches errors
ErrorHandler utility
    ↓ transforms to
User-friendly message
    ↓ displays in
SnackBar or Dialog
```

**Theme & Styling**:
```
config/theme.dart
    ↓ defines
ALU Color Palette + Material Theme
    ↓ applied in
MyApp (MaterialApp theme)
    ↓ used by
All UI components
```

---

## Summary

The ALU Academic Platform follows a **clean, layered architecture** that:

1. **Separates concerns** into distinct layers (UI, State, Service, Data)
2. **Uses Provider** for reactive state management
3. **Integrates Firebase** for cloud storage and real-time sync
4. **Supports offline** operation with automatic synchronization
5. **Follows best practices** for Flutter development
6. **Enables parallel development** with clear boundaries
7. **Facilitates testing** with dependency injection
8. **Maintains scalability** for future enhancements

This architecture ensures the application is **maintainable**, **testable**, and **scalable** while meeting all functional requirements for ALU students to manage their academic responsibilities effectively.

---

## Additional Resources

- **Requirements**: See `.kiro/specs/alu-academic-platform/requirements.md`
- **Design Document**: See `.kiro/specs/alu-academic-platform/design.md`
- **Setup Guide**: See `README.md`
- **Offline Support**: See `OFFLINE_SUPPORT_DOCUMENTATION.md`
- **Testing Guide**: See `OFFLINE_TESTING_GUIDE.md`
