import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../shared/app_exception.dart';
import '../../shared/models/post.dart';
import '../../shared/services/posts_repository.dart';

part 'posts_event.dart';

part 'posts_state.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  final PostsRepository postsRepository;

  PostsBloc({required this.postsRepository}) : super(const PostsState()) {
    on<GetAllPosts>(_onFetchPosts);
    on<CreatePost>(_onCreatePost);
    on<UpdatePost>(_onUpdatePost);
  }

  Future<void> _onFetchPosts(GetAllPosts event, Emitter<PostsState> emit) async {
    try {
      emit(state.copyWith(status: PostsStatus.loading));
      final posts = await postsRepository.getAllPosts();
      emit(state.copyWith(
        status: PostsStatus.success,
        posts: posts,
      ));
    } catch (error) {
      final appException = AppException.from(error);
      emit(state.copyWith(
        status: PostsStatus.error,
        exception: appException,
      ));
    }
  }

  Future<void> _onCreatePost(CreatePost event, Emitter<PostsState> emit) async {
    try {
      emit(state.copyWith(status: PostsStatus.loading));
      Post newPost = Post.create(
        title: event.title,
        description: event.description,
      );
      await postsRepository.createPost(newPost);

      emit(state.copyWith(
        status: PostsStatus.success,
      ));
    } catch (error) {
      final appException = AppException.from(error);
      emit(state.copyWith(
        status: PostsStatus.error,
        exception: appException,
      ));
    }
  }

  Future<void> _onUpdatePost(UpdatePost event, Emitter<PostsState> emit) async {
    try {
      emit(state.copyWith(status: PostsStatus.loading));
      await postsRepository.updatePost(event.post);

      emit(state.copyWith(
        status: PostsStatus.success,
      ));
    } catch (error) {
      final appException = AppException.from(error);
      emit(state.copyWith(
        status: PostsStatus.error,
        exception: appException,
      ));
    }
  }
}
