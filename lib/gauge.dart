library gauge;

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

///Class that holds the details of each segment on a CustomGauge
class GaugeSegment {
  final String segmentName;

  ///Name of the segment
  final double segmentSize;

  ///The size of the segment
  final Color segmentColor;

  ///The color of the segment

  GaugeSegment(this.segmentName, this.segmentSize, this.segmentColor);
}

class GaugeNeedleClipper extends CustomClipper<Path> {
  //Note that x,y coordinate system starts at the bottom right of the canvas
  //with x moving from right to left and y moving from bottm to top
  //Bottom right is 0,0 and top left is x,y
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(size.width * 0.5, size.height * 0.7);
    path.lineTo(1.1 * size.width * 0.5, size.height * 0.7);
    path.lineTo(size.width * 0.5, size.height);
    path.lineTo(0.9 * size.width * 0.5, size.height * 0.7);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(GaugeNeedleClipper oldClipper) => false;
}

class ArcPainter extends CustomPainter {
  ArcPainter(
      {this.startAngle = 0, this.sweepAngle = 0, this.color = Colors.grey});

  final double startAngle;

  final double sweepAngle;

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTRB(size.width * 0.1, size.height * 0.1,
        size.width * 0.9, size.height * 0.9);

    const useCenter = false;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.15;

    canvas.drawArc(rect, startAngle, sweepAngle, useCenter, paint);
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return false;
  }
}

class GaugeMarkerPainter extends CustomPainter {
  GaugeMarkerPainter(this.text, this.position, this.textStyle);

  final String text;
  final TextStyle textStyle;
  final Offset position;

  @override
  void paint(Canvas canvas, Size size) {
    final textSpan = TextSpan(
      text: text,
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );
    textPainter.paint(canvas, position);
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return false;
  }
}

///Customizable Gauge widget for Flutter
class Gauge extends StatefulWidget {
  ///Size of the widget - This widget is rendered in a square shape
  final double gaugeSize;

  ///Supply the list of segments in the Gauge.
  ///
  ///If nothing is supplied, the gauge will have one segment with a segment size of (Max Value - Min Value)
  ///painted in defaultSegmentColor
  ///
  ///Each segment is represented by a GaugeSegment object that has a name, segment size and color
  final List<GaugeSegment>? segments;

  ///Supply a min value for the Gauge. Defaults to 0
  final double minValue;

  ///Supply a max value for the Gauge. Defaults to 100
  final double maxValue;

  ///Current value of the Gauge
  final double? currentValue;

  ///Custom color for the needle on the Gauge. Defaults to Colors.black
  final Color needleColor;

  ///The default Segment color. Defaults to Colors.grey
  final Color defaultSegmentColor;

  ///Widget that is used to show the current value on the Gauge. Defaults to show the current value as a Decimal with 1 digit
  ///If value must not be shown, supply Container()
  final Widget? valueWidget;

  ///Widget to show any other text for the Gauge. Defaults to Container()
  final Widget? displayWidget;

  ///Specify if you want to display Min and Max value on the Gauge widget
  final bool showMarkers;

  ///Custom styling for the Min marker. Defaults to black font with size 10
  final TextStyle startMarkerStyle;

  ///Custom styling for the Max marker. Defaults to black font with size 10
  final TextStyle endMarkerStyle;

  @override
  _GaugeState createState() => _GaugeState();

  const Gauge(
      {Key? key,
      this.gaugeSize = 200,
      this.segments,
      this.minValue = 0,
      this.maxValue = 100.0,
      this.currentValue,
      this.needleColor = Colors.black,
      this.defaultSegmentColor = Colors.grey,
      this.valueWidget,
      this.displayWidget,
      this.showMarkers = true,
      this.startMarkerStyle =
          const TextStyle(fontSize: 10, color: Colors.black),
      this.endMarkerStyle = const TextStyle(fontSize: 10, color: Colors.black)})
      : super(key: key);
}

