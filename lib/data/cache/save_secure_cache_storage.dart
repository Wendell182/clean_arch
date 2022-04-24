import 'package:meta/meta.dart';

abstract class SaveSecureCachStorage {
  Future<void> saveSecure({@required String key, @required String value});
}
