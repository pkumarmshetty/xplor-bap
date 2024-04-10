import 'dart:io';

class BlocFormItem {
  final String? error, value, link;
  final File? file;

  const BlocFormItem({this.error, this.value, this.file, this.link});

  BlocFormItem copyWith({
    String? error,
    String? value,
    String? link,
    File? file,
  }) {
    return BlocFormItem(
      error: error ?? this.error,
      link: link ?? this.link,
      value: value ?? this.value,
      file: file ?? this.file,
    );
  }
}
