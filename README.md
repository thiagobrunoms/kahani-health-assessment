# Post Package - Architecture & Implementation

## State Management & Architecture

This package follows **Clean Architecture** with clear separation of concerns:
- **Domain Layer**: Repository interfaces defining contracts
- **Data Layer**: Firebase implementation with datasource and repository
- **Presentation Layer**: Cubit-based state management with UI widgets

**State Management**: Uses **Cubit** (from `flutter_bloc`) for lightweight, reactive state management. Cubit provides a simpler API than Bloc by eliminating the need for explicit events—methods directly emit new states.

## Bloc Approach & Requirements Satisfaction

The **Cubit pattern** satisfies requirements through:
- **Reactive streams**: Firestore `snapshots()` provides real-time updates
- **Separation of concerns**: `FeedListCubit` manages feed state, `ComposerCubit` handles post creation
- **Immutable state**: State objects use `copyWith` pattern for predictable updates
- **Error handling**: States include error fields with graceful UI fallbacks

## Offline Support & Optimistic Posting

**Offline Support**: Leverages Firestore's built-in persistence. Writes immediately cache locally and sync when connectivity is restored. The `snapshots()` stream includes both cached and server data automatically.

**Optimistic Posting**: Achieved through a dual-stream approach:
1. **Optimistic stream**: Posts are emitted immediately via `StreamController` before Firestore write
2. **Firestore stream**: Receives confirmed posts from the database
3. **Merge logic**: `FeedListCubit` merges both streams, prioritizing optimistic posts and preventing duplicates using a tracked ID set

## Performance Optimizations

**First Render**:
- Query limit (25 posts) reduces initial data load
- Subscription guard prevents duplicate stream subscriptions
- Firestore cache provides instant data availability

**List Rebuilding**:
- `ListView.builder` renders only visible items (lazy loading)
- Immutable state with efficient `copyWith` minimizes unnecessary rebuilds
- Smart merge algorithm avoids full list reconstruction when merging streams
- Freezed models ensure value equality for efficient comparisons

