import 'package:depd_2024_mvvm/data/app_exception.dart';
import 'package:depd_2024_mvvm/data/network/network_api_services.dart';
import 'package:depd_2024_mvvm/model/city.dart';
import 'package:depd_2024_mvvm/model/costs/calculate.dart';
import 'package:depd_2024_mvvm/model/model.dart';

class HomeRepository {
  final _apiServices = NetworkApiServices();

  Future<List<Province>> fetchProvinceList() async {
    try {
      dynamic response = await _apiServices.getApiResponse('/province');
      List<Province> result = [];

      if (response['rajaongkir']['status']['code'] == 200) {
        result = (response['rajaongkir']['results'] as List)
            .map((e) => Province.fromJson(e))
            .toList();
      }
      return result;
    } catch (e) {
      throw e;
    }
  }

  Future<List<City>> fetchCityList(String provinceId) async {
    try {
      dynamic response = await _apiServices.getApiResponse('/city?province=$provinceId');
      List<City> result = [];
      Map<String, City> uniqueCities = {}; 

      if (response['rajaongkir']['status']['code'] == 200) {
        var cityData = response['rajaongkir']['results'];
        if (cityData is Map) {
          result.add(City.fromJson(Map<String, dynamic>.from(cityData)));
        } else if (cityData is List) {
          for (var city in cityData) {
            var cityObj = City.fromJson(Map<String, dynamic>.from(city));
            String cityName = "${cityObj.cityName} (${cityObj.type})";
            
            if (!uniqueCities.containsKey(cityName)) {
              uniqueCities[cityName] = cityObj;
            }
          }
          result = uniqueCities.values.toList();
        }
      }
      return result;
    } catch (e) {
      throw e;
    }
}

  Future<CostResponse> calculateCost({
    required String origin,
    required String destination,
    required int weight,
    required String courier,
  }) async {
    try {
      final body = {
        'origin': origin,
        'destination': destination,
        'weight': weight.toString(),
        'courier': courier,
        'originType': 'city',
        'destinationType': 'city'
      };

      dynamic response = await _apiServices.postApiResponse('/cost', body);

      if (response['rajaongkir']['status']['code'] == 200) {
        return CostResponse.fromJson(response['rajaongkir']['results'][0]);
      }
      throw FetchDataException('Something went wrong');
    } catch (e) {
      print("Error calculating cost: $e");
      throw e;
    }
  }
}
