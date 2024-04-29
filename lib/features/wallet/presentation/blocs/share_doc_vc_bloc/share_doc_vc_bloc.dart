import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/usecase/wallet_usecase.dart';

part 'share_doc_vc_event.dart';

part 'share_doc_vc_state.dart';

class SharedDocVcBloc extends Bloc<SharedDocVcEvent, SharedDocVcState> {
  WalletUseCase walletUseCase;

  SharedDocVcBloc({required this.walletUseCase}) : super(ShareDocVcInitial()) {
    on<SharedDocVcInitialEvent>(_onAddDocumentInitial);
    on<ShareDocVcUpdatedEvent>(_handleUpdateEvent);
    on<ShareVcSubmittedEvent>(_handleSubmitEvent);
  }

  Future<void> _onAddDocumentInitial(SharedDocVcInitialEvent event, Emitter<SharedDocVcState> emit) async {
    emit(ShareDocVcInitial());
  }

  _handleSubmitEvent(ShareVcSubmittedEvent event, Emitter<SharedDocVcState> emit) async {
    try {
      emit(SharedLoaderState());
      await walletUseCase.sharedWalletVcData(event.vcIds, event.request);

      emit(SharedSuccessState());
    } catch (e) {
      emit(SharedFailureState(message: e.toString()));
    }
  }

  _handleUpdateEvent(ShareDocVcUpdatedEvent event, Emitter<SharedDocVcState> emit) async {
    if (state is ShareDocVcInitial) {
      emit(ShareDialogUpdatedState(selectedItem: event.selectedItem ?? 1, inputText: event.remarks ?? ''));
    } else {
      emit((state as ShareDialogUpdatedState).copyWith(selectedItem: event.selectedItem, text: event.remarks));
    }
  }
}
