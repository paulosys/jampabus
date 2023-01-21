class Address {
  late final String street;
  late final String city;
  late final String cep;
  late final String district;
  late final String number;
  final double latitude;
  final double longitude;

  Address({required this.latitude, required this.longitude});

  @override
  String toString() {
    String text = '';
    if (street.isNotEmpty) text += '$street, ';
    if (number.isNotEmpty) text += '$number, ';
    if (city.isNotEmpty) text += '$city, ';
    if (cep.isNotEmpty) text += '$cep.';
    return text;
  }
}
