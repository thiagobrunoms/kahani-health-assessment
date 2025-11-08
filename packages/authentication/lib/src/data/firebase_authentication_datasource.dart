import 'package:authentication/src/data/authentication_datasource.dart';
import 'package:firebase/firebase.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: AuthenticationDatasource)
class FirebaseAuthenticationDatasource implements AuthenticationDatasource {
  @override
  bool get isUserSignedIn => FirebaseAuth.instance.currentUser != null;

  @override
  Future<bool> signInAnonymously() async {
    await FirebaseAuth.instance.signInAnonymously();
    return isUserSignedIn;
  }
}
