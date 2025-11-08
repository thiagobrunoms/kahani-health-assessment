import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post/src/data/models/post.dart';
import 'package:post/src/domain/repository/posts_repository.dart';

class FeedListState {
  final List<Post> posts;
  final bool isLoading;
  final String? error;

  const FeedListState({this.posts = const [], this.isLoading = false, this.error});

  FeedListState copyWith({List<Post>? posts, bool? isLoading, String? error}) {
    return FeedListState(posts: posts ?? this.posts, isLoading: isLoading ?? this.isLoading, error: error);
  }
}

class FeedListCubit extends Cubit<FeedListState> {
  final PostsRepository _postsRepository;
  StreamSubscription<List<Post>>? _postsSubscription;
  StreamSubscription<Post>? _optimisticPostsSubscription;
  final Set<String> _optimisticPostIds = {};

  FeedListCubit(this._postsRepository) : super(const FeedListState());

  void loadData() {
    // If already listening, don't recreate the subscription
    if (_postsSubscription != null) {
      print('[Cubit] loadData: Already subscribed, skipping');
      return;
    }

    print('[Cubit] loadData: Starting subscription to readPosts stream and optimistic posts stream');
    emit(state.copyWith(isLoading: true, error: null));

    // Listen to Firestore posts stream
    _postsSubscription = _postsRepository
        .readPosts(limit: 25)
        .listen(
          (posts) {
            print('[Cubit] Stream event received: ${posts.length} posts');
            // Merge with optimistic posts
            final mergedPosts = _mergePosts(posts);
            emit(state.copyWith(posts: mergedPosts, isLoading: false, error: null));
          },
          onError: (error, stackTrace) {
            print('[Cubit] Stream error: $error');
            print('[Cubit] Stack trace: $stackTrace');
            emit(state.copyWith(isLoading: false, error: 'Error loading posts: ${error.toString()}'));
          },
          onDone: () {
            print('[Cubit] Stream completed');
          },
          cancelOnError: false,
        );

    // Listen to optimistic posts stream
    // Hence, if the app is offline, we can still have POSTs..
    // OK - I don't remember how to turn iOS device off! =)

    _optimisticPostsSubscription = _postsRepository.optimisticPosts.listen(
      (post) {
        print('[Cubit] Optimistic post received: ${post.uid}');
        _optimisticPostIds.add(post.uid);
        // Add optimistic post to current list if not already present
        final currentPosts = List<Post>.from(state.posts);
        if (!currentPosts.any((p) => p.uid == post.uid)) {
          // Insert at the beginning (newest first)
          currentPosts.insert(0, post);
          emit(state.copyWith(posts: currentPosts));
        }
      },
      onError: (error, stackTrace) {
        print('[Cubit] Optimistic stream error: $error');
      },
    );

    print('[Cubit] Stream subscriptions created');
  }

  //THAT'S IT: WHEN NEW POSTS COME FROM FIRESTORE, WE HANDLE TO AVOID DUPLICATED POSTS
  List<Post> _mergePosts(List<Post> firestorePosts) {
    // Get current optimistic posts that aren't in Firestore yet
    final currentOptimisticPosts = state.posts
        .where((post) => _optimisticPostIds.contains(post.uid) && !firestorePosts.any((p) => p.uid == post.uid))
        .toList();

    // Remove optimistic post IDs that are now in Firestore (to avoid duplicates)
    final firestorePostIds = firestorePosts.map((p) => p.uid).toSet();
    _optimisticPostIds.removeWhere((id) => firestorePostIds.contains(id));

    // Merge: optimistic posts first (newest), then Firestore posts
    return [...currentOptimisticPosts, ...firestorePosts];
  }

  @override
  Future<void> close() {
    _postsSubscription?.cancel();
    _optimisticPostsSubscription?.cancel();
    return super.close();
  }
}
