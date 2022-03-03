import 'package:flutter/material.dart';
import 'package:manga_clean_arch/presentation/protocols/protocols.dart';
import 'package:manga_clean_arch/validation/protocols/field_validation.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class ValidationComposite implements Validation {
  final List<FieldValidation> validations;

  ValidationComposite(this.validations);

  String validate({@required String field, @required String value}) {
    return null;
  }
}

class FieldVAlidationSpy extends Mock implements FieldValidation {}

void main() {
  test('should return null if all validations returns null or empty', () {
    final validation1 = FieldVAlidationSpy();
    when(validation1.field).thenReturn('any_field');
    when(validation1.validate(any)).thenReturn(null);
    final validation2 = FieldVAlidationSpy();
    when(validation2.field).thenReturn('any_field');
    when(validation2.validate(any)).thenReturn('');
    final sut = ValidationComposite([validation1, validation2]);

    final error = sut.validate(field: 'any_field', value: 'any_value');

    expect(error, null);
  });
}