class _GaugeState extends State<Gauge> {
  //This method builds out multiple arcs that make up the Gauge
  //using data supplied in the segments property
  List<Widget> buildGauge(List<GaugeSegment> segments) {
    List<CustomPaint> arcs = [];
    double cumulativeSegmentSize = 0.0;
    double gaugeSpread = widget.maxValue - widget.minValue;

    //Iterate through the segments collection in reverse order
    //First paint the arc with the last segment color, then paint multiple arcs in sequence until we reach the first segment

    //Because all these arcs will be painted inside of a Stack, it will overlay to represent the eventual gauge with
    //multiple segments
    segments.reversed.forEach((segment) {
      arcs.add(
        CustomPaint(
          size: Size(widget.gaugeSize, widget.gaugeSize),
          painter: ArcPainter(
              startAngle: 0.75 * math.pi,
              sweepAngle: 1.5 *
                  ((gaugeSpread - cumulativeSegmentSize) / gaugeSpread) *
                  math.pi,
              color: segment.segmentColor),
        ),
      );
      cumulativeSegmentSize = cumulativeSegmentSize + segment.segmentSize;
    });

    return arcs;
  }

  @override
  Widget build(BuildContext context) {
    List<GaugeSegment>? _segments = widget.segments;
    double? _currentValue = widget.currentValue;

    if (widget.currentValue! < widget.minValue) {
      _currentValue = widget.minValue;
    }
    if (widget.currentValue! > widget.maxValue) {
      _currentValue = widget.maxValue;
    }

    //If segments is supplied, validate that the sum of all segment sizes = (maxValue - minValue)
    if (_segments != null) {
      double totalSegmentSize = 0;
      _segments.forEach((segment) {
        totalSegmentSize = totalSegmentSize + segment.segmentSize;
      });
      if (totalSegmentSize != (widget.maxValue - widget.minValue)) {
        throw Exception('Total segment size must equal (Max Size - Min Size)');
      }
    } else {
      //If no segments are supplied, default to one segment with default color
      _segments = [
        GaugeSegment(
            '', (widget.maxValue - widget.minValue), widget.defaultSegmentColor)
      ];
    }

    return SizedBox(
      height: widget.gaugeSize,
      width: widget.gaugeSize,
      child: Stack(
        children: <Widget>[
          ...buildGauge(_segments),
          widget.showMarkers
              ? CustomPaint(
                  size: Size(widget.gaugeSize, widget.gaugeSize),
                  painter: GaugeMarkerPainter(
                      widget.minValue.toString(),
                      Offset(widget.gaugeSize * 0.1, widget.gaugeSize * 0.85),
                      widget.startMarkerStyle))
              : Container(),
          widget.showMarkers
              ? CustomPaint(
                  size: Size(widget.gaugeSize, widget.gaugeSize),
                  painter: GaugeMarkerPainter(
                      widget.maxValue.toString(),
                      Offset(widget.gaugeSize * 0.8, widget.gaugeSize * 0.85),
                      widget.endMarkerStyle))
              : Container(),
          Container(
            height: widget.gaugeSize,
            width: widget.gaugeSize,
            alignment: Alignment.center,
            child: Transform.rotate(
              angle: (math.pi / 4) +
                  ((_currentValue! - widget.minValue) /
                      (widget.maxValue - widget.minValue) *
                      1.5 *
                      math.pi),
              child: ClipPath(
                clipper: GaugeNeedleClipper(),
                child: Container(
                  width: widget.gaugeSize * 0.75,
                  height: widget.gaugeSize * 0.75,
                  color: widget.needleColor,
                ),
              ),
            ),
          ),
          Container(
            height: widget.gaugeSize,
            width: widget.gaugeSize,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                widget.displayWidget ?? Container(),
                widget.valueWidget ??
                    Text('${_currentValue.toStringAsFixed(1)}',
                        style: const TextStyle(fontSize: 10)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
