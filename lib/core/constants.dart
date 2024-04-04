class Constants {
  // JSON string representing your form fields
  static String jsonString = '''
[
    {"label": "Name", "type": "text", "hintText": "Enter your name", "required": true},
    {"label": "Gender", "type": "dropdown", "items": ["Male", "Female", "Other"], "value": "", "required": true},
    {"label": "Date of Birth", "type": "text", "hintText": "Enter your date of birth", "required": true},
    {"label": "Age", "type": "text", "hintText": "Enter your age", "required": true}
]
''';
}
