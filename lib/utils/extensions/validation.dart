extension BoolExtension on String {
  bool get isValidPassword {
    // Assuming 'this' refers to the password string
    return length >= 8;
  }

  bool get isValidName {
    final nameRegExp = RegExp(r"^\s*([A-Za-z]{1,}([\.,] |[-']| ))+[A-Za-z]+\.?\s*$");
    return nameRegExp.hasMatch(this);
  }

  bool get isValidPhone {
    /*final phoneRegExp = RegExp(r"^(?:[+0]9)?[0-9]{10}$");
    return phoneRegExp.hasMatch(this);*/
    return replaceAll(' ', '').length == 10;
  }

  bool get isNumeric {
    if (isNotEmpty) {
      return false;
    }
    return double.tryParse(this) != null;
  }

  bool get isValidString {
    return trim().isNotEmpty;
  }
}

enum ValidationType {
  password,
  name,
  phone,
  date,
  gender,
  aadhaar,
  clas,
  docProof,
  previousMarksheet,
  schoolID,
  uploadMarksheet,
  uploadPassbook,
  enrollment,
  accNo,
  ifsc,
  upi,
  bankName,
}

class ValidationMessages {
  static String errorText(String field) {
    return "Please enter $field";
  }

  static String get passwordError => errorText("password");

  static String get passwordLimitError => "Password should be more than 8 characters";

  static String get nameError => errorText("name");

  static String get phoneError => errorText("phone number");

  static String get phoneLimitError => "Phone number must be 10 digits";

  static String get dateError => errorText("date");

  static String get ifscError => errorText("IFSC Code");

  static String get bankNameError => errorText("bank");

  static String get upiError => errorText("UPI ID");

  static String get genderError => errorText("gender");

  static String get addharError => "Please select addhar file";

  static String get schoolIDError => "Please enter school id";

  static String get uploadMarksheetError => "Please select upload marksheets";

  static String get enrollmentError => "Please select enrollment receipt";

  static String get uploadPassbookError => "Please upload passbook";

  static String get addharProofError => errorText("addhar proof");

  static String get clasError => errorText("class");

  static String get docProofError => "Please select document proof file";

  static String get accNoError => errorText("account number");

  static String get previousMarksheetError => "Please select previous class marksheet file";
}

extension StringExtension on String {
  String? getValidationError(ValidationType type) {
    switch (type) {
      case ValidationType.password:
        return isValidString
            ? isValidPassword
                ? null
                : ValidationMessages.passwordLimitError
            : ValidationMessages.passwordError;
      case ValidationType.name:
        return isValidString ? null : ValidationMessages.nameError;
      case ValidationType.phone:
        return isValidString
            ? isValidPhone
                ? null
                : ValidationMessages.phoneLimitError
            : ValidationMessages.phoneError;
      case ValidationType.date:
        return isValidString ? null : ValidationMessages.dateError;
      case ValidationType.gender:
        return isValidString ? null : ValidationMessages.genderError;
      case ValidationType.aadhaar:
        return isValidString ? null : ValidationMessages.addharError;
      case ValidationType.clas:
        return isValidString ? null : ValidationMessages.clasError;
      case ValidationType.docProof:
        return isValidString ? null : ValidationMessages.docProofError;
      case ValidationType.previousMarksheet:
        return isValidString ? null : ValidationMessages.previousMarksheetError;
      case ValidationType.schoolID:
        return isValidString ? null : ValidationMessages.schoolIDError;
      case ValidationType.accNo:
        return isValidString ? null : ValidationMessages.accNoError;
      case ValidationType.ifsc:
        return isValidString ? null : ValidationMessages.ifscError;
      case ValidationType.upi:
        return isValidString ? null : ValidationMessages.upiError;
      case ValidationType.uploadMarksheet:
        return isValidString ? null : ValidationMessages.uploadMarksheetError;
      case ValidationType.enrollment:
        return isValidString ? null : ValidationMessages.enrollmentError;
      case ValidationType.uploadPassbook:
        return isValidString ? null : ValidationMessages.uploadPassbookError;
      case ValidationType.bankName:
        return isValidString ? null : ValidationMessages.bankNameError;
    }
  }
}
