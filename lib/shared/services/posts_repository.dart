import 'package:al2_2024_bloc/shared/app_exception.dart';
import 'package:al2_2024_bloc/shared/services/posts_data_source/posts_data_source.dart';

import '../models/post.dart';

class PostsRepository {
  final PostsDataSource dataSource;

  PostsRepository({required this.dataSource});

  Future<List<Post>> getAllPosts() async {
    try {
      return await dataSource.getAllPosts();
    } catch (error) {
      throw PostsFetchError();
    }
  }
  Future<Post> createPost(Post postToAdd) async {
    try {
      return await dataSource.createPost(postToAdd);
    } catch (error) {
      throw PostsCreateError();
    }
  }
  Future<Post> updatePost(Post newPost) async {
    try {
      return await dataSource.updatePost(newPost);
    } catch (error) {
      throw PostsUpdateError();
    }
  }

  Future<Post> getPostById(String postId) async {
    try {
      return await dataSource.getPostById(postId);
    } catch (error) {
      throw PostsNotFoundError();
    }
  }
}