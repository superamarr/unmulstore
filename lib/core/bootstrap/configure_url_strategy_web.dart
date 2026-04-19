import 'package:flutter_web_plugins/url_strategy.dart';

/// Uses path URLs instead of `#/` to avoid History/hash bugs on Flutter web.
void configureUrlStrategyForWeb() {
  usePathUrlStrategy();
}
