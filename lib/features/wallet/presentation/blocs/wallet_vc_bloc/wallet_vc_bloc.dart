import 'dart:async';
import 'package:bloc/bloc.dart';
import '../../../domain/entities/wallet_vc_list_entity.dart';
import '../../../domain/usecase/wallet_usecase.dart';
import 'wallet_vc_event.dart';
import 'wallet_vc_state.dart';

/// Enum for flow type.
enum FlowType { course, document, consent }

/// Bloc for wallet vc.
class WalletVcBloc extends Bloc<WalletVcEvent, WalletVcState> {
  WalletUseCase useCase;

  List<DocumentVcData> documentsList = [];
  List<DocumentVcData> selectedDocuments = [];
  List<DocumentVcData> searchedDocumentsList = [];
  FlowType flowType = FlowType.document;

  WalletVcBloc({required this.useCase}) : super(WalletVcInitial()) {
    on<GetWalletVcEvent>(_onGetUserWalletVc);
    on<WalletDocumentSelectedEvent>(_onDocumentSelected);
    on<WalletDelVcEvent>(_walletDeletedEvents);
    on<WalletDocumentsUnselectedEvent>(_onDocumentsUnselectedEvents);
    on<WalletSearchDocumentsEvent>(_onDocumentsSearchEvent);
  }

  /// Method to  get wallet vc.
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

  /// Method to select documents.
  Future<void> _onDocumentSelected(
    WalletDocumentSelectedEvent event,
    Emitter<WalletVcState> emit,
  ) async {
    if (state is WalletVcSuccessState ||
        state is WalletDocumentSelectedState ||
        state is WalletDocumentUnSelectedState) {
      documentsList[event.position] = documentsList[event.position].copyWith(isSelected: event.isSelected);
      selectedDocuments = [];
      for (DocumentVcData i in documentsList) {
        if (i.isSelected ?? false) {
          selectedDocuments.add(i);
        }
      }
      emit(WalletDocumentSelectedState(docs: List.from(documentsList), selectedDocs: List.from(selectedDocuments)));
    } else if (state is WalletDocumentsSearchedState) {
      searchedDocumentsList[event.position] =
          searchedDocumentsList[event.position].copyWith(isSelected: event.isSelected);
      documentsList = documentsList.map((item) {
        if (item.id == event.id) {
          return item.copyWith(isSelected: event.isSelected); // Update the item
        }
        return item; // Return unchanged item if condition is not met
      }).toList();
      selectedDocuments = [];
      List<DocumentVcData> selectedDocs = [];
      for (DocumentVcData i in documentsList) {
        if (i.isSelected ?? false) {
          selectedDocuments.add(i);
        }
      }
      for (DocumentVcData i in searchedDocumentsList) {
        if (i.isSelected ?? false) {
          selectedDocs.add(i);
        }
      }
      emit(WalletDocumentsSearchedState(
          searchedDocuments: List.from(searchedDocumentsList), selectedDocuments: selectedDocs));
    }
  }

  /// Method to delete wallet vc.
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

  /// Method to unselect documents.
  Future<void> _onDocumentsUnselectedEvents(
    WalletDocumentsUnselectedEvent event,
    Emitter<WalletVcState> emit,
  ) async {
    if (state is WalletDocumentSelectedState) {
      documentsList = documentsList.map((doc) => doc.copyWith(isSelected: false)).toList();
      selectedDocuments = [];
      emit(WalletDocumentUnSelectedState(vcData: documentsList));
    }
  }

  /// Method to search documents.
  FutureOr<void> _onDocumentsSearchEvent(WalletSearchDocumentsEvent event, Emitter<WalletVcState> emit) {
    if (event.documentsName == '') {
      if (selectedDocuments.isNotEmpty) {
        emit(WalletDocumentSelectedState(docs: documentsList, selectedDocs: selectedDocuments));
      } else {
        emit(WalletVcSuccessState(vcData: documentsList));
      }
    } else {
      searchedDocumentsList = [];
      for (DocumentVcData i in documentsList) {
        if (i.name.toLowerCase().contains(event.documentsName.toLowerCase())) {
          searchedDocumentsList.add(i);
        }
      }
      bool isSelected = false;
      for (var element in searchedDocumentsList) {
        if (element.isSelected ?? false) {
          isSelected = true;
          break;
        }
      }
      emit(WalletDocumentsSearchedState(
          searchedDocuments: List.from(searchedDocumentsList), selectedDocuments: isSelected ? selectedDocuments : []));
    }
  }
}
