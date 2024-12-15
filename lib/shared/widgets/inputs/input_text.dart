import 'package:flutter/material.dart';

class InputText extends StatefulWidget {
  final String placeholder;
  final TextEditingController controller;
  final String? errorMessage;

  const InputText({
    super.key,
    required this.placeholder,
    required this.controller,
    this.errorMessage,
  });

  @override
  State<InputText> createState() => _InputTextState();
}

class _InputTextState extends State<InputText> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: widget.controller,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w400,
              fontSize: 14,
            ),
            maxLines: 1,
            decoration: InputDecoration.collapsed(
              hintText: widget.placeholder,
              hintStyle: const TextStyle(
                color: Colors.grey,
              ),
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
