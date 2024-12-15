import 'package:al2_2024_bloc/shared/widgets/inputs/input_area.dart';
import 'package:al2_2024_bloc/shared/widgets/inputs/input_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/app_exception.dart';
import '../posts_bloc/posts_bloc.dart';

class CreatePostScreen extends StatefulWidget {
  static void navigateTo(BuildContext context) {
    Navigator.pushNamed(context, '/posts/create');
  }

  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String _titleError = "";
  String _descriptionError = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nouveau Post"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InputText(
              placeholder: "Titre",
              controller: _titleController,
              errorMessage: _titleError,
            ),
            const SizedBox(height: 10),
            InputArea(
              placeholder: "Description",
              controller: _descriptionController,
              errorMessage: _descriptionError,
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => {_submitForm(context)},
                child: const Text("Poster"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm(BuildContext context) {
    try {
      final title = _titleController.text.trim();
      final description = _descriptionController.text.trim();

      if(title.isEmpty || description.isEmpty) {
        setState(() {
          _titleError = title.isEmpty ? "Le titre est requis" : "";
          _descriptionError = description.isEmpty ? "La description est requis" : "";
        });
      } else {
        final postsBloc = context.read<PostsBloc>();
        postsBloc.add(CreatePost(title: title, description: description));
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Post créé")),
        );
      }
    } catch (error) {
      final appException = AppException.from(error);
      print(error);
    }
  }
}
