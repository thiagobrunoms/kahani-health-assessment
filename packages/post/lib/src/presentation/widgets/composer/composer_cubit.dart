import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post/src/data/models/post.dart';
import 'package:post/src/domain/repository/posts_repository.dart';
import 'package:uuid/uuid.dart';

class ComposerState {
  final String text;
  final bool isLoading;
  final bool isLoaded;
  final String? error;

  const ComposerState({this.text = '', this.isLoading = false, this.isLoaded = false, this.error});

  ComposerState copyWith({String? text, bool? isLoading, bool? isLoaded, String? error}) {
    return ComposerState(
      text: text ?? this.text,
      isLoading: isLoading ?? this.isLoading,
      isLoaded: isLoaded ?? this.isLoaded,
      error: error,
    );
  }
}

class ComposerCubit extends Cubit<ComposerState> {
  final PostsRepository _postsRepository;
  final Uuid _uuid;

  ComposerCubit(this._postsRepository, {Uuid? uuid}) : _uuid = uuid ?? const Uuid(), super(const ComposerState());

  void updateText(String text) {
    emit(state.copyWith(text: text));
  }

  Future<void> createPost() async {
    if (state.text.trim().isEmpty) {
      emit(state.copyWith(error: 'Post text cannot be empty', isLoading: false));
      return;
    }

    emit(state.copyWith(isLoading: true, isLoaded: false, error: null));

    try {
      final postId = _uuid.v4();

      //I'm not considering from which user this post is from.
      final post = Post(uid: postId, text: state.text.trim(), createdAt: DateTime.now());

      // Emit optimistic post immediately
      _postsRepository.emitOptimisticPost(post);

      final success = await _postsRepository.createPost(post);

      if (success) {
        emit(state.copyWith(text: '', isLoading: false, isLoaded: true, error: null));
      } else {
        emit(state.copyWith(isLoading: false, isLoaded: false, error: 'Failed to create post'));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, isLoaded: false, error: 'Error creating post: ${e.toString()}'));
    }
  }
}
