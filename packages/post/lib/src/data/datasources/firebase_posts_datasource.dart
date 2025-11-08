import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/firebase.dart';
import 'package:injectable/injectable.dart';
import 'package:post/src/data/datasources/posts_datasource.dart';
import 'package:post/src/data/models/post.dart';

@Injectable(as: PostsDataSource)
class FirebasePostsDataSource implements PostsDataSource {
  final FirebaseFirestore _firestore;

  static const String _collectionPath = '/posts';

  FirebasePostsDataSource({FirebaseFirestore? firestore}) : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<bool> createPost(Post post) async {
    try {
      // Convert Post model to Firestore document
      final postData = {
        'uid': post.uid, // User ID from Firebase Auth
        'text': post.text,
        'createdAt': Timestamp.fromDate(post.createdAt),
      };

      // Write to Firestore - this immediately writes to the local cache
      // Firestore persistence is enabled by default on mobile, so the document
      // is immediately available in the cache and will appear in the stream
      // right away, even if offline. The write will sync to the server when
      // connection is restored.
      await _firestore.collection(_collectionPath).doc(post.uid).set(postData);

      return true;
    } catch (e) {
      // Log error if needed
      return false;
    }
  }

  @override
  Stream<List<Post>> readPosts({int? limit}) async* {
    print('[DataSource] readPosts: Starting stream subscription');
    print('[DataSource] Collection path: $_collectionPath, Limit: ${limit ?? 10}');

    // Firestore's snapshots() stream automatically includes local cache data
    // by default. When a document is written (even offline), it immediately
    // appears in the stream from the cache. This provides the offline-first
    // behavior we need - the UI will update immediately when a post is created,
    // without waiting for the server.
    //
    // The stream includes both:
    // 1. Cached data (immediate, works offline)
    // 2. Server data (when available, syncs automatically)
    //
    // This means we don't need a separate cache mechanism - Firestore handles
    // it internally and the stream gives us both cached and server data.
    try {
      await for (final snapshot
          in _firestore
              .collection(_collectionPath)
              .orderBy('createdAt', descending: true)
              .limit(limit ?? 300) //10 is also randon, but "looks enough"
              .snapshots()) {
        print('[DataSource] Snapshot received: ${snapshot.docs.length} documents');

        final posts = <Post>[];
        for (final doc in snapshot.docs) {
          try {
            final data = doc.data();

            // Validate required fields are present and not null
            final uid = data['uid'];
            final text = data['text'];
            final createdAt = data['createdAt'];

            if (uid == null || text == null || createdAt == null) {
              print(
                '[DataSource] Skipping document ${doc.id}: missing required fields (uid: $uid, text: $text, createdAt: $createdAt)',
              );
              continue;
            }

            // Validate types
            if (uid is! String || text is! String || createdAt is! Timestamp) {
              print(
                '[DataSource] Skipping document ${doc.id}: invalid field types (uid: ${uid.runtimeType}, text: ${text.runtimeType}, createdAt: ${createdAt.runtimeType})',
              );
              continue;
            }

            final post = Post(uid: uid, text: text, createdAt: createdAt.toDate());
            print('[DataSource] POST: ${post.uid}');
            posts.add(post);
          } catch (e, stackTrace) {
            print('[DataSource] Error parsing document ${doc.id}: $e');
            print('[DataSource] Stack trace: $stackTrace');
            // Continue processing other documents instead of failing the entire stream
            continue;
          }
        }

        print('[DataSource] Yielding ${posts.length} posts (${snapshot.docs.length - posts.length} documents skipped)');
        yield posts;
      }
    } catch (e, stackTrace) {
      print('[DataSource] Stream error: $e');
      print('[DataSource] Stack trace: $stackTrace');
      rethrow;
    }
  }
}
