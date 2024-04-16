import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:xplor/features/on_boarding/domain/entities/ob_boarding_verify_otp_entity.dart';
import 'package:xplor/features/on_boarding/domain/entities/on_boarding_assign_role_entity.dart';
import 'package:xplor/features/on_boarding/domain/entities/on_boarding_send_otp_entity.dart';
import 'package:xplor/features/on_boarding/domain/entities/on_boarding_user_role_entity.dart';
import 'package:xplor/features/on_boarding/domain/repository/on_boarding_repository.dart';
import 'package:xplor/features/on_boarding/domain/usecase/on_boarding_usecase.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  group('OnBoardingUseCase', () {
    late OnBoardingUseCase onBoardingUseCase;
    late MockOnBoardingRepository mockOnBoardingRepository;

    setUp(() {
      mockOnBoardingRepository = MockOnBoardingRepository();
      GetIt.I.registerSingleton<OnBoardingRepository>(mockOnBoardingRepository);
      onBoardingUseCase = OnBoardingUseCase(repository: mockOnBoardingRepository);
    });

    tearDown(() {
      GetIt.I.unregister<OnBoardingRepository>();
    });

    OnBoardingSendOtpEntity entity =
        OnBoardingSendOtpEntity(phoneNumber: '+918323334343');

    OnBoardingAssignRoleEntity assignRoleEntity =
        OnBoardingAssignRoleEntity(roleId: 'roleId');

    List<OnBoardingUserRoleEntity> userRoles = [
      OnBoardingUserRoleEntity(
        id: '1',
        title: 'Admin',
        description: 'admin',
        createdAt: '2:00 AM',
        imageUrl: 'assets/image.png',
        type: 'Admin',
        updatedAt: '12:00pm',
        v: 1,
      ),
      OnBoardingUserRoleEntity(
        id: '2',
        title: 'seeker',
        description: 'seeker',
        createdAt: '2:00 AM',
        imageUrl: 'assets/image.png',
        type: 'Admin',
        updatedAt: '12:00pm',
        v: 1,
      ),
    ];

    test('Usecase Send OTP', () async {
      when(mockOnBoardingRepository.sendOtpOnBoarding(entity))
          .thenAnswer((_) async => '123456');

      // act
      final result = await onBoardingUseCase.call(params: entity);

      // assert
      expect(result, '123456');
    });

    test('Verify OTP on boarding', () async {
      // Create a mock OnBoardingVerifyOtpEntity
      final mockParams = OnBoardingVerifyOtpEntity(otp: '123456', key: 'Key');

      // Mock the behavior of your repository (if necessary)
      when(mockOnBoardingRepository.verifyOtpOnBoarding(mockParams))
          .thenAnswer((_) => Future.value());

      // Call the method and await its completion
      await onBoardingUseCase.verifyOtpOnBoarding(mockParams);

      // Verify that the method completes successfully
      verify(mockOnBoardingRepository.verifyOtpOnBoarding(mockParams));
    });

    test('should throw an error if verification fails', () async {
      // Arrange
      final params = OnBoardingVerifyOtpEntity(otp: '123456');
      // Mock the repository method call to throw an error
      when(mockOnBoardingRepository.verifyOtpOnBoarding(params))
          .thenThrow(Exception('Verification failed'));

      // Act
      // Assert
      expect(
          () => onBoardingUseCase.verifyOtpOnBoarding(params), throwsException);
      verify(mockOnBoardingRepository.verifyOtpOnBoarding(params));
      verifyNoMoreInteractions(mockOnBoardingRepository);
    });

    test('Usecase for assignRoleOnBoarding is success', () async {
      when(mockOnBoardingRepository.assignRoleOnBoarding(assignRoleEntity))
          .thenAnswer((_) async => true);

      // act
      final result =
          await onBoardingUseCase.assignRoleOnBoarding(assignRoleEntity);

      // assert
      expect(result, true);
    });

    test('Usecase for assignRoleOnBoarding is failed', () async {
      when(mockOnBoardingRepository.assignRoleOnBoarding(assignRoleEntity))
          .thenAnswer((_) async => false);

      // act
      final result =
          await onBoardingUseCase.assignRoleOnBoarding(assignRoleEntity);

      // assert
      expect(result, false);
    });

    test('Usecase for updateUserKycOnBoarding is success', () async {
      when(mockOnBoardingRepository.updateUserKycOnBoarding())
          .thenAnswer((_) async => true);

      // act
      final result = await onBoardingUseCase.updateUserKycOnBoarding();

      // assert
      expect(result, true);
    });

    test('Usecase for updateUserKycOnBoarding is failed', () async {
      when(mockOnBoardingRepository.updateUserKycOnBoarding())
          .thenAnswer((_) async => false);

      // act
      final result = await onBoardingUseCase.updateUserKycOnBoarding();

      // assert
      expect(result, false);
    });

    test('Usecase for getUserRolesOnBoarding', () async {
      when(mockOnBoardingRepository.getUserRolesOnBoarding())
          .thenAnswer((_) async => userRoles);

      // act
      final result = await onBoardingUseCase.getUserRolesOnBoarding();

      // assert
      expect(result, userRoles);
    });

    test('Usecase for getUserJourney', () async {
      // Create a mock OnBoardingVerifyOtpEntity
      // Mock the behavior of your repository (if necessary)
      when(mockOnBoardingRepository.getUserJourney())
          .thenAnswer((_) => Future.value());

      // Call the method and await its completion
      await onBoardingUseCase.getUserJourney();

      // Verify that the method completes successfully
      verify(mockOnBoardingRepository.getUserJourney());
    });
  });
}
