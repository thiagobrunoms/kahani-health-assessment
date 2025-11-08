abstract class AuthenticationDatasource {
  bool get isUserSignedIn;

  Future<bool> signInAnonymously();
}
