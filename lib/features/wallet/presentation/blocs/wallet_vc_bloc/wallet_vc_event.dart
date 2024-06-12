import 'package:equatable/equatable.dart';
import 'package:xplor/features/wallet/domain/entities/wallet_vc_list_entity.dart';

sealed class WalletVcEvent extends Equatable {
  const WalletVcEvent();

  @override
  List<Object> get props => [];
}

class GetWalletVcEvent extends WalletVcEvent {
  const GetWalletVcEvent();
}

class WalletDocumentSelectedEvent extends WalletVcEvent {
  final int position;
  final String id;
  final bool isSelected;

  const WalletDocumentSelectedEvent({
    required this.position,
    required this.id,
    required this.isSelected,
  });
}

class WalletMultipleDocumentsShareEvent extends WalletVcEvent {
  final List<DocumentVcData> docs;

  const WalletMultipleDocumentsShareEvent({
    required this.docs,
  });
}

class WalletSearchDocumentsEvent extends WalletVcEvent {
  final String documentsName;

  const WalletSearchDocumentsEvent({
    required this.documentsName,
  });
}

class WalletMultipleDocumentsDeleteEvent extends WalletVcEvent {
  final List<DocumentVcData> docs;

  const WalletMultipleDocumentsDeleteEvent({
    required this.docs,
  });
}

class WalletDocumentDeleteEvent extends WalletVcEvent {
  final int position;

  const WalletDocumentDeleteEvent({
    required this.position,
  });
}

class WalletDelVcEvent extends WalletVcEvent {
  final List<String> vcIds;

  const WalletDelVcEvent({required this.vcIds});
}

class WalletDocumentsUnselectedEvent extends WalletVcEvent {
  const WalletDocumentsUnselectedEvent();
}
