import 'package:depd_2024_mvvm/data/response/api_response.dart';
import 'package:depd_2024_mvvm/model/costs/calculate.dart';
import 'package:depd_2024_mvvm/model/model.dart';
import 'package:depd_2024_mvvm/repository/home_repository.dart';
import 'package:flutter/material.dart';

import '../model/city.dart';

class HomeViewmodel with ChangeNotifier {
  final _homeRepo = HomeRepository();

  ApiResponse<List<Province>> provinceList = ApiResponse.loading();
  ApiResponse<List<City>> originCityList = ApiResponse.completed([]);
  ApiResponse<List<City>> destCityList = ApiResponse.completed([]);
  // ApiResponse<CostResponse> costResult = ApiResponse.loading();
  ApiResponse<CostResponse> costResult = ApiResponse.completed(CostResponse());

  setProvinceList(ApiResponse<List<Province>> response) {
    provinceList = response;
    notifyListeners();
  }

  setOriginCityList(ApiResponse<List<City>> response) {
    originCityList = response;
    notifyListeners();
  }

  setDestCityList(ApiResponse<List<City>> response) {
    destCityList = response;
    notifyListeners();
  }

  setCostResult(ApiResponse<CostResponse> response) {
    costResult = response;
    notifyListeners();
  }

  Future<void> getProvinceList() async {
    setProvinceList(ApiResponse.loading());
    _homeRepo.fetchProvinceList().then((value) {
      setProvinceList(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      setProvinceList(ApiResponse.error(error.toString()));
    });
  }

  Future<void> getOriginCityList(String provinceId) async {
    print("Getting cities for province: $provinceId");
    setOriginCityList(ApiResponse.loading());
    _homeRepo.fetchCityList(provinceId).then((value) {
      print("Cities received: ${value.length}");
      setOriginCityList(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      print("Error: $error");
      setOriginCityList(ApiResponse.error(error.toString()));
    });
  }

  Future<void> getDestCityList(String provinceId) async {
    setDestCityList(ApiResponse.loading());
    _homeRepo.fetchCityList(provinceId).then((value) {
      setDestCityList(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      setDestCityList(ApiResponse.error(error.toString()));
    });
  }

  Future<void> calculateCost({
    required String origin,
    required String destination,
    required int weight,
    required String courier,
  }) async {
    setCostResult(ApiResponse.loading());
    _homeRepo
        .calculateCost(
      origin: origin,
      destination: destination,
      weight: weight,
      courier: courier,
    )
        .then((value) {
      setCostResult(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      setCostResult(ApiResponse.error(error.toString()));
    });
  }
}
