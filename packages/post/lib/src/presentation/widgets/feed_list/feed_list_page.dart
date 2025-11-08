import 'package:common_dependencies/common_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post/src/domain/repository/posts_repository.dart';
import 'package:post/src/presentation/widgets/feed_list/feed_list_cubit.dart';
import 'package:post/src/presentation/extensions/date_time_extension.dart';

class FeedListPage extends StatelessWidget {
  const FeedListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FeedListCubit(getIt<PostsRepository>())..loadData(),
      child: BlocBuilder<FeedListCubit, FeedListState>(
        builder: (context, state) {
          if (state.isLoading && state.posts.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error != null && state.posts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.error!, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 16),
                  ElevatedButton(onPressed: () => context.read<FeedListCubit>().loadData(), child: const Text('Retry')),
                ],
              ),
            );
          }

          if (state.posts.isEmpty) {
            return const Center(child: Text('No posts available'));
          }

          return ListView.builder(
            itemCount: state.posts.length,
            itemBuilder: (context, index) {
              final post = state.posts[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(post.text),
                  subtitle: Text(post.createdAt.timeAgo, style: const TextStyle(fontSize: 12)),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
