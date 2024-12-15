import 'package:al2_2024_bloc/posts_screen/create_post_screen/create_post_screen.dart';
import 'package:al2_2024_bloc/posts_screen/post_detail_screen/post_detail_screen.dart';
import 'package:al2_2024_bloc/posts_screen/posts_bloc/posts_bloc.dart';
import 'package:al2_2024_bloc/shared/widgets/posts/post_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../shared/app_exception.dart';
import '../shared/models/post.dart';

class PostsScreen extends StatefulWidget {
  static void navigateTo(BuildContext context) {
    Navigator.pushNamed(context, '/');
  }

  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();

}

class _PostsScreenState extends State<PostsScreen> {
  @override
  void initState() {
    super.initState();
    _getAllPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Posts"),
      ),
      body: BlocBuilder<PostsBloc, PostsState>(
        builder: (context, state) {
          return switch (state.status) {
            PostsStatus.loading ||
            PostsStatus.initial =>
              _buildLoading(context),
            PostsStatus.error => _buildError(context, state.exception),
            PostsStatus.success => _buildSuccess(context, state.posts),
          };
        },
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () => {CreatePostScreen.navigateTo(context)},
        style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(10),
            shape: const CircleBorder(),
            backgroundColor: Colors.blue),
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 35,
        ),
      ),
    );
  }

  void _getAllPosts() {
    final postsBloc = context.read<PostsBloc>();
    postsBloc.add(GetAllPosts());
  }

  Widget _buildLoading(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildError(BuildContext context, AppException? exception) {
    return Column(
      children: [
        Center(
          child: Text('Error: $exception'),
        ),
        FilledButton(
          onPressed: () {PostsScreen.navigateTo(context);},
          child: const Text("Retour vers les posts"),
        ),
      ],
    );
  }

  Widget _buildSuccess(BuildContext context, List<Post> posts) {
    return RefreshIndicator(
      onRefresh: () async {
        _getAllPosts();
      },
      child: ListView.separated(
        itemCount: posts.length,
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final post = posts[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: PostCard(
              post: post,
              onClick: () {
                PostDetailScreen.navigateTo(context, post.id);
              },
            ),
          );
        },
      ),
    );
  }
}
