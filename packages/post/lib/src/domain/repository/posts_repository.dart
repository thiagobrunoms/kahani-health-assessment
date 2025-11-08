import 'package:post/src/data/models/post.dart';

//This layer may looks not needed. I'm adding it to show that the clean architecture "would require" this layer to "hide" datasources
//I won't use in tnis assessment, but I'll keep it here just to show that I know the Repository architectural design.
//In this domain layer, it only exposes the contract. The data layer can provide the implementation details.
abstract class PostsRepository {
  Future<bool> createPost(Post post); //no need to return it, since readPosts fetches async.

  Stream<List<Post>> readPosts({int? limit}); //Maybe we need pagination and references to avoid streaming all

  Stream<Post> get optimisticPosts; // Stream for optimistic post updates

  void emitOptimisticPost(Post post); // Method to emit optimistic posts
}
