// ignore_for_file: public_member_api_docs, sort_constructors_first
class Address {
  late final double latitude;
  late final double longitude;
  late final String cep;
  late final String city;
  late final String district;
  late final String number;
  late final String state;
  late final String street;

  Address({
    required this.latitude,
    required this.longitude,
    required this.street,
    required this.city,
    required this.state,
    required this.cep,
    required this.district,
    required this.number,
  });

  @override
  String toString() {
    String text = '';
    if (street.isNotEmpty) text += '$street, ';
    if (number.isNotEmpty) text += '$number, ';
    if (city.isNotEmpty) text += '$city, ';
    if (state.isNotEmpty) text += '$state, ';
    if (cep.isNotEmpty) text += '$cep.';
    return text;
  }
}
