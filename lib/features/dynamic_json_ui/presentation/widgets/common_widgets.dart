import 'package:flutter/material.dart';

/// Widgets for different types of form fields.
class TextWidget extends StatelessWidget {
  final String text;
  final ValueChanged<String>? onChanged;

  const TextWidget({
    super.key,
    required this.text,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: TextEditingController(text: text),
      onChanged: onChanged,
    );
  }
}

class ButtonWidget extends StatelessWidget {
  final String text;
  final int functionId;
  final VoidCallback onPressed;

  const ButtonWidget({
    super.key,
    required this.text,
    required this.functionId,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(text),
    );
  }
}

class ImageWidget extends StatelessWidget {
  final String imageUrl;

  const ImageWidget({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Image.network(imageUrl);
  }
}

class TextFieldWidget extends StatelessWidget {
  final String hintText;
  final int functionId;
  final ValueChanged<String>? onChanged;

  const TextFieldWidget({
    super.key,
    required this.hintText,
    required this.functionId,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(hintText: hintText),
      onChanged: onChanged,
    );
  }
}

class RadioWidget extends StatelessWidget {
  final String text;
  final bool groupValue;
  final int functionId;
  final ValueChanged<bool?>? onChanged;

  const RadioWidget({
    super.key,
    required this.text,
    required this.groupValue,
    required this.functionId,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return RadioListTile<bool>(
      title: Text(text),
      value: groupValue,
      groupValue: true,
      onChanged: onChanged,
    );
  }
}

class DropdownWidget extends StatelessWidget {
  final List<String> items;
  final String? value;
  final int functionId;
  final ValueChanged<String?>? onChanged;

  const DropdownWidget({
    super.key,
    required this.items,
    required this.value,
    required this.functionId,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: value,
      items: items
          .map((value) => DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              ))
          .toList(),
      onChanged: onChanged,
    );
  }
}
