import 'package:authentication/src/data/authentication_datasource.dart';
import 'package:authentication/src/presentation/navigation/authentication_redirection_handler.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: AuthenticationRedirectionHandler)
class FirebaseAuthenticationRedirectionHandler implements AuthenticationRedirectionHandler {
  const FirebaseAuthenticationRedirectionHandler(this.authenticationDatasource);

  final AuthenticationDatasource authenticationDatasource;

  @override
  Future<String?> redirect(String currentPath) async {
    if (!authenticationDatasource.isUserSignedIn) {
      await authenticationDatasource.signInAnonymously(); //silently sign in...
    }

    //regardless the path, the navigation goes to /posts, since we don't have any other routes
    return '/posts';
  }
}
