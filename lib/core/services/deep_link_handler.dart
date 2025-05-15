import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:reown_appkit/modal/i_appkit_modal_impl.dart';

class DeepLinkHandler {
  static const _methodChannel = MethodChannel('com.example.anime_nexa/methods');
  static const _eventChannel = EventChannel('com.example.anime_nexa/events');
  static final waiting = ValueNotifier<bool>(false);
  static late IReownAppKitModal _appKitModal;

  static void initListener() {
    if (kIsWeb) return;
    try {
      _eventChannel.receiveBroadcastStream().listen(_onLink, onError: _onError);
    } catch (e) {
      debugPrint('[AnimeNexa] initListener error: $e');
    }
  }

  static void init(IReownAppKitModal appKitModal) {
    if (kIsWeb) return;
    _appKitModal = appKitModal;
  }

  static void checkInitialLink() async {
    if (kIsWeb) return;
    try {
      await _methodChannel.invokeMethod('initialLink');
    } catch (e) {
      debugPrint('[AnimeNexa] checkInitialLink error: $e');
    }
  }

  static void _onLink(dynamic link) async {
    debugPrint('[AnimeNexa] Received deep link: $link');
    if (link == null) return;
    final handled = await _appKitModal.dispatchEnvelope(link);
    if (!handled) {
      debugPrint('[AnimeNexa] Link not handled by AppKit');
    }
  }

  static void _onError(dynamic error) {
    debugPrint('[AnimeNexa] Deep link error: $error');
    waiting.value = false;
  }
}
