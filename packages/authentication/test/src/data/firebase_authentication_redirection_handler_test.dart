import 'package:authentication/src/data/authentication_datasource.dart';
import 'package:authentication/src/presentation/navigation/firebase_authentication_redirection_handler.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mock implementation of AuthenticationDatasource for testing
class MockAuthenticationDatasource extends Mock implements AuthenticationDatasource {}

void main() {
  group('FirebaseAuthenticationRedirectionHandler', () {
    late MockAuthenticationDatasource mockDatasource;
    late FirebaseAuthenticationRedirectionHandler handler;

    setUp(() {
      mockDatasource = MockAuthenticationDatasource();
      handler = FirebaseAuthenticationRedirectionHandler(mockDatasource);
    });

    test('should return /posts when user is already signed in', () async {
      // Arrange
      when(() => mockDatasource.isUserSignedIn).thenReturn(true);
      const currentPath = '/login';

      // Act
      final result = await handler.redirect(currentPath);

      // Assert
      expect(result, equals('/posts'));
      // Verify authenticationDatasource.signInAnonymously() is not called
      verifyNever(() => mockDatasource.signInAnonymously());
    });

    test('should sign in anonymously and return /posts when user is not signed in', () async {
      // Arrange
      when(() => mockDatasource.isUserSignedIn).thenReturn(false);
      when(() => mockDatasource.signInAnonymously()).thenAnswer((_) async => true);
      const currentPath = '/login';

      // Act
      final result = await handler.redirect(currentPath);

      // Assert
      expect(result, equals('/posts'));
      // Verify authenticationDatasource.signInAnonymously() is called exactly once
      verify(() => mockDatasource.signInAnonymously()).called(1);
    });

    test('should return /posts regardless of current path when user is signed in', () async {
      // Arrange
      when(() => mockDatasource.isUserSignedIn).thenReturn(true);
      const currentPath = '/any/path';

      // Act
      final result = await handler.redirect(currentPath);

      // Assert
      expect(result, equals('/posts'));
      // Verify authenticationDatasource.signInAnonymously() is not called
      verifyNever(() => mockDatasource.signInAnonymously());
    });

    test('should return /posts regardless of current path when user is not signed in', () async {
      // Arrange
      when(() => mockDatasource.isUserSignedIn).thenReturn(false);
      when(() => mockDatasource.signInAnonymously()).thenAnswer((_) async => true);
      const currentPath = '/any/other/path';

      // Act
      final result = await handler.redirect(currentPath);

      // Assert
      expect(result, equals('/posts'));
      // Verify authenticationDatasource.signInAnonymously() is called exactly once
      verify(() => mockDatasource.signInAnonymously()).called(1);
    });

    test('should return /posts for empty path when user is signed in', () async {
      // Arrange
      when(() => mockDatasource.isUserSignedIn).thenReturn(true);
      const currentPath = '';

      // Act
      final result = await handler.redirect(currentPath);

      // Assert
      expect(result, equals('/posts'));
      // Verify authenticationDatasource.signInAnonymously() is not called
      verifyNever(() => mockDatasource.signInAnonymously());
    });

    test('should return /posts for empty path when user is not signed in', () async {
      // Arrange
      when(() => mockDatasource.isUserSignedIn).thenReturn(false);
      when(() => mockDatasource.signInAnonymously()).thenAnswer((_) async => true);
      const currentPath = '';

      // Act
      final result = await handler.redirect(currentPath);

      // Assert
      expect(result, equals('/posts'));
      // Verify authenticationDatasource.signInAnonymously() is called exactly once
      verify(() => mockDatasource.signInAnonymously()).called(1);
    });

    test('should handle multiple redirect calls correctly', () async {
      // Arrange
      when(() => mockDatasource.isUserSignedIn).thenReturn(false);
      when(() => mockDatasource.signInAnonymously()).thenAnswer((_) async {
        // After first call, user is signed in
        when(() => mockDatasource.isUserSignedIn).thenReturn(true);
        return true;
      });

      // Act
      final result1 = await handler.redirect('/login');
      final result2 = await handler.redirect('/home');

      // Assert
      expect(result1, equals('/posts'));
      expect(result2, equals('/posts'));
      // Verify authenticationDatasource.signInAnonymously() is called exactly once
      // (After first call, user is signed in, so second call won't call signInAnonymously)
      verify(() => mockDatasource.signInAnonymously()).called(1);
    });

    test('should not call signInAnonymously multiple times if already signed in', () async {
      // Arrange
      when(() => mockDatasource.isUserSignedIn).thenReturn(true);

      // Act
      await handler.redirect('/login');
      await handler.redirect('/home');
      await handler.redirect('/profile');

      // Assert
      // Verify authenticationDatasource.signInAnonymously() is not called
      verifyNever(() => mockDatasource.signInAnonymously());
    });
  });
}
