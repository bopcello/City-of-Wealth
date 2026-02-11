import 'package:flutter/material.dart';

class NameEntryDialog extends StatefulWidget {
  final void Function(String) onConfirm;

  const NameEntryDialog({super.key, required this.onConfirm});

  @override
  State<NameEntryDialog> createState() => _NameEntryDialogState();
}

class _NameEntryDialogState extends State<NameEntryDialog> {
  final TextEditingController _controller = TextEditingController();
  String? _errorText;

  void _handleSubmit() {
    final name = _controller.text.trim();
    if (name.isEmpty) {
      setState(() {
        _errorText = "Name cannot be empty";
      });
      return;
    }
    if (name.length > 20) {
      setState(() {
        _errorText = "Name too long (max 20 chars)";
      });
      return;
    }
    widget.onConfirm(name);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Welcome to City of Wealth!"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Please enter your name to begin your journey:"),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            autofocus: true,
            decoration: InputDecoration(
              labelText: "Player Name",
              errorText: _errorText,
              border: const OutlineInputBorder(),
            ),
            onSubmitted: (_) => _handleSubmit(),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: _handleSubmit,
          child: const Text("Begin Game"),
        ),
      ],
    );
  }
}
