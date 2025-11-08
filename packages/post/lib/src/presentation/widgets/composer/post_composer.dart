import 'package:common_dependencies/common_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post/src/domain/repository/posts_repository.dart';
import 'package:post/src/presentation/widgets/composer/composer_cubit.dart';

class PostComposer extends StatelessWidget {
  const PostComposer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ComposerCubit(getIt<PostsRepository>()),
      child: BlocBuilder<ComposerCubit, ComposerState>(
        builder: (context, state) {
          return Row(
            children: [
              Expanded(
                child: TextField(
                  controller: TextEditingController(text: state.text)
                    ..selection = TextSelection.collapsed(offset: state.text.length),
                  onChanged: (text) => context.read<ComposerCubit>().updateText(text),
                  maxLength: 140,
                  enabled: !state.isLoading,
                  decoration: const InputDecoration(
                    hintText: 'Write your post...',
                    border: OutlineInputBorder(),
                    counterText: '',
                  ),
                ),
              ),
              const SizedBox(width: 8),
              if (state.isLoading)
                const SizedBox(
                  width: 48,
                  height: 48,
                  child: Padding(padding: EdgeInsets.all(12), child: CircularProgressIndicator(strokeWidth: 2)),
                )
              else
                ElevatedButton(
                  onPressed: state.text.trim().isEmpty ? null : () => context.read<ComposerCubit>().createPost(),
                  child: const Text('Post'),
                ),
            ],
          );
        },
      ),
    );
  }
}
