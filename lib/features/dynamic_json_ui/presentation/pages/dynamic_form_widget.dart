import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../../utils/app_dimensions.dart';
import '../bloc/form_bloc.dart';
import '../../data/models/form_field_data_model.dart';
import '../widgets/common_widgets.dart';

/// The main widget for the dynamic form.
class DynamicFormWidget extends StatefulWidget {
  final String jsonString;

  const DynamicFormWidget({super.key, required this.jsonString});

  @override
  State<DynamicFormWidget> createState() => _DynamicFormWidgetState();
}

class _DynamicFormWidgetState extends State<DynamicFormWidget> {
  /// Parse the JSON string and return a list of [FormFieldDataModel].
  late List<Widget> widgets;
  final Map<String, String> formData = {};
  final formBloc = FormBloc();

  /// Parse the JSON string and return a list of [FormFieldDataModel].
  @override
  void initState() {
    super.initState();
    final formFields = parseJson(widget.jsonString);
    formBloc.initForm(formFields); // Initialize form fields in the bloc
    widgets = generateWidgets(formFields);
  }

  /// Parse the JSON string and return a list of [FormFieldDataModel].
  @override
  void dispose() {
    formBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dynamic Form')),
      body: Padding(
        padding: const EdgeInsets.all(AppDimensions.medium),
        child: Column(
          children: [
            ...widgets,
            const SizedBox(height: AppDimensions.medium),
            ElevatedButton(
              onPressed: () {
                if (formBloc.isFormValid()) {
                  saveFormData();
                  printFormData();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill all required fields.'),
                    ),
                  );
                }
              },
              child: const Text('Submit Form'),
            ),
          ],
        ),
      ),
    );
  }

  /// Save the form data to the [formData] map.
  void saveFormData() {
    formData.clear();
    formData.addAll(formBloc.formState);
  }

  /// Print the form data to the console.
  void printFormData() {
    //AppUtils.printLogs(formData);
  }

  /// Generate the widgets based on the [FormFieldDataModel] list.
  List<Widget> generateWidgets(List<FormFieldData> formFields) {
    return formFields.map((field) {
      switch (field.type) {
        case 'text':
          return TextFieldWidget(
            hintText: field.hintText ?? '',
            functionId: field.functionId ?? 0,
            onChanged: (text) => formBloc.updateField(field.label, text),
          );
        case 'dropdown':
          return DropdownButtonFormField<String>(
            onChanged: (value) => {formBloc.updateField(field.label, value!)},
            items: field.items?.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            decoration: InputDecoration(
              labelText: field.label,
            ),
          );

        default:
          return const SizedBox(); // Handle other types of widgets if needed
      }
    }).toList();
  }

  /// Parse the JSON string and return a list of [FormFieldDataModel].
  List<FormFieldData> parseJson(String jsonStr) {
    final jsonData = json.decode(jsonStr);
    return List<FormFieldData>.from(
      jsonData.map((item) => FormFieldData.fromJson(item)),
    );
  }
}
