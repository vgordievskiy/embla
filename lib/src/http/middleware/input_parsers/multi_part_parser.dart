import 'dart:convert';
import 'dart:async';
import 'dart:io' show ContentType, HttpHeaders;
import 'package:embla/http.dart';
import 'package:http_server/src/http_body_impl.dart';
import 'package:http_server/src/http_body.dart';

import 'input_parser.dart';
import 'http_headers.dart';

class MultipartInputParser extends InputParser {
  @override
  Future parse(Stream<List<int>> body, Encoding encoding, [Request request]) async {
    HttpBody parsedBody = await HttpBodyHandlerImpl.process(body,
      new HttpHeadersImpl(request.headers,
        ContentType.parse(request.headers['content-type'])), UTF8);
    return parsedBody.body;
  }

  @override
  String get mimeType => 'multipart/form-data';
}
