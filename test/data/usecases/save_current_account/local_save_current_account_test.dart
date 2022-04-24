import 'package:faker/faker.dart';
import 'package:manga_clean_arch/data/cache/save_secure_cache_storage.dart';
import 'package:manga_clean_arch/data/usecases/save_current_account/local_save_current_account.dart';
import 'package:manga_clean_arch/domain/helpers/helpers.dart';
import 'package:manga_clean_arch/domain/entities/entities.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class SaveSecureCacheStorageSpy extends Mock implements SaveSecureCachStorage {}

void main() {
  SaveSecureCacheStorageSpy saveSecureCachStorage;
  LocalSaveCurrentAccount sut;
  AccountEntity account;
  setUp(() {
    saveSecureCachStorage = SaveSecureCacheStorageSpy();
    sut = LocalSaveCurrentAccount(saveSecureCachStorage: saveSecureCachStorage);
    account = AccountEntity(faker.guid.guid());
  });

  mockError() {
    when(saveSecureCachStorage.saveSecure(
      key: anyNamed('key'),
      value: anyNamed('value'),
    )).thenThrow(Exception());
  }

  test('Should call SaveSecureCachStorage with correct values', () async {
    await sut.save(account);

    verify(
        saveSecureCachStorage.saveSecure(key: 'token', value: account.token));
  });

  test('Should throw UnexpectedError if SaveSecureCachStorage throws',
      () async {
    mockError();

    final future = sut.save(account);

    expect(future, throwsA(DomainError.unexpected));
  });
}
