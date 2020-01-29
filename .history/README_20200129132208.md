# customgauge
Fully customizable Gauge widget for Flutter

<img src="https://github.com/jagan999/customgauge/raw/master/GaugeExample.jpg" height="320px" >

## Installing:
In your pubspec.yaml, add the following dependency
```yaml
dependencies:
  customgauge: 1.0.0
```

## Example Usage:
```dart
import 'package:customgauge/customgauge.dart';

CustomGauge(
    gaugeSize: 200,
    segments: [
        GaugeSegment('Low', 20, Colors.red),
        GaugeSegment('Medium', 40, Colors.orange),
        GaugeSegment('High', 40, Colors.green),
    ],
    currentValue: 46,
    displayWidget: Text('Fuel in tank', style: TextStyle(fontSize: 12)),
),

```
## Features:
* Fully featured Gauge widget that is built from scratch
* Can have any number of segments in the Gauge with different segment length and colors
* Gauge can have any dimension (square dimension only) with any minimum and maximum value
* Needle color can be customized
* Display and Value widget can be customized, so that you can display what you want on the Gauge
* Can turn on/off markers that display Min and Max value on the Gauge. You can even style these markers!

## License:
This project is licensed under the BSD 2-Clause license - see the LICENSE file for details