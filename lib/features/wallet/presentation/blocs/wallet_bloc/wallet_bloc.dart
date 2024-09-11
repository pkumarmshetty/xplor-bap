import 'package:bloc/bloc.dart';
import '../../../domain/usecase/wallet_usecase.dart';

import 'wallet_state.dart';

/// Bloc for handling user role selection events.
class WalletDataBloc extends Cubit<WalletState> {
  List<String>? selectedFilesTags;
  WalletUseCase useCase;

  WalletDataBloc({
    required this.useCase,
  }) : super(const WalletState(tabIndex: 0));

  /// Method to get the wallet id.
  Future getWalletData() async {
    await useCase.getWalletId();
  }

  /// Method to update the wallet tab index.
  void updateWalletTabIndex({required int index}) {
    emit(state.copyWith(tabIndex: index));
  }
}
