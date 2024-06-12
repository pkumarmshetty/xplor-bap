import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:xplor/utils/widgets/loading_animation.dart';

import '../../domain/entities/wallet_vc_list_entity.dart';

class PDFViewWidget extends StatefulWidget {
  final DocumentVcData doc;

  const PDFViewWidget({super.key, required this.doc});

  @override
  State<PDFViewWidget> createState() => _PDFViewWidgetState();
}

class _PDFViewWidgetState extends State<PDFViewWidget> {
  bool _isLoading = true;

  //WebViewController controller = WebViewController();

  /* @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {
            _isLoading = false;
            setState(() {});
          },
          onWebResourceError: (WebResourceError error) {
            _isLoading = false;
            setState(() {});
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.doc.restrictedUrl!));
  }*/

  /*@override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print('test... ${widget.doc.restrictedUrl!}');
    }
    return Scaffold(
        appBar: AppBar(),
        body: Stack(
          children: [
            widget.doc.fileType == 'application/pdf'
                ? SfPdfViewer.network(
                    '${widget.doc.restrictedUrl}?viewType=preview',
                  )
                : Image.network('${widget.doc.restrictedUrl}?viewType=preview'),
            if (_isLoading) const LoadingAnimation(),
          ],
        ));
  }*/

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print('testerrrr.... ${widget.doc.restrictedUrl}?viewType=preview');
    }
    return Scaffold(
      appBar: AppBar(),
      body: Stack(children: [
        widget.doc.fileType == 'application/pdf'
            ? SfPdfViewer.network(
                '${widget.doc.restrictedUrl}?viewType=preview',
                onDocumentLoaded: (document) {
                  setState(() {
                    _isLoading = false;
                  });
                },
              )
            : Center(
                child: CachedNetworkImage(
                  alignment: Alignment.topCenter,
                  filterQuality: FilterQuality.high,
                  imageUrl: '${widget.doc.restrictedUrl}?viewType=preview',
                  placeholder: (context, url) => const Center(
                    child: LoadingAnimation(),
                  ),
                  errorWidget: (context, url, error) => GestureDetector(
                    onTap: () {
                      setState(() {});
                    },
                    child: const Icon(Icons.error),
                  ),
                ),
              ),
        if (_isLoading && widget.doc.fileType == 'application/pdf') const LoadingAnimation(),
      ]),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
