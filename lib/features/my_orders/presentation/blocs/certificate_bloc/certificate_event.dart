// download_event.dart

abstract class DownloadEvent {}

class StartDownload extends DownloadEvent {
  final String url;
  final String fileName;

  StartDownload(this.url, this.fileName);
}

class UpdateProgress extends DownloadEvent {
  final double progress;

  UpdateProgress(this.progress);
}
