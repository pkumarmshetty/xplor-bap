// download_state.dart

abstract class DownloadState {}

class DownloadInitial extends DownloadState {}

class DownloadInProgress extends DownloadState {
  final double progress;

  DownloadInProgress(this.progress);
}

class DownloadSuccess extends DownloadState {
  final String filePath;

  DownloadSuccess(this.filePath);
}

class DownloadFailure extends DownloadState {
  final String error;

  DownloadFailure(this.error);
}
