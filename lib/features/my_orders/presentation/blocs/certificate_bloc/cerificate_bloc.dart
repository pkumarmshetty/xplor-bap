// download_bloc.dart

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

import 'certificate_event.dart';
import 'certificate_state.dart';

class DownloadBloc extends Bloc<DownloadEvent, DownloadState> {
  DownloadBloc() : super(DownloadInitial()) {
    on<StartDownload>(_downloadCertificate);
    on<UpdateProgress>(_updateProgress);
  }

  Future<FutureOr<void>> _downloadCertificate(StartDownload event, Emitter<DownloadState> emit) async {
    Dio dio = Dio();
    try {
      /*if (await Permission.storage.request().isGranted) {

      } else {
        _requestStoragePermission();
        //emit(DownloadFailure('Permission denied'));
      }*/
      /*if (!await launchUrl(Uri.parse(event.url))) {
        throw Exception(
            'Could not launch ${event.url}');
      }*/
      var dir = await getExternalStorageDirectory();
      String filePath = '${dir?.path}/${event.fileName}';

      await dio.download(
        event.url,
        filePath,
        onReceiveProgress: (received, total) {
          /*debugPrint(double.parse((received / total).toStringAsFixed(2) * 100)
              .toString());*/
          if (total != -1) {
            var progress = double.parse((received / total).toStringAsFixed(2));
            add(UpdateProgress(progress));
          }
        },
      );

      emit(DownloadSuccess(filePath));
    } catch (e) {
      emit(DownloadFailure(e.toString()));
    }
  }

  FutureOr<void> _updateProgress(UpdateProgress event, Emitter<DownloadState> emit) {
    emit(DownloadInProgress(event.progress));
  }
}
