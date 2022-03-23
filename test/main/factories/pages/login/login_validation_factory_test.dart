import 'package:manga_clean_arch/main/factories/factories.dart';
import 'package:manga_clean_arch/validation/validators/validators.dart';
import 'package:test/test.dart';

void main() {
  test('Should return the correct validations ', () {
    final validations = makeLoginValidations();

    expect(validations, [
      RequiredFieldValidation('email'),
      EmailValidation('email'),
      RequiredFieldValidation('password')
    ]);
  });
}
