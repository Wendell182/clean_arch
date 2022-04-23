import 'package:faker/faker.dart';
import 'package:meta/meta.dart';
import 'package:manga_clean_arch/domain/entities/entities.dart';
import 'package:manga_clean_arch/domain/usecases/save_currente_account.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class LocalSaveCurrentAccount implements SaveCurrentAccount {
  final SaveSecureCachStorage saveSecureCachStorage;

  LocalSaveCurrentAccount({@required this.saveSecureCachStorage});

  Future<void> save(AccountEntity account) async {
    await saveSecureCachStorage.saveSecure(key: 'token', value: account.token);
  }
}

abstract class SaveSecureCachStorage {
  Future<void> saveSecure({@required String key, @required String value});
}

class SaveSecureCacheStorageSpy extends Mock implements SaveSecureCachStorage {}

void main() {
  test('Should call SaveCacheStorage with correct values', () async {
    final saveSecureCacheStorage = SaveSecureCacheStorageSpy();
    final sut =
        LocalSaveCurrentAccount(saveSecureCachStorage: saveSecureCacheStorage);
    final account = AccountEntity(faker.guid.guid());

    await sut.save(account);

    verify(
        saveSecureCacheStorage.saveSecure(key: 'token', value: account.token));
  });
}
