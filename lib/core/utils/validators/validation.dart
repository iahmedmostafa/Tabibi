import 'package:intl/intl.dart';
import 'package:tabibi/core/utils/constants/app_strings.dart';
import 'package:easy_localization/easy_localization.dart';

/// VALIDATION CLASS
class Validator {
  /// Empty Text Validation
  static String? validateEmptyText(String? fieldName, String? value) {
    if (value == null || value.isEmpty) {
      return 'fieldIsRequired'.tr(namedArgs: {'fieldName': fieldName ?? ''});
    }

    return null;
  }

  static String? validatePinCode(String? pinCode) {
    if (pinCode == null || pinCode.isEmpty) {
      return 'pinCodeRequired'.tr();
    }

    // Check for exact pinCode length (6 digits expected)
    if (pinCode.length < 6) {
      return 'pinCodeMustBe6Digits'.tr();
    }

    return null;
  }

  static String? validateAge(String? input) {
    if (input == null || input.isEmpty) {
      return 'dateOfBirthRequired'.tr();
    }

    try {
      // Parse the input date in the 'dd-MMM-yyyy' format
      final DateFormat format = DateFormat('dd-MMM-yyyy');
      final DateTime dateOfBirth = format.parse(input);

      final DateTime today = DateTime.now();
      final int age =
          today.year -
          dateOfBirth.year -
          ((today.month < dateOfBirth.month ||
                  (today.month == dateOfBirth.month &&
                      today.day < dateOfBirth.day))
              ? 1
              : 0);

      if (age < 18) {
        return AppStrings.dateOfBirthError;
      }
    } catch (e) {
      return 'invalidDateFormat'.tr();
    }

    return null;
  }

  /// Username Validation
  static String? validateUsername(String? username) {
    if (username == null || username.isEmpty) {
      return 'usernameRequired'.tr();
    }

    // Define a regular expression pattern for the username.
    const pattern = r"^[a-zA-Z0-9_-]{3,20}$";

    // Create a RegExp instance from the pattern.
    final regex = RegExp(pattern);

    // Use the hasMatch method to check if the username matches the pattern.
    bool isValid = regex.hasMatch(username);

    // Check if the username doesn't start or end with an underscore or hyphen.
    if (isValid) {
      isValid =
          !username.startsWith('_') &&
          !username.startsWith('-') &&
          !username.endsWith('_') &&
          !username.endsWith('-');
    }

    if (!isValid) {
      return 'usernameNotValid'.tr();
    }

    return null;
  }

  /// Email Validation
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'emailRequired'.tr();
    }

    // Regular expression for email validation
    final emailRegExp = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegExp.hasMatch(value)) {
      return 'invalidEmail'.tr();
    }

    return null;
  }

  /// Password Validation
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'passwordRequired'.tr();
    }

    // Check for minimum password length
    if (value.length < 6) {
      return 'passwordMinLength'.tr();
    }

    // Check for uppercase letters
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'passwordUppercase'.tr();
    }

    // Check for numbers
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'passwordNumber'.tr();
    }

    // Check for special characters
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'passwordSpecialChar'.tr();
    }

    return null;
  }

  /// Phone Number Validation
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'phoneRequired'.tr();
    }

    final returnValue = validatePhoneNumberFormat(value);

    return returnValue;
  }

  static String? validatePhoneNumberFormat(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }

    // Regular expression for phone number validation (assuming a 10-digit US phone number format)
    final phoneRegExp = RegExp(r'^\d{10}$');

    if (!phoneRegExp.hasMatch(value)) {
      return 'invalidPhoneFormat'.tr();
    }

    return null;
  }

  static String? validateConfirmPassword(
    String? confirmPassword,
    String originalPassword,
  ) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return 'confirmPasswordRequired'.tr();
    }
    if (confirmPassword != originalPassword) {
      return 'passwordsDoNotMatch'.tr();
    }
    return null;
  }

  // Add more custom validators as needed for your specific requirements.
}
