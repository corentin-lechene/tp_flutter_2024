import 'package:al2_2024_bloc/posts_screen/posts_bloc/posts_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/app_exception.dart';

class CreatePostScreen extends StatefulWidget {
  static void navigateTo(BuildContext context) {
    Navigator.pushNamed(context, '/posts/create');
  }

  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  String? title;
  String? description;
  String? titleError;
  String? descriptionError;

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
                  onChanged: (value) => {
                    _handleOnChangedTitle(value)
                  },
                ),
              ),
            ),
            SizedBox(
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
                  onChanged: (value) => {
                    _handleOnChangedDescription(value)
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => {_handleCreatePost(context)},
                child: const Text("Poster"),
              ),
            ),
            _buildDescriptionErrorMessage(context),
          ],
        ),
      ),
    );
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

  void _handleCreatePost(BuildContext context) {
    try {
      if (_validForm()) {
        final postsBloc = context.read<PostsBloc>();
        postsBloc.add(CreatePost(title: title!, description: description!));
        Navigator.of(context).pop();
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
