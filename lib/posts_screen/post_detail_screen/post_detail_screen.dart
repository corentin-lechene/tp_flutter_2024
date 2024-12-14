import 'package:al2_2024_bloc/posts_screen/posts_bloc/posts_bloc.dart';
import 'package:al2_2024_bloc/shared/models/post.dart';
import 'package:al2_2024_bloc/shared/services/posts_repository.dart';
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
  Post? post;
  String? id;
  String? title;
  String? description;
  String? titleError;
  String? descriptionError;
  bool editMode = false;
  bool isLoading = true;

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
        id = fetchedPost.id;
        title = fetchedPost.title;
        description = fetchedPost.description;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showErrorDialog(e);
    }
  }

  void _showErrorDialog(Object e) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Erreur"),
        content: Text(e.toString()),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
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
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                  decoration: const InputDecoration.collapsed(
                    hintText: "Écrire le titre",
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  maxLines: null,
                  minLines: 1,
                  onChanged: (value) => {_handleOnChangedTitle(value)},
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            _buildTitleErrorMessage(context),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: TextField(
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                  decoration: const InputDecoration.collapsed(
                    hintText: "Écrire la description",
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  maxLines: null,
                  minLines: 4,
                  onChanged: (value) => {_handleOnChangedDescription(value)},
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => {_handleUpdatePost(context)},
                child: const Text("Poster"),
              ),
            ),
            _buildDescriptionErrorMessage(context),
          ],
        ),
      )
    ];
  }

  void _handleOnChangedTitle(value) {
    title = value;
    setState(() {
      titleError = null;
    });
  }

  void _handleOnChangedDescription(value) {
    description = value;
    setState(() {
      descriptionError = null;
    });
  }

  void _handleUpdatePost(BuildContext context) {
    try {
      if (_validForm()) {
        if (id != null && title != null && description != null) {
          final postsBloc = context.read<PostsBloc>();
          postsBloc.add(UpdatePost(
            post: Post(
              id: id!,
              title: title!,
              description: description!,
            ),
          ));
          setState(() {
            editMode = false;
            post = post!.copyWith(title: title, description: description);
          });
        } else {
          print("Certaines valeurs sont nulles");
        }
      }
    } catch (error) {
      final appException = AppException.from(error);
      print(error);
    }
  }

  bool _validForm() {
    bool isValid = true;

    if (title == null || title!.isEmpty) {
      setState(() {
        titleError = "Le titre ne peut pas être vide";
      });
      isValid = false;
    } else {
      setState(() {
        titleError = null;
      });
    }

    if (description == null || description!.isEmpty) {
      setState(() {
        descriptionError = "La description ne peut pas être vide";
      });
      isValid = false;
    } else {
      setState(() {
        descriptionError = null;
      });
    }

    return isValid;
  }

  Widget _buildTitleErrorMessage(BuildContext context) {
    if (titleError != null && titleError!.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.only(left: 4, bottom: 10),
        child: Text(
          titleError!,
          style: const TextStyle(
            color: Colors.red,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildDescriptionErrorMessage(BuildContext context) {
    if (descriptionError != null && descriptionError!.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.only(left: 4, bottom: 10),
        child: Text(
          descriptionError!,
          style: const TextStyle(
            color: Colors.red,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
