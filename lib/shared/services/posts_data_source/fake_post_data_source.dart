

import 'package:al2_2024_bloc/shared/services/posts_data_source/posts_data_source.dart';

import '../../models/post.dart';

class FakePostsDataSource extends PostsDataSource {
  final List<Post> _fakePosts = [
    Post(id: '1', title: 'Post 1', description: 'Description of Post 1'),
    Post(id: '2', title: 'Post 2', description: 'Description of Post 2'),
    Post(id: '3', title: 'Post 3', description: 'Description of Post 3'),
  ];

  @override
  Future<Post> createPost(Post createdPost) async {
    await Future.delayed(const Duration(seconds: 1));
    _fakePosts.add(createdPost.copyWith(id: (_fakePosts.length + 1).toString()));
    return createdPost;
  }

  @override
  Future<List<Post>> getAllPosts() async {
    await Future.delayed(const Duration(seconds: 1));
    return _fakePosts;
  }

  @override
  Future<Post> updatePost(Post updatedPost) async {
    await Future.delayed(const Duration(seconds: 1));
    final index = _fakePosts.indexWhere((post) => post.id == updatedPost.id);
    if (index != -1) {
      _fakePosts[index] = updatedPost;
    }
    return updatedPost;
  }

  @override
  Future<Post> getPostById(String postId) async {
    await Future.delayed(const Duration(seconds: 1));
    final index = _fakePosts.indexWhere((post) => post.id == postId);
    return _fakePosts.elementAt(index);
  }


}
