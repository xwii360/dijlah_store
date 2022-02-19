import 'dart:convert';

import 'package:dijlah_store_ibtechiq/common/constant.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future refundRequest(id,reason) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var userId = preferences.getString("userId");
  var userToken = preferences.getString("access_token");
  if((userToken!=null && userId!=null) )  {
    String url = MAIN_URL + "refund";
    Map<String, String> body = {
      "user_id": userId,
      "order_id":id.toString(),
      "reason": reason.toString(),
    };

    Response response = await post(Uri.parse(url), body: body, headers: {"Authorization": "Bearer " + userToken});
    print(response.body);
    var data = jsonDecode(response.body);
    return data['message'];
  }
}

Future<bool> checkIsOrderRefunded(id) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var userId = preferences.getString("userId");
  var userToken = preferences.getString("access_token");
  if((userToken!=null && userId!=null) ) {
    String url = MAIN_URL + "isRefunded";
    Map<String, String> body = {
      "user_id": userId,
      "order_id": id.toString()
    };
    Response response = await post(
        Uri.parse(url),
      body: body,
        headers: {"Authorization": "Bearer " + userToken}
    );
    print(response.body);
    var data = jsonDecode(response.body);
   return data['is_in_Refunded'];

  }
}

Future cancelledRequest(id) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var userToken = preferences.getString("access_token");
  if ((userToken != null ) ||
      (userToken != '' ) ||
      (userToken.isNotEmpty )) {
    String url = MAIN_URL + "cancelled_order";
    Map<String, String> body = {
      "order_id": id.toString(),
      "status": "cancelled",
    };

    Response response = await post(
        Uri.parse(url), body: body, headers: {"Authorization": "Bearer " + userToken});
    print(response.body);
    var data = jsonDecode(response.body);
    return data['message'];
  }
}