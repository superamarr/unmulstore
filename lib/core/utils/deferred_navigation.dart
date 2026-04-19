import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

/// On web, routes after async work can hit a race where [History.pushState]
/// runs before the browser history shim is ready. One frame delay fixes it.
Future<void> goDeferred(
  BuildContext context,
  String location, {
  Object? extra,
}) async {
  if (kIsWeb) {
    await Future<void>.delayed(Duration.zero);
  }
  if (!context.mounted) return;
  if (extra != null) {
    context.go(location, extra: extra);
  } else {
    context.go(location);
  }
}
