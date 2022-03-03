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
  ValidationComposite sut;
  FieldVAlidationSpy validation1;
  FieldVAlidationSpy validation2;
  FieldVAlidationSpy validation3;

  void mockValidation1(String error) {
    when(validation1.validate(any)).thenReturn(error);
  }

  void mockValidation2(String error) {
    when(validation1.validate(any)).thenReturn(error);
  }

  void mockValidation3(String error) {
    when(validation1.validate(any)).thenReturn(error);
  }

  setUp(() {
    validation1 = FieldVAlidationSpy();
    when(validation1.field).thenReturn('any_field');
    mockValidation1(null);
    validation2 = FieldVAlidationSpy();
    when(validation2.field).thenReturn('any_field');
    mockValidation3(null);
    validation3 = FieldVAlidationSpy();
    when(validation2.field).thenReturn('other_field');
    mockValidation2(null);

    sut = ValidationComposite([validation1, validation2, validation3]);
  });

  test('should return null if all validations returns null or empty', () {
    mockValidation2('');
    final error = sut.validate(field: 'any_field', value: 'any_value');

    expect(error, null);
  });
}