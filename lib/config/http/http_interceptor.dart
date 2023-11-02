import 'package:http_interceptor/http_interceptor.dart';
import 'package:mobile_solar_mp/utils/shared_preferences.dart';

class HttpInterceptor implements InterceptorContract {
  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    String token = SharedPreferencesUtils.getAccessToken().toString();
    data.headers['Content-Type'] = 'application/json';
    data.headers['Authorization'] = 'Bearer $token';
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    if (data.statusCode == 401) {
      // handle unauthorized request
    }
    return data;
  }
}
