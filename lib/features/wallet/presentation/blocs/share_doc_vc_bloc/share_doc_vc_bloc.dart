import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/wallet_vc_list_entity.dart';
import '../../../../../utils/app_utils/app_utils.dart';
import '../../../../../const/local_storage/shared_preferences_helper.dart';
import '../../../../../core/dependency_injection.dart';
import '../../../domain/usecase/wallet_usecase.dart';

part 'share_doc_vc_event.dart';

part 'share_doc_vc_state.dart';

/// BLoC for managing the state related to sharing documents to the wallet.
class SharedDocVcBloc extends Bloc<SharedDocVcEvent, SharedDocVcState> {
  WalletUseCase walletUseCase;
  String validity = '1';
  int customDays = 0;
  bool viewOnce = false;

  SharedDocVcBloc({required this.walletUseCase}) : super(ShareDocVcInitial()) {
    on<SharedDocVcInitialEvent>(_onAddDocumentInitial);
    on<ShareDocVcUpdatedEvent>(_handleUpdateEvent);
    on<ShareVcSubmittedEvent>(_handleSubmitEvent);
    on<ShareDocumentsEvent>(_handleShowSharedDocumentsEvent);
    on<PinVerifiedEvent>(_handlePinVerifiedEvent);
  }

  /// Resets the state and emits [AddDocumentsInitialState].
  Future<void> _onAddDocumentInitial(SharedDocVcInitialEvent event, Emitter<SharedDocVcState> emit) async {
    emit(ShareDocVcInitial());
  }

  /// Emits [ShareDocumentsUpdatedState] to indicate document sharing event.
  _handleSubmitEvent(ShareVcSubmittedEvent event, Emitter<SharedDocVcState> emit) async {
    try {
      if (state is ShareDocumentsUpdatedState) {
        emit((state as ShareDocumentsUpdatedState).copyWith(state: ShareState.loading));
      }
      AppUtils.printLogs('doc submit event ');
      sl<SharedPreferencesHelper>().setBoolean(PrefConstKeys.isSharedByScholarship, false);
      await walletUseCase.sharedWalletVcData(event.vcIds, event.request);

      emit((state as ShareDocumentsUpdatedState).copyWith(state: ShareState.success));
    } catch (e) {
      emit((state as ShareDocumentsUpdatedState)
          .copyWith(state: ShareState.failure, errorMessage: AppUtils.getErrorMessage(e.toString())));
    }
  }

  /// Handles document sharing event and updates state accordingly.
  _handleUpdateEvent(ShareDocVcUpdatedEvent event, Emitter<SharedDocVcState> emit) async {
    switch (event.validity) {
      case Validity.oneDay:
        {
          validity = "1";
          viewOnce = false;
        }
      case Validity.once:
        {
          validity = "1";
          viewOnce = true;
        }
      case Validity.threeDays:
        {
          validity = "3";
          viewOnce = false;
        }
      default:
        {
          viewOnce = false;
        }
    }

    if (state is ShareDocVcInitial) {
      emit(ShareDocumentsUpdatedState(
          validity: event.validity, inputText: event.remarks, shareState: ShareState.initial));
    } else {
      emit((state as ShareDocumentsUpdatedState).copyWith(validity: event.validity, inputText: event.remarks));
    }
  }

  /// Handles Share Documents event and updates state accordingly.
  FutureOr<void> _handleShowSharedDocumentsEvent(ShareDocumentsEvent event, Emitter<SharedDocVcState> emit) {
    emit(ShareDocumentsUpdatedState(
        validity: Validity.once,
        inputText: '',
        selectedDocs: event.selectedDocs,
        documentVcData: event.documentVcData,
        shareState: ShareState.initial));
  }

  /// Handles Pin Verified event and updates state accordingly.
  FutureOr<void> _handlePinVerifiedEvent(PinVerifiedEvent event, Emitter<SharedDocVcState> emit) {
    if (state is ShareDocumentsUpdatedState) {
      List<String> vc = [];
      if ((state as ShareDocumentsUpdatedState).documentVcData != null) {
        AppUtils.printLogs('pin verified success data ${(state as ShareDocumentsUpdatedState).documentVcData!.name}');
        vc.add((state as ShareDocumentsUpdatedState).documentVcData!.id);
      } else {
        AppUtils.printLogs(
            'pin verified success list data ${(state as ShareDocumentsUpdatedState).selectedDocs?[0].name}');
        for (DocumentVcData selectedDocs in (state as ShareDocumentsUpdatedState).selectedDocs!) {
          vc.add(selectedDocs.id);
        }
      }

      String sharedBy = "Self Shared";

      bool isValid = sl<SharedPreferencesHelper>().getBoolean(PrefConstKeys.isSharedByScholarship);

      if (isValid) {
        sharedBy = sl<SharedPreferencesHelper>().getString(
          PrefConstKeys.sharedBy,
        );
      }

      var body = json.encode({
        "certificateType": (state as ShareDocumentsUpdatedState).documentVcData != null
            ? (state as ShareDocumentsUpdatedState).documentVcData!.category
            : (state as ShareDocumentsUpdatedState).selectedDocs![0].category,
        "remarks": (state as ShareDocumentsUpdatedState).inputText,
        "sharedWithEntity": sharedBy,
        "restrictions": {
          /*"expiresIn": getHoursAccordingToDaySelection(int.parse(validity)),
          "viewOnce": int.parse(validity) == 1 ? true : false*/
          "expiresIn": getHoursAccordingToDaySelection(viewOnce),
          "viewOnce": viewOnce
        }
      });
      AppUtils.printLogs(body);
      add(ShareVcSubmittedEvent(vcIds: vc, request: body));
    }
  }

  /// Get hours according to day selection
  int getHoursAccordingToDaySelection(bool viewOnce) {
    int expiresIn = int.parse(validity);
    if (expiresIn == 1 && viewOnce) {
      return 7 * 24;
    } else if (expiresIn == 1 && !viewOnce) {
      return expiresIn * 24;
    } else if (expiresIn == 2 || expiresIn == 3) {
      return expiresIn * 24;
    } else {
      return customDays * 24;
    }
  }
}
