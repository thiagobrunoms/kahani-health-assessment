import 'dart:async';
import 'package:injectable/injectable.dart';
import 'package:post/src/data/datasources/posts_datasource.dart';
import 'package:post/src/data/models/post.dart';
import 'package:post/src/domain/repository/posts_repository.dart';

@Injectable(as: PostsRepository)
class FirebasePostsRepository implements PostsRepository {
  final PostsDataSource _dataSource;
  final StreamController<Post> _optimisticPostsController = StreamController<Post>.broadcast();

  FirebasePostsRepository(this._dataSource);

  @override
  Stream<Post> get optimisticPosts => _optimisticPostsController.stream;

  void emitOptimisticPost(Post post) {
    _optimisticPostsController.add(post);
  }

  @override
  Future<bool> createPost(Post post) {
    //Emit event when new posts are added. So, we can start an optimistic solution (new Posts are displayed without waiting to receive events from remote firestore.)
    // Note: Optimistic posts are emitted by ComposerCubit before calling this method
    print('Creating post: $post');
    return _dataSource.createPost(post);
  }

  @override
  Stream<List<Post>> readPosts({int? limit}) {
    print('[Repository] readPosts called with limit: ${limit ?? "default"}');
    final stream = _dataSource.readPosts(limit: limit);
    
    // Wrap the stream to add logging and verify it's working
    return stream.map((posts) {
      print('[Repository] Stream event received: ${posts.length} posts');
      return posts;
    }).handleError((error, stackTrace) {
      print('[Repository] Stream error: $error');
      print('[Repository] Stack trace: $stackTrace');
      throw error;
    });
  }
}
