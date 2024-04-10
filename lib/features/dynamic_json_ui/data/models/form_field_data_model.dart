/// Represents data for a form field.
class FormFieldData {
  final String label; // Label of the form field
  final String type; // Type of the form field
  final bool required; // Indicates if the field is required
  final String? text; // Text associated with the form field (if applicable)
  final String? hintText; // Hint text to display in the form field (if applicable)
  final String? imageUrl; // URL of an image associated with the form field (if applicable)
  final List<String>? items; // List of items for dropdown or radio button (if applicable)
  final String? value; // Value of the form field (if applicable)
  final bool? groupValue; // Group value for radio buttons (if applicable)
  final int? functionId; // ID of a function associated with the form field (if applicable)

  /// Constructor for creating a FormFieldData instance.
  FormFieldData({
    required this.label,
    required this.type,
    required this.required,
    this.text,
    this.hintText,
    this.imageUrl,
    this.items,
    this.value,
    this.groupValue,
    this.functionId,
  });

  /// Factory method to create a FormFieldData instance from JSON.
  factory FormFieldData.fromJson(Map<String, dynamic> json) {
    return FormFieldData(
      label: json['label'] ?? '',
      type: json['type'] ?? '',
      required: json['required'] ?? false,
      text: json['text'],
      hintText: json['hintText'],
      imageUrl: json['imageUrl'],
      items: json['items'] != null ? List<String>.from(json['items']) : null,
      value: json['value'],
      groupValue: json['groupValue'],
      functionId: json['functionId'],
    );
  }

  /// Validates the value of the form field.
  /// Returns an error message if the value is invalid, otherwise returns null.
  String? validate(String? value) {
    if (required && (value == null || value.isEmpty)) {
      return '$label is required';
    }
    // Add more validation logic for different field types if needed
    return null;
  }
}
