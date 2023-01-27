import 'package:flutter/material.dart';
import 'package:jampabus/components/drag_indicator/drag_indicator.dart';
import 'package:jampabus/models/bus_line_model.dart';
import 'package:jampabus/models/bus_stop_model.dart';

import '../../api/api.dart';

class LinesBottomSheet extends StatefulWidget {
  final BusStop busStop;
  const LinesBottomSheet({super.key, required this.busStop});

  @override
  State<LinesBottomSheet> createState() => _LinesBottomSheetState();
}

class _LinesBottomSheetState extends State<LinesBottomSheet> {
  Future<List<LineBusStop>> fetchLines() async {
    
    return await Api.instance.getLinesBusStop(widget.busStop);
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const DragIndicator(),
      Expanded(
        child: FutureBuilder(
            future: fetchLines(),
            builder: ((context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var item = snapshot.data![index];
                      return CardLineBus(
                          destination: item.destination,
                          directionDescription: item.directionDescription,
                          line: item.line,
                          forecast:  DateTime.now());
                    });
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            })),
      )
    ]);
  }
}

class CardLineBus extends StatelessWidget {
  final String line;
  final String destination;
  final String directionDescription;
  final DateTime forecast;
  const CardLineBus(
      {Key? key,
      required this.destination,
      required this.directionDescription,
      required this.line,
      required this.forecast})
      : super(key: key);

  Widget _forecastTime() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Icon(
            Icons.watch_later,
            color: Colors.grey[700],
            size: 16,
          ),
        ),
        Text(
          'Previsão de chegada: ',
          style: TextStyle(
            color: Colors.grey[700],
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          '${forecast.hour}:${forecast.minute}',
          style: const TextStyle(
            color: Colors.lightBlue,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
      child: Card(
        elevation: 5,
        child: SizedBox(
            child: Row(children: [
          Expanded(
              flex: 1,
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.blue,
                    borderRadius:
                        BorderRadius.horizontal(left: Radius.circular(5))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      line.substring(3),
                      style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    Material(
                      color: Colors.transparent,
                      shape: const CircleBorder(),
                      clipBehavior: Clip.hardEdge,
                      child: IconButton(
                        icon: const Icon(Icons.star),
                        iconSize: 30,
                        color: Colors.white,
                        onPressed: () {},
                      ),
                    )
                  ],
                ),
              )),
          Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _FieldText(fieldName: 'Destino', fieldValue: destination),
                    _FieldText(
                        fieldName: 'Sentido', fieldValue: directionDescription),
                    Row(
                      children: [
                        _forecastTime(),
                        IconButton(
                            tooltip: 'Ver ônibus da linha.',
                            onPressed: () {},
                            icon: const Icon(Icons.keyboard_arrow_right,
                                size: 32))
                      ],
                    )
                  ],
                ),
              )),
        ])),
      ),
    );
  }
}

class _FieldText extends StatelessWidget {
  final String fieldName;
  final String fieldValue;
  const _FieldText({required this.fieldName, required this.fieldValue});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$fieldName: '.toUpperCase(),
          style: const TextStyle(
              color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
        ),
        Flexible(
          fit: FlexFit.tight,
          child: Text(
            fieldValue.toUpperCase(),
            style: const TextStyle(
                color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
