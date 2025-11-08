import 'package:post/src/data/models/post.dart';

abstract class PostsDataSource {
  Future<bool> createPost(Post post); //no need to return it, since readPosts fetches async.

  Stream<List<Post>> readPosts({int? limit}); //Maybe we need pagination and references to avoid streaming all
}
