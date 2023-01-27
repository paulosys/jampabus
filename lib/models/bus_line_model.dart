class LineBusStop {
  late final String code;
  late final String line;
  late final String destination;
  late final String direction;
  late final String directionDescription;
  late final String itinerary;
  late final String enterprise;
  late DateTime forecast;

  LineBusStop({
    required this.code,
    required this.line,
    required this.destination,
    required this.direction,
    required this.directionDescription,
    required this.itinerary,
    required this.enterprise,
  });

  LineBusStop.fromJson(Map<String, dynamic> json) {
    code = json['codigo'];
    line = json['linha'];
    destination = json['linhaDescricao'];
    direction = json['sentido']; //== 0 ? 'Ida' : 'Volta';
    directionDescription = json['descricaoSentido'];
    itinerary = json['itinerarioCodigo'];
    enterprise = json['empresaDescricao'];
  }
}


// "codigo":MDS604BAIRRO DOS IPÊS VIA AYRTON SENNA - AP04201883 V 604A,
// "descricao":"Av. Gouveia Nobrega",
// 1173 - Varadouro,
// "Joao Pessoa - PB",
// 58020-100,
// "Brazil",
// "sentido":1,
// "distanciaPontoUsuario":0.0,
// "linha":MDS604,
// "itinerario":"BAIRRO DOS IPÊS VIA AYRTON SENNA - A",
// "descricaoSentido":"TERMINAL BAIRRO DOS IPÉS",
// "linhaDescricao":"BAIRRO DOS IPÊS VIA AYRTON SENNA",
// "itinerarioCodigo":MDS604BAIRRO DOS IPÊS VIA AYRTON SENNA - A,
// "empresaDescricao":"Consórcio Navegantes",
// "latitude":-7.11258012942351,
// "longitude":-34.884073145058,
// "previsoes":null