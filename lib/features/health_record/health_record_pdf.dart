import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class HealthRecordPdfScreen extends StatefulWidget {
  final String pdfUrl;

  const HealthRecordPdfScreen({Key? key, required this.pdfUrl}) : super(key: key);

  @override
  _HealthRecordPdfScreenState createState() => _HealthRecordPdfScreenState();
}

class _HealthRecordPdfScreenState extends State<HealthRecordPdfScreen> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey<SfPdfViewerState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Record PDF'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark),
            onPressed: () {
              _pdfViewerKey.currentState?.openBookmarkView();
            },
          ),
        ],
      ),
      body: SfPdfViewer.network(
        widget.pdfUrl,
        key: _pdfViewerKey,
      ),
    );
  }
}
