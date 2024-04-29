import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:xplor/const/app_state.dart';
import 'package:xplor/features/on_boarding/domain/entities/on_boarding_assign_role_entity.dart';
import 'package:xplor/features/on_boarding/domain/entities/on_boarding_user_role_entity.dart';
import 'package:xplor/features/on_boarding/presentation/blocs/select_role_bloc/select_role_bloc.dart';
import 'package:xplor/features/on_boarding/presentation/blocs/select_role_bloc/select_role_event.dart';
import 'package:xplor/features/on_boarding/presentation/blocs/select_role_bloc/select_role_state.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  group('SelectRoleBloc', () {
    late SelectRoleBloc selectRoleBloc;
    late MockOnBoardingUseCase mockOnBoardingUseCase;

    setUp(() {
      mockOnBoardingUseCase = MockOnBoardingUseCase();
      selectRoleBloc = SelectRoleBloc(useCase: mockOnBoardingUseCase);
    });

    tearDown(() {
      selectRoleBloc.close();
    });

    test('initial state is SelectRoleInitial', () {
      expect(selectRoleBloc.state, equals(SelectRoleInitial()));
    });

    OnBoardingAssignRoleEntity assignRoleOnBoarding = OnBoardingAssignRoleEntity(roleId: "asddasdsa");

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

    blocTest<SelectRoleBloc, SelectRoleState>(
      'emits [SelectRoleLoadedState] when GetUserRolesEvent is added',
      build: () {
        when(mockOnBoardingUseCase.getUserRolesOnBoarding()).thenAnswer((_) async => userRoles);
        return selectRoleBloc;
      },
      act: (bloc) => bloc.add(const GetUserRolesEvent()),
      expect: () => [
        const SelectRoleLoadingState(status: AppPageStatus.loading),
        SelectRoleLoadedState(userRoles: userRoles, status: AppPageStatus.success),
      ],
    );

    blocTest<SelectRoleBloc, SelectRoleState>(
      'emits [SelectRoleLoadingState, SelectRoleErrorState] '
      'when GetUserRolesEvent fails',
      build: () => selectRoleBloc,
      act: (bloc) {
        when(mockOnBoardingUseCase.getUserRolesOnBoarding())
            .thenThrow(Exception()); // Mocking the function to throw an exception
        bloc.add(const GetUserRolesEvent());
      },
      expect: () => [
        const SelectRoleLoadingState(status: AppPageStatus.loading),
        const SelectRoleErrorState(
          status: AppPageStatus.finish,
          errorMessage: 'Exception', // Update with the expected error message
        ),
      ],
    );

    blocTest<SelectRoleBloc, SelectRoleState>(
        'emits [SelectRoleLoadingState, SelectRoleNavigationState] '
        'when AssignRoleEvent is success',
        build: () {
          when(mockOnBoardingUseCase.assignRoleOnBoarding(assignRoleOnBoarding)).thenAnswer((_) => Future.value(true));
          return selectRoleBloc;
        },
        act: (bloc) {
          bloc.add(AssignRoleEvent(entity: assignRoleOnBoarding));
        },
        expect: () => [SelectRoleNavigationState()],
        verify: (bloc) {
          verify(mockOnBoardingUseCase.assignRoleOnBoarding(assignRoleOnBoarding));
        });

    blocTest<SelectRoleBloc, SelectRoleState>(
        'emits [SelectRoleLoadingState, SelectRoleNavigationState] '
        'when AssignRoleEvent is failed',
        build: () {
          when(mockOnBoardingUseCase.assignRoleOnBoarding(assignRoleOnBoarding))
              .thenThrow(Exception('An unexpected error occurred'));
          return selectRoleBloc;
        },
        act: (bloc) {
          bloc.add(AssignRoleEvent(entity: assignRoleOnBoarding));
        },
        expect: () => [
              SelectRoleErrorState(
                  status: AppPageStatus.finish, errorMessage: Exception('An unexpected error occurred').toString()),
            ],
        verify: (bloc) {
          verify(mockOnBoardingUseCase.assignRoleOnBoarding(assignRoleOnBoarding));
        });

    blocTest<SelectRoleBloc, SelectRoleState>(
        'emits [SelectRoleLoadingState, SelectRoleNavigationState] '
        'when AssignRoleEvent is success',
        build: () {
          when(mockOnBoardingUseCase.assignRoleOnBoarding(assignRoleOnBoarding)).thenAnswer((_) => Future.value(true));
          return selectRoleBloc;
        },
        act: (bloc) {
          bloc.add(AssignRoleEvent(entity: assignRoleOnBoarding));
        },
        expect: () => [SelectRoleNavigationState()],
        verify: (bloc) {
          verify(mockOnBoardingUseCase.assignRoleOnBoarding(assignRoleOnBoarding));
        });
  });
}
