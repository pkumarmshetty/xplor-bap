import 'package:bloc/bloc.dart';
import 'package:xplor/features/wallet/domain/entities/wallet_vc_list_entity.dart';

import '../../../domain/usecase/wallet_usecase.dart';
import 'wallet_vc_event.dart';
import 'wallet_vc_state.dart';

class WalletVcBloc extends Bloc<WalletVcEvent, WalletVcState> {
  WalletUseCase useCase;

  List<DocumentVcData> documentsList = [];
  List<DocumentVcData> selectedDocumentsList = [];

  WalletVcBloc({required this.useCase}) : super(WalletVcInitial()) {
    on<GetWalletVcEvent>(_onGetUserWalletVc);
    on<WalletDocumentSelectedEvent>(_onDocumentSelected);
    on<WalletDelVcEvent>(_walletDeletedEvents);
    on<WalletDocumentsUnselectedEvent>(_onDocumentsUnselectedEvents);
  }

  Future<void> _onGetUserWalletVc(
    GetWalletVcEvent event,
    Emitter<WalletVcState> emit,
  ) async {
    emit(const WalletVcLoadingState());
    await useCase.getWalletId();

    try {
      final vcData = await useCase.getWalletVcData();
      documentsList = vcData;
      emit(WalletVcSuccessState(vcData: vcData));
    } catch (e) {
      emit(WalletVcFailureState(message: e.toString()));
    }
  }

  Future<void> _onDocumentSelected(
    WalletDocumentSelectedEvent event,
    Emitter<WalletVcState> emit,
  ) async {
    documentsList[event.position] = documentsList[event.position].copyWith(isSelected: event.isSelected);

    List<DocumentVcData> selectedDocs = [];
    for (DocumentVcData i in documentsList) {
      if (i.isSelected ?? false) {
        selectedDocs.add(i);
      }
    }
    emit(WalletDocumentSelectedState(docs: List.from(documentsList), selectedDocs: List.from(selectedDocs)));
  }

  Future<void> _walletDeletedEvents(
    WalletDelVcEvent event,
    Emitter<WalletVcState> emit,
  ) async {
    emit(const WalletVcLoadingState());
    try {
      await useCase.deletedDocVcList(event.vcIds);

      //emit(const DelWalletSuccessState());
      add(const GetWalletVcEvent());
    } catch (e) {
      emit(WalletVcFailureState(message: e.toString()));
    }
  }

  Future<void> _onDocumentsUnselectedEvents(
    WalletDocumentsUnselectedEvent event,
    Emitter<WalletVcState> emit,
  ) async {
    if (state is WalletDocumentSelectedState) {
      documentsList = documentsList.map((doc) => doc.copyWith(isSelected: false)).toList();
      emit(WalletDocumentUnSelectedState(vcData: documentsList));
    }
  }
}
