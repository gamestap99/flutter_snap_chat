import 'package:formz/formz.dart';

enum NameValidationError { invalid }

class NameValidator extends FormzInput<String, NameValidationError> {
  const NameValidator.pure() : super.pure('');

  const NameValidator.dirty([String value = '']) : super.dirty(value);

  @override
  NameValidationError validator(String value) {
    return value.length > 3 ? null : NameValidationError.invalid;
  }
}
