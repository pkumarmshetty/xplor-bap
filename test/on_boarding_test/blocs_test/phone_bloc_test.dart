import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:xplor/features/on_boarding/presentation/blocs/phone_bloc/phone_bloc.dart';

void main() {
  group('PhoneBloc', () {
    late PhoneBloc phoneBloc;

    setUp(() {
      phoneBloc = PhoneBloc();
    });

    tearDown(() {
      phoneBloc.close();
    });

    test('Initial state is PhoneInitial', () {
      expect(phoneBloc.state, PhoneInitial());
    });

    blocTest<PhoneBloc, PhoneState>(
      'emits [PhoneValidState] when CheckPhoneEvent is added with a valid phone number',
      build: () => phoneBloc,
      act: (bloc) => bloc.add(const CheckPhoneEvent(phone: '918234567890')),
      expect: () => [PhoneValidState()],
    );

    blocTest<PhoneBloc, PhoneState>(
      'emits [PhoneInvalidState] when CheckPhoneEvent is added with an invalid phone number',
      build: () => phoneBloc,
      act: (bloc) => bloc.add(const CheckPhoneEvent(phone: '918234567')),
      expect: () => [PhoneInvalidState()],
    );

    blocTest<PhoneBloc, PhoneState>(
      'emits [PhoneSubmittingState] when PhoneSubmitEvent is added',
      build: () => phoneBloc,
      act: (bloc) => bloc.add(const PhoneSubmitEvent(phone: '918234567890')),
      expect: () => [const PhoneSubmittingState(phoneNumber: '918234567890')],
    );
  });
}
