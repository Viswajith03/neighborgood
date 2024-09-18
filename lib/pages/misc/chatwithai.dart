import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class VoiceflowWidget extends StatefulWidget {
  const VoiceflowWidget({super.key});

  @override
  State<VoiceflowWidget> createState() => _VoiceflowWidgetState();
}

class _VoiceflowWidgetState extends State<VoiceflowWidget> {
  late WebViewController _controller;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();

    // Platform-specific parameters
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      // iOS/macOS specific
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      // Android specific
      params = const PlatformWebViewControllerCreationParams();
    }

    // Create the WebViewController with platform-specific params
    _controller = WebViewController.fromPlatformCreationParams(params)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {
            setState(() {
              _hasError = false;
            });
          },
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {
            setState(() {
              _hasError = true;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${error.description}')),
            );
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://neighbourgoodbot.netlify.app/'));

    // Android-specific configurations
    if (_controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (_controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat With an AI')),
      body: _hasError
          ? const Center(child: Text('Failed to load content.'))
          : WebViewWidget(controller: _controller),
    );
  }
}
