import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:router/src/router/app_go_router.dart';

/// AppNavigator provides a clean API for navigation that hides
/// the implementation details of GoRouter's context.go and context.push
@injectable
class AppNavigator {
  final AppGoRouter _appGoRouter;

  AppNavigator(this._appGoRouter);

  /// Gets the GoRouter instance from AppGoRouter
  GoRouter get _router => _appGoRouter.router;

  /// Navigates to a new route, replacing the current route in the navigation stack
  ///
  /// This method hides the implementation detail of using GoRouter.go
  ///
  /// Example:
  /// ```dart
  /// appNavigator.go('/home');
  /// ```
  void go(String location, {Object? extra}) {
    _router.go(location, extra: extra);
  }

  /// Navigates to a new route by pushing it onto the navigation stack
  ///
  /// This method hides the implementation detail of using GoRouter.push
  ///
  /// Example:
  /// ```dart
  /// appNavigator.push('/home');
  /// ```
  void push(String location, {Object? extra}) {
    _router.push(location, extra: extra);
  }

  /// Checks if the current route can be popped
  bool canPop() {
    return _router.canPop();
  }
}


