import 'dart:io';
import 'dart:convert';

void main() async {
  final file = File('assets/icons/logo.svg');
  if (!await file.exists()) {
    print('File not found');
    return;
  }
  final content = await file.readAsString();
  final base64String = content.split('base64,')[1].split('"')[0];
  final bytes = base64Decode(base64String);
  await File('assets/icons/logo.png').writeAsBytes(bytes);
  print('Logo extracted to assets/icons/logo.png');
}
