import 'package:go_router/go_router.dart';
import 'package:post/src/presentation/post_screen.dart';

class PostRoute {
  static GoRoute createRoute() {
    return GoRoute(path: '/posts', name: 'posts', builder: (context, state) => const PostsScreen());
  }
}
