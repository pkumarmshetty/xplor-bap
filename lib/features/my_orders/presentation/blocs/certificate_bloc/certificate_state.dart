// download_state.dart

/// Abstract class representing different states of a download operation.
abstract class CertificateState {}

/// Initial state indicating the download has not started yet.
class DownloadInitial extends CertificateState {}

class CertificateInitialState extends CertificateState {}

/// State indicating that the download is in progress, with a specific progress value.
class DownloadInProgress extends CertificateState {
  final double progress;

  DownloadInProgress(this.progress);
}

/// State indicating that the download completed successfully, with the downloaded file path.
class DownloadSuccess extends CertificateState {
  final String filePath;

  DownloadSuccess(this.filePath);
}

/// State indicating that the download failed, with an error message.
class DownloadFailure extends CertificateState {
  final String error;

  DownloadFailure(this.error);
}

final class UploadDocumentLoadingState extends CertificateState {}

final class DocumentUploadSuccessState extends CertificateState {}

final class DocumentUploadFailureState extends CertificateState {
  final String error;

  DocumentUploadFailureState(this.error);
}
