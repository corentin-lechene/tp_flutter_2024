
import 'package:flutter/material.dart';

class InputArea extends StatefulWidget {
  final String placeholder;
  final TextEditingController controller;
  final String? errorMessage;

  const InputArea({
    super.key,
    required this.placeholder,
    required this.controller,
    this.errorMessage,
  });

  @override
  State<InputArea> createState() => _InputAreaState();
}

class _InputAreaState extends State<InputArea> {
  @override
  Widget build(BuildContext context) {
    return Column(
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
              controller: widget.controller,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
              decoration: InputDecoration.collapsed(
                hintText: widget.placeholder,
                hintStyle: const TextStyle(
                  color: Colors.grey,
                ),
              ),
              maxLines: null,
              minLines: 4,
            ),
          ),
        ),
        _buildErrorMessage(context),
      ],
    );
  }

  Widget _buildErrorMessage(BuildContext context) {
    final String? error = widget.errorMessage;

    if (error != null && error.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 4, left: 4),
        child: Text(
          error,
          style: const TextStyle(
            color: Colors.red,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}