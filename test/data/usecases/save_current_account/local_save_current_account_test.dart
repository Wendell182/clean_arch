import 'package:faker/faker.dart';
import 'package:manga_clean_arch/domain/helpers/helpers.dart';
import 'package:meta/meta.dart';
import 'package:manga_clean_arch/domain/entities/entities.dart';
import 'package:manga_clean_arch/domain/usecases/save_currente_account.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class LocalSaveCurrentAccount implements SaveCurrentAccount {
  SaveSecureCachStorage saveSecureCachStorage;

  LocalSaveCurrentAccount({@required this.saveSecureCachStorage});

  Future<void> save(AccountEntity account) async {
    try {
      await saveSecureCachStorage.saveSecure(
          key: 'token', value: account.token);
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}

abstract class SaveSecureCachStorage {
  Future<void> saveSecure({@required String key, @required String value});
}

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
