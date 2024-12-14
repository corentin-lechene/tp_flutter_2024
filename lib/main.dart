import 'package:al2_2024_bloc/posts_screen/create_post_screen/create_post_screen.dart';
import 'package:al2_2024_bloc/posts_screen/posts_bloc/posts_bloc.dart';
import 'package:al2_2024_bloc/posts_screen/posts_screen.dart';
import 'package:al2_2024_bloc/shared/services/posts_data_source/fake_post_data_source.dart';
import 'package:al2_2024_bloc/shared/services/posts_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => PostsRepository(
        dataSource: FakePostsDataSource(),
      ),
      child: BlocProvider(
        create: (context) => PostsBloc(
          postsRepository: context.read<PostsRepository>(),
        ),
        child: SafeArea(
          child: MaterialApp(
            color: Colors.white,
            title: 'Flutter Demo',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            routes: {
              '/': (context) => const PostsScreen(),
              '/posts/create': (context) => const CreatePostScreen(),
            },
          ),
        ),
      )
    );
  }
}