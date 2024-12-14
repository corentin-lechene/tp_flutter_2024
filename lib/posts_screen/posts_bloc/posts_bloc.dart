import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../shared/app_exception.dart';
import '../../shared/models/post.dart';
import '../../shared/services/posts_repository.dart';

part 'posts_event.dart';
part 'posts_state.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  final PostsRepository postsRepository;

  PostsBloc({ required this.postsRepository }) : super(const PostsState()) {
    on<GetAllPosts>((event, emit) async {
      try {
        print("loading");
        emit(state.copyWith(status: PostsStatus.loading));
        print("before");
        final posts = await postsRepository.getAllPosts();
        emit(state.copyWith(
          status: PostsStatus.success,
          posts: posts,
        ));
        print("after");
      } catch (error) {
        print("error");
        final appException = AppException.from(error);
        emit(state.copyWith(
          status: PostsStatus.error,
          exception: appException,
        ));
      }
    });

    on<CreatePost>((event, emit) async {
      try {
        emit(state.copyWith(status: PostsStatus.loading));
        Post newPost = Post(id: "2", title: event.title, description: "description");
        await postsRepository.createPost(newPost);

        final posts = await postsRepository.getAllPosts();
        emit(state.copyWith(
          status: PostsStatus.success,
          posts: posts,
        ));
        print("after");
      } catch (error) {
        print("error");
        final appException = AppException.from(error);
        emit(state.copyWith(
          status: PostsStatus.error,
          exception: appException,
        ));
      }
    });
  }
}
