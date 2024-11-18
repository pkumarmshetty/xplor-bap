// download_event.dart

import 'package:xplor/features/my_orders/domain/entities/my_orders_entity.dart';

/// Abstract class representing different events related to download operations.
abstract class CertificateEvent {}

/// Event indicating the start of a download with a specific URL and file name.
class StartDownload extends CertificateEvent {
  final String url;
  final String fileName;

  StartDownload(this.url, this.fileName);
}

/// Event indicating an update in the download progress with a specific progress value.
class UpdateProgress extends CertificateEvent {
  final double progress;

  UpdateProgress(this.progress);
}

class AddCertificateToWallet extends CertificateEvent {
  final String? url;
  final MyOrdersEntity? ordersEntity;
  AddCertificateToWallet(this.url, this.ordersEntity);
}

class MarkDocumentAddToWallet extends CertificateEvent {
  final String? orderId;
  MarkDocumentAddToWallet(this.orderId);
}

class CertificateInitial extends CertificateEvent {}
