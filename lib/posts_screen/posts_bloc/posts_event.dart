part of 'posts_bloc.dart';

@immutable
sealed class PostsEvent {}

class GetAllPosts extends PostsEvent {}

class CreatePost extends PostsEvent {
  final String title;
  final String description;

  CreatePost({
    required this.title,
    required this.description,
  });
}

class UpdatePost extends PostsEvent {
  final Post post;

  UpdatePost({required this.post});
}
