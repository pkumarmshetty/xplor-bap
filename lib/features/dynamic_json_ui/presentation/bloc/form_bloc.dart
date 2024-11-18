import 'dart:async';
import '../../data/models/form_field_data_model.dart';

/// FormBloc manages the state of a dynamic form.
class FormBloc {
  List<FormFieldData> _formFields = [];
  Map<String, String> _formData = {};
  final _formStateController = StreamController<Map<String, String>>();
  final _formValidationController = StreamController<bool>();

  /// Stream to expose the current state of the form.
  Stream<Map<String, String>> get formStateStream => _formStateController.stream;

  /// Stream to expose the validation status of the form.
  Stream<bool> get formValidationStream => _formValidationController.stream;

  /// Initialize the form with the provided form fields.
  void initForm(List<FormFieldData> formFields) {
    _formFields = formFields;
    _formData = {};
    for (var field in _formFields) {
      _formData[field.label] = '';
    }
    _formStateController.sink.add(_formData);
  }

  /// Update the value of a form field identified by its label.
  void updateField(String label, String value) {
    _formData[label] = value;
    _formStateController.sink.add(_formData);
    validateForm();
  }

  /// Validate the entire form and update the validation status.
  void validateForm() {
    bool isValid = true;
    List<String> errorMessages = [];

    for (var field in _formFields) {
      final errorMessage = field.validate(_formData[field.label]);
      if (errorMessage != null) {
        isValid = false;
        errorMessages.add(errorMessage); // Collect error messages
      }
    }

    // Set the error message
    final errorMessageString = errorMessages.isNotEmpty ? errorMessages.join('\n') : ''; // Empty string if no error
    _formValidationController.sink.add(isValid);
    if (!isValid) {
      // Send error message only if the form is not valid
      _formStateController.sink.addError(errorMessageString);
    } else {
      // Clear the error message if the form is valid
      _formStateController.sink.add({});
    }
  }

  /// Check if the form is valid.
  bool isFormValid() {
    bool isValid = true;
    for (var field in _formFields) {
      final errorMessage = field.validate(_formData[field.label]);
      if (errorMessage != null) {
        isValid = false;
        break;
      }
    }
    return isValid;
  }

  /// Get the current state of the form.
  Map<String, String> get formState {
    return Map.from(_formData);
  }

  /// Dispose method to close stream controllers when not in use.
  void dispose() {
    _formStateController.close();
    _formValidationController.close();
  }
}
