import 'package:al2_2024_bloc/posts_screen/posts_bloc/posts_bloc.dart';
import 'package:al2_2024_bloc/shared/models/post.dart';
import 'package:al2_2024_bloc/shared/services/posts_repository.dart';
import 'package:al2_2024_bloc/shared/widgets/inputs/input_area.dart';
import 'package:al2_2024_bloc/shared/widgets/inputs/input_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/app_exception.dart';

class PostDetailScreen extends StatefulWidget {
  static void navigateTo(BuildContext context, String postId) {
    Navigator.of(context)
        .pushNamed('/posts/details/:post_id', arguments: postId);
  }

  final String postId;

  const PostDetailScreen({super.key, required this.postId});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String _titleError = "";
  String _descriptionError = "";

  Post? post;
  bool editMode = false;
  bool isLoading = true;

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadPost();
  }

  Future<void> _loadPost() async {
    try {
      PostsRepository repository = context.read<PostsRepository>();
      Post fetchedPost = await repository.getPostById(widget.postId);
      setState(() {
        post = fetchedPost;
        _titleController.text = fetchedPost.title;
        _descriptionController.text = fetchedPost.description;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Détail du post"),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Détail du post"), actions: [
        editMode
            ? IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    editMode = false;
                  });
                },
              )
            : IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  setState(() {
                    editMode = true;
                  });
                },
              ),
      ]),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: editMode ? _editPost() : _displayPost(),
        ),
      ),
    );
  }

  List<Widget> _displayPost() {
    return [
      Text(post!.title, style: Theme.of(context).textTheme.headlineSmall),
      const SizedBox(height: 16),
      Text(post!.description),
    ];
  }

  List<Widget> _editPost() {
    return [
      Padding(
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
                child: const Text("Modifier"),
              ),
            ),
          ],
        ),
      )
    ];
  }

  void _submitForm(BuildContext context) {
    try {
      final title = _titleController.text;
      final description = _descriptionController.text;

      if (title.isEmpty || description.isEmpty) {
        setState(() {
          _titleError = title.isEmpty ? "Le titre est requis" : "";
          _descriptionError =
              description.isEmpty ? "La description est requis" : "";
        });
      } else {
        final postsBloc = context.read<PostsBloc>();
        postsBloc.add(UpdatePost(
          post: Post(id: post!.id, title: title, description: description),
        ));
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Post modifié")),
        );
      }
    } catch (error) {
      final appException = AppException.from(error);
      print(error);
    }
  }
}
