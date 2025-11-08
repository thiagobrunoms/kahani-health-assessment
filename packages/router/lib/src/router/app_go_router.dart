import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:authentication/authentication.dart';
import 'package:post/post.dart';

/// AppGoRouter provides a GoRouter instance through dependency injection
@singleton
class AppGoRouter {
  late final GoRouter _router;

  AppGoRouter() {
    _router = GoRouter(
      initialLocation: '/login',
      routes: [
        LoginRoute.createRoute(),
        PostRoute.createRoute(),
      ],
    );
  }

  /// Gets the GoRouter instance
  GoRouter get router => _router;
}



