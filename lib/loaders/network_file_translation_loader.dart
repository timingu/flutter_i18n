import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'file_translation_loader.dart';

/// Loads translations from the remote resource
class NetworkFileTranslationLoader extends FileTranslationLoader {
  final Uri baseUri;

  NetworkFileTranslationLoader(
      {required this.baseUri,
        forcedLocale,
        fallbackFile = "en",
        separator = "_",
        useCountryCode = false,
        useScriptCode = false,
        decodeStrategies})
      : super(
      fallbackFile: fallbackFile,
      separator: separator,
      useCountryCode: useCountryCode,
      forcedLocale: forcedLocale,
      decodeStrategies: decodeStrategies);

  /// Load the file using an http client
  @override
  Future<String> loadString(final String fileName, final String extension) async {
    final resolvedUri = resolveUri(fileName, extension);
    final result = await http.get(resolvedUri);
    return utf8.decode(result.bodyBytes);
  }

  Uri resolveUri(final String fileName, final String extension) {
    final fileToFind = '$fileName.$extension';
    return this.baseUri.replace(path: '${this.baseUri.path}/$fileToFind');
  }
}
