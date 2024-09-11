import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../../utils/app_utils/app_utils.dart';
import '../../../../utils/widgets/loading_animation.dart';
import '../../domain/entities/wallet_vc_list_entity.dart';

/// `PDFViewWidget` is a widget for viewing PDF documents and images.
/// It handles loading from a network source and displays a loading animation while the document is being loaded.
class PDFViewWidget extends StatefulWidget {
  /// The document data containing details like file URL and type.
  final DocumentVcData doc;

  const PDFViewWidget({super.key, required this.doc});

  @override
  State<PDFViewWidget> createState() => _PDFViewWidgetState();
}

class _PDFViewWidgetState extends State<PDFViewWidget> {
  // Flag to track the loading state of the document
  bool _isLoading = true;

  WebViewController controller = WebViewController();

  @override
  void initState() {
    super.initState();
    if (widget.doc.fileType == 'text/html') {
      controller = WebViewController()
        ..setBackgroundColor(const Color(0x00000000))
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {
              // Update loading bar.
            },
            onPageStarted: (String url) {
              setState(() {
                _isLoading = true;
              });
            },
            onPageFinished: (String url) {
              setState(() {
                _isLoading = false;
              });
            },
            onWebResourceError: (WebResourceError error) {
              setState(() {
                _isLoading = false;
              });
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
    }
  }

  // This method builds the user interface for the `PDFViewWidget`
  @override
  Widget build(BuildContext context) {
    AppUtils.printLogs('File Url:... ${widget.doc.restrictedUrl}.... Type:..  ${widget.doc.fileType}');
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          if (widget.doc.fileType == 'application/pdf')
            SfPdfViewer.network(
              '${widget.doc.restrictedUrl}?viewType=preview',
              onDocumentLoaded: (document) {
                setState(() {
                  _isLoading = false;
                });
              },
            )
          else if (widget.doc.fileType == 'text/html')
            WebViewWidget(controller: controller)
          else
            Center(
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
          if (_isLoading && (widget.doc.fileType == 'application/pdf' || widget.doc.fileType == 'text/html'))
            const Center(
              child: LoadingAnimation(),
            ),
        ],
      ),
    );
  }

// @override
// void dispose() {
//   super.dispose();
// }
}
