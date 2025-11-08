import 'package:flutter/material.dart';
import 'package:post/src/presentation/widgets/composer/post_composer.dart';
import 'package:post/src/presentation/widgets/feed_list/feed_list_page.dart';

class PostsScreen extends StatelessWidget {
  const PostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const PostComposer(),
            const Expanded(child: FeedListPage()),
          ],
        ),
      ),
    );
  }
}
