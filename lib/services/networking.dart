import 'package:test_clima_flutter/services/location.dart';
import 'package:http/http.dart';
import 'package:flutter/foundation.dart';

class Networking{
  String appID = "07dcaf0e3dccdd9208f0e017e0699051";
  double temp=0;
  String data='',city='';
  int id=0;

  Future <String>getData (city)async {
    Location location = new Location();
    await location.getLocation();
    double lat = location.lat;
    double lon = location.lon;


    Uri url = Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$appID&units=metric");
    Response response = await get(url);
    data = response.body;
    if (response.statusCode == 200) {
      return data;
    } else {
      return "ERROR";
    }
  }
  Future<String> GetCity(String newCity) async {
    Uri url = Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?q=$newCity&appid=$appID&units=metric");
    Response response = await get(url);
    data = response.body;
    if (response.statusCode == 200) {
      return data;
    } else if (response.statusCode == 400) {
      throw ErrorDescription("Cannot find data in city");
    } else if (response.statusCode == 404) {
      throw ErrorDescription("Cannot find data in city");
    } else {
      throw ErrorDescription("Cannot find data in city");
    }
  }

}