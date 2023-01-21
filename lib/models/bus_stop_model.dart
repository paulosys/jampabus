class BusStop {
  late final String code;
  late final double latitude;
  late final double longitude;
  bool favorite = false;
  bool visible = true;

  BusStop({
    required this.code,
    required this.latitude,
    required this.longitude,
  });

  BusStop.fromJson(Map<String, dynamic> json) {
    code = json['codigo'];
    latitude = double.parse(json['Lat']);
    longitude = double.parse(json['Long']);
  }
}
