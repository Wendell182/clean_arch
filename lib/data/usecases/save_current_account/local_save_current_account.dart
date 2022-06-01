import 'package:meta/meta.dart';

import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/save_current_account.dart';

import '../../cache/cache.dart';

class LocalSaveCurrentAccount implements SaveCurrentAccount {
  final SaveSecureCachStorage saveSecureCachStorage;

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
