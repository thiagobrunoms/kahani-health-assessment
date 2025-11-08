import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'package:authentication/src/presentation/navigation/authentication_redirection_handler.dart';
import 'package:common_dependencies/common_dependencies.dart';

class LoginRoute {
  static GoRoute createRoute() {
    return GoRoute(
      path: '/login',
      name: 'login',
      redirect: (context, state) async {
        final authenticationRedirectionHandler = getIt<AuthenticationRedirectionHandler>();
        return await authenticationRedirectionHandler.redirect(state.uri.path);
      },
      builder: (context, state) => const SizedBox.shrink(),
    );
  }
}
