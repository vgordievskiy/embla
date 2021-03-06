import 'dart:async';
import 'dart:convert';
import 'dart:io' show ContentType;
import 'package:embla/src/http/middleware.dart';

import 'input_parsers/input_parser.dart';
export 'input_parsers/input_parser.dart';

import 'input_parsers/json_parser.dart';
import 'input_parsers/raw_parser.dart';
import 'input_parsers/multi_part_parser.dart';
import 'input_parsers/url_encoded_parser.dart';

export 'input_parsers/json_parser.dart';
export 'input_parsers/raw_parser.dart';
export 'input_parsers/multi_part_parser.dart';
export 'input_parsers/url_encoded_parser.dart';

export 'package:http_server/src/http_body.dart'
  show HttpBodyFileUpload, HttpBody;

class InputParserMiddleware extends Middleware {
  final RawInputParser _raw = new RawInputParser();
  final List<InputParser> _parsers = [
    new UrlEncodedInputParser(),
    new JsonInputParser(),
    new MultipartInputParser()
  ];

  @override Future<Response> handle(Request request) async {
    context.container = context.container
      .bind(Input, to: await _getInput(request));

    return await super.handle(request.change(body: null));
  }

  ContentType _contentType(Request request) {
    if (!request.headers.containsKey('Content-Type')) {
      return ContentType.TEXT;
    }
    return ContentType.parse(request.headers['Content-Type']);
  }

  Future<Input> _getInput(Request request) async {
    if (['GET', 'HEAD'].contains(request.method)) {
      return new Input(request.url.queryParameters);
    }

    final contentType = _contentType(request);
    final parser = _parser(contentType);

    return new Input(await parser.parse(request.read(),
                                        request.encoding ?? UTF8,
                                        request));
  }

  InputParser _parser(ContentType contentType) {
    return _parsers.firstWhere((InputParser el)
      => el.mimeType == contentType.mimeType, orElse: () => _raw);
  }
}
