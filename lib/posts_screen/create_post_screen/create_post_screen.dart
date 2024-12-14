import 'package:al2_2024_bloc/posts_screen/posts_bloc/posts_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreatePostScreen extends StatelessWidget {
  static void navigateTo(BuildContext context) {
    Navigator.pushNamed(context, '/posts/create');
  }

  const CreatePostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nouveau Post"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: TextField(
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                  decoration: InputDecoration.collapsed(
                    hintText: "Écrire votre message ici.",
                    hintStyle: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  maxLines: null,
                  minLines: 4,
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => {
                  _handleCreatePost(context)
                },
                child: const Text("Poster"),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _handleCreatePost(BuildContext context) {
    const String value = "Nouveau post ici et maintenant";//todo
    print("handle");

    try {
      final postsBloc = context.read<PostsBloc>();
      postsBloc.add(CreatePost(title: value));
    } catch (error) {
      print("error");
      print(error);
    }
  }
}
