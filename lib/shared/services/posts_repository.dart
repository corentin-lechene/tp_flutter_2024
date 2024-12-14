
import 'package:al2_2024_bloc/shared/services/posts_data_source/posts_data_source.dart';

import '../models/post.dart';

class PostsRepository {
  final PostsDataSource dataSource;

  PostsRepository({required this.dataSource});

  Future<List<Post>> getAllPosts() async {
    try {
      return await dataSource.getAllPosts();
    } catch (error) {
      return [];
    }
  }
  Future<Post> createPost(Post postToAdd) async {
    try {
      return await dataSource.createPost(postToAdd);
    } catch (error) {
      return postToAdd;
    }
  }
  Future<Post> updatePost(Post newPost) async {
    try {
      return await dataSource.updatePost(newPost);
    } catch (error) {
      return newPost;
    }
  }

  Future<Post> getPostById(String postId) async {
    try {
      return await dataSource.getPostById(postId);
    } catch (error) {
      throw Error();
    }
  }
}