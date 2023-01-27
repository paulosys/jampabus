import 'package:dio/dio.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:jampabus/models/bus_stop_model.dart';

import '../models/bus_line_model.dart';

class Api {
  late final String _token;
  final String _city = 'jpa';
  final String baseURL = FlutterConfig.get('API_BASE_URL');
  final dio = Dio();

  Api._();
  static final instance = Api._();

  Future<String?> _getIP() async {
    Response response = await dio.get('http://api.ipify.org/?format=json');
    if (response.statusCode == 200) {
      Map result = response.data;
      return result['ip'];
    }
    return null;
  }

  Future<void> getToken() async {
    String? ip = await _getIP();
    if (ip == null) return;

    var data = {'macaddress': ip, 'cidade': _city};

    int attempts = 0;

    while (attempts < 3) {
      Response response = await dio.post('$baseURL/dispositivo', data: data);
      if (response.statusCode == 200) {
        Map result = response.data;
        _token = result['Token'];
        break;
      }
    }

    if (_token.isEmpty) {
      throw Exception('Não foi possível comunicar com o servidor');
    }
  }

  Future<List<BusStop>> getAllBusStop() async {
    List<BusStop> busStopList = [];

    var data = {
      'token': _token,
      'cidade': _city,
      'latitude': '-7.1183516',
      'longitude': '-34.8504913',
      'zoom': 15
    };

    Response response = await dio.post('$baseURL/listaparadasv2', data: data);
    if (response.statusCode == 200) {
      List<dynamic> result = response.data;

      busStopList.addAll(result.map((e) => BusStop.fromJson(e)));

      return busStopList;
    }
    throw Exception('Não foi possível obter as paradas de ônibus.');
  }

  Future<List<LineBusStop>> getLinesBusStop(BusStop busStop) async {
    List<LineBusStop> busLineArray = [];

    var data = {
      'latitude': busStop.latitude,
      'longitude': busStop.longitude,
      'parada': busStop.code,
      'token': _token,
      'cidade': _city,
    };

    Response response = await dio
        .post('https://apissl.bus4.com.br/api/localizemev2', data: data);
    if (response.statusCode == 200) {
      List<dynamic> result = response.data;
  
      busLineArray.addAll(result.map((e) => LineBusStop.fromJson(e)));
      return busLineArray;
    }
    return [];
  }
}
