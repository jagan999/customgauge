import 'package:flutter/material.dart';
import 'package:gauge/gauge.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: const Text('CustomGauge example app'),
          ),
          body: Container(
              color: Colors.grey[200],
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Row(children: <Widget>[
                      Gauge(
                        gaugeSize: 200,
                        segments: [
                          GaugeSegment('Low', 20, Colors.red),
                          GaugeSegment('Medium', 40, Colors.orange),
                          GaugeSegment('High', 40, Colors.green),
                        ],
                        currentValue: 60,
                        displayWidget: const Text('Fuel in tank',
                            style: TextStyle(fontSize: 12)),
                      ),
                      Gauge(
                        gaugeSize: 200,
                        segments: [
                          GaugeSegment('Critically Low', 10, Colors.red),
                          GaugeSegment('Low', 20, Colors.orange),
                          GaugeSegment('Medium', 20, Colors.yellow),
                          GaugeSegment('High', 50, Colors.green),
                        ],
                        currentValue: 45,
                        needleColor: Colors.red,
                        showMarkers: false,
                        displayWidget: const Text('Fuel in tank',
                            style: TextStyle(fontSize: 12)),
                      ),
                    ]),
                    Row(children: <Widget>[
                      Gauge(
                        gaugeSize: 100,
                        segments: [
                          GaugeSegment('Low', 20, Colors.blue[200]!),
                          GaugeSegment('Medium', 40, Colors.blue),
                          GaugeSegment('High', 40, Colors.blue[800]!),
                        ],
                        currentValue: 70,
                        displayWidget:
                            const Text('Temp', style: TextStyle(fontSize: 12)),
                      ),
                      Gauge(
                        gaugeSize: 100,
                        segments: [
                          GaugeSegment('Critically Low', 10, Colors.red),
                          GaugeSegment('Low', 20, Colors.orange),
                          GaugeSegment('Medium', 20, Colors.yellow),
                          GaugeSegment('High', 50, Colors.green),
                        ],
                        currentValue: 45,
                        needleColor: Colors.blue,
                        showMarkers: false,
                        valueWidget: Container(),
                        displayWidget:
                            const Text('Fuel', style: TextStyle(fontSize: 12)),
                      ),
                      Gauge(
                        gaugeSize: 100,
                        minValue: 30,
                        maxValue: 150,
                        segments: [
                          GaugeSegment('Low', 20, Colors.red),
                          GaugeSegment('Slightly Low', 20, Colors.yellow),
                          GaugeSegment('Correct', 20, Colors.green),
                          GaugeSegment('High', 60, Colors.orange),
                        ],
                        currentValue: 72,
                        displayWidget:
                            const Text('Pulse', style: TextStyle(fontSize: 12)),
                      ),
                      Gauge(
                        minValue: 0,
                        maxValue: 150,
                        gaugeSize: 100,
                        segments: [
                          GaugeSegment('Good', 80, Colors.green),
                          GaugeSegment('High', 70, Colors.red),
                        ],
                        currentValue: 75,
                        showMarkers: false,
                        displayWidget:
                            const Text('Speed', style: TextStyle(fontSize: 12)),
                      ),
                    ])
                  ])),
        ));
  }
}
