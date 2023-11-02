import 'package:http_interceptor/http_interceptor.dart';
import 'package:mobile_solar_mp/config/http/http_interceptor.dart';

class HttpClient {
  static final http = InterceptedClient.build(
    interceptors: [HttpInterceptor()],
  );
}
