import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:xplor/features/wallet/presentation/blocs/wallet_bloc/wallet_bloc.dart';
import 'package:xplor/features/wallet/presentation/blocs/wallet_bloc/wallet_state.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockWalletUseCase mockWalletUseCase;
  late WalletDataBloc walletDataBloc;
  const String walletId = "wallet_93348829489-id";

  setUp(() {
    mockWalletUseCase = MockWalletUseCase();
    walletDataBloc = WalletDataBloc(useCase: mockWalletUseCase);
  });

  tearDown(() {
    walletDataBloc.close();
  });

  test('emits [WalletState] when WalletDataBloc is created', () {
    expect(walletDataBloc.state, const WalletState(tabIndex: 0));
  });

  blocTest<WalletDataBloc, WalletState>(
    'emits [WalletState(tabIndex: 0)] when WalletDataBloc is created',
    build: () => walletDataBloc,
    act: (bloc) => bloc.updateWalletTabIndex(index: 0),
    expect: () => [const WalletState(tabIndex: 0)],
  );

  blocTest<WalletDataBloc, WalletState>(
    'emits [WalletState(tabIndex: 1)] when updateWalletTabIndex is called with index 1',
    build: () => walletDataBloc,
    act: (bloc) => bloc.updateWalletTabIndex(index: 1),
    expect: () => [const WalletState(tabIndex: 1)],
  );

  test('getWalletData calls useCase.getWalletId', () async {
    // Arrange
    when(mockWalletUseCase.getWalletId()).thenAnswer((_) async => walletId);

    // Act
    walletDataBloc.getWalletData();

    // Assert
    verify(mockWalletUseCase.getWalletId()).called(1);
  });
}
