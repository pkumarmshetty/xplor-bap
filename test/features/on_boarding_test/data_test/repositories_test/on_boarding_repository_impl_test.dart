import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:xplor/features/on_boarding/data/repositories/on_boarding_repository_impl.dart';
import 'package:xplor/features/on_boarding/domain/entities/ob_boarding_verify_otp_entity.dart';
import 'package:xplor/features/on_boarding/domain/entities/on_boarding_assign_role_entity.dart';
import 'package:xplor/features/on_boarding/domain/entities/on_boarding_send_otp_entity.dart';
import 'package:xplor/features/on_boarding/domain/entities/on_boarding_user_role_entity.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  group('OnBoardingRepositoryImpl', () {
    late OnBoardingRepositoryImpl repository;
    late MockOnBoardingApiService mockApiService;
    late MockNetworkInfo mockNetworkInfo;

    setUp(() {
      mockApiService = MockOnBoardingApiService();
      mockNetworkInfo = MockNetworkInfo();
      repository = OnBoardingRepositoryImpl(
        apiService: mockApiService,
        networkInfo: mockNetworkInfo,
      );
    });

    group('sendOtpOnBoarding', () {
      final entity = OnBoardingSendOtpEntity();

      test('should return the otp when the call to data source is successful', () async {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(mockApiService.sendOtpOnBoarding(any)).thenAnswer((_) async => '123456');

        final result = await repository.sendOtpOnBoarding(entity);

        expect(result, '123456');
        verify(mockApiService.sendOtpOnBoarding(entity)).called(1);
      });

      test('should throw an exception when there is no internet connection', () async {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

        expect(() => repository.sendOtpOnBoarding(entity), throwsA(isA<Exception>()));

        verifyNever(mockApiService.sendOtpOnBoarding(any));
      });
    });

    group('verifyOtpOnBoarding', () {
      final entity = OnBoardingVerifyOtpEntity();

      test('should complete successfully when the call to data source is successful', () async {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

        await repository.verifyOtpOnBoarding(entity);

        verify(mockApiService.verifyOtpOnBoarding(entity)).called(1);
      });

      test('should throw an exception when there is no internet connection', () async {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

        expect(() => repository.verifyOtpOnBoarding(entity), throwsA(isA<Exception>()));

        verifyNever(mockApiService.verifyOtpOnBoarding(entity));
      });
    });

    group('assignRoleOnBoarding', () {
      final entity = OnBoardingAssignRoleEntity();

      test('should return true when the call to data source is successful', () async {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(mockApiService.assignRoleOnBoarding(any)).thenAnswer((_) async => true);

        final result = await repository.assignRoleOnBoarding(entity);

        expect(result, true);
        verify(mockApiService.assignRoleOnBoarding(entity)).called(1);
      });

      test('should throw an exception when there is no internet connection', () async {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

        expect(() => repository.assignRoleOnBoarding(entity), throwsA(isA<Exception>()));

        verifyNever(mockApiService.assignRoleOnBoarding(entity));
      });
    });

    group('updateUserKycOnBoarding', () {
      test('should return true when the call to data source is successful', () async {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(mockApiService.updateUserKycOnBoarding()).thenAnswer((_) async => true);

        final result = await repository.updateUserKycOnBoarding();

        expect(result, true);
        verify(mockApiService.updateUserKycOnBoarding()).called(1);
      });

      test('should throw an exception when there is no internet connection', () async {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

        expect(() => repository.updateUserKycOnBoarding(), throwsA(isA<Exception>()));

        verifyNever(mockApiService.updateUserKycOnBoarding());
      });
    });

    group('getUserRolesOnBoarding', () {
      test('should return a list of user roles when the call to data source is successful', () async {
        final userRoles = <OnBoardingUserRoleEntity>[];
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(mockApiService.getUserRolesOnBoarding()).thenAnswer((_) async => userRoles);

        final result = await repository.getUserRolesOnBoarding();

        expect(result, userRoles);
        verify(mockApiService.getUserRolesOnBoarding()).called(1);
      });

      test('should throw an exception when there is no internet connection', () async {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

        expect(() => repository.getUserRolesOnBoarding(), throwsA(isA<Exception>()));

        verifyNever(mockApiService.getUserRolesOnBoarding());
      });
    });

    group('getEAuthProviders', () {
      test('getEAuthProviders - Network not connected', () async {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
        expect(() => repository.getEAuthProviders(), throwsException);
      });
    });

    group('YourTestClass', () {
      test('createMpin - Network connected', () async {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(mockApiService.createMpin('123456')).thenAnswer((_) async => true);

        final result = await repository.createMpin('123456');

        expect(result, true);
      });

      test('createMpin - Network not connected', () async {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

        // Call the method and expect an exception to be
        expect(() => repository.createMpin('1234'), throwsException);
      });
    });

    group('getUserJourney', () {
      test('should complete successfully when the call to data source is successful', () async {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

        await repository.getUserJourney();

        verify(mockApiService.getUserJourney()).called(1);
      });

      test('should throw an exception when there is no internet connection', () async {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

        expect(() => repository.getUserJourney(), throwsA(isA<Exception>()));

        verifyNever(mockApiService.getUserJourney());
      });
    });
  });
}
