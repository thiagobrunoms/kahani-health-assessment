import 'package:common_dependencies/common_dependencies.dart';

part 'post.freezed.dart';

@freezed
abstract class Post with _$Post {
  const factory Post({required String uid, required String text, required DateTime createdAt}) = _Post;
}
