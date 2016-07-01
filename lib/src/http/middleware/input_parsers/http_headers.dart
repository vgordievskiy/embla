import 'dart:io';

class HttpHeadersImpl implements HttpHeaders {
  final Map<String, String> headers;
  ContentType _contentType;

  HttpHeadersImpl(this.headers, this._contentType);

  @override
  List<String> operator [](String name) {
    return headers[name].split(";");
  }

  @override
  ContentType get contentType => _contentType;

  @override
  void forEach(void f(String name, List<String> values)) {
    headers.forEach((k, v) => f(k, v.split(";")));
  }

  @override
  String value(String name) {
    return headers[name];
  }

  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
