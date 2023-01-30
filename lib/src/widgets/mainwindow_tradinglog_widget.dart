import 'package:candlesticks/src/models/main_window_indicator.dart';
import 'package:flutter/material.dart';
import 'package:candlesticks/src/models/candle.dart';
import '../../candlesticks.dart';
import '../models/main_window_indicator.dart';

class MainWindowTradingLogWidget extends LeafRenderObjectWidget {
  final List<TradingLog> tradingLogs;
  final List<Candle> candles;
  final int index;
  final double candleWidth;
  final double high;
  final double low;

  MainWindowTradingLogWidget({
    required this.tradingLogs,
    required this.candles,
    required this.index,
    required this.candleWidth,
    required this.low,
    required this.high,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return MainWindowTradingLogRenderObject(
      tradingLogs,
      index,
      candleWidth,
      low,
      high,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant RenderObject renderObject) {
    MainWindowTradingLogRenderObject candlestickRenderObject =
    renderObject as MainWindowTradingLogRenderObject;

    candlestickRenderObject._tradingLogs = tradingLogs;
    candlestickRenderObject._candles = candles;
    candlestickRenderObject._index = index;
    candlestickRenderObject._candleWidth = candleWidth;
    candlestickRenderObject._high = high;
    candlestickRenderObject._low = low;
    candlestickRenderObject.markNeedsPaint();
    super.updateRenderObject(context, renderObject);
  }
}

class MainWindowTradingLogRenderObject extends RenderBox {
  late List<TradingLog> _tradingLogs;
  late List<Candle> _candles;
  late int _index;
  late double _candleWidth;
  late double _low;
  late double _high;

  MainWindowTradingLogRenderObject(
      List<TradingLog> tradingLogs,
      int index,
      double candleWidth,
      double low,
      double high,
      ) {
    _tradingLogs = tradingLogs;
    _index = index;
    _candleWidth = candleWidth;
    _low = low;
    _high = high;
  }

  /// set size as large as possible
  @override
  void performLayout() {
    size = Size(constraints.maxWidth, constraints.maxHeight);
  }

  @override
  void paint(PaintingContext context, Offset offset) {


    double range = (_high - _low) / size.height;
    _tradingLogs.forEach((element) {


      double? openX;
      double? openY;
      double? closeX;
      double? closeY;
      for (int i = 0; (i + 1) * _candleWidth < size.width; i++) {
        if (i + _index >= _candles.length || i + _index < 0) continue;
        var candle = _candles[i + _index];
        if(candle.date.compareTo(element.closeTime) <= 0 && closeX == null) {
          closeX = size.width + offset.dx - (i + 0.5) * _candleWidth;
          closeY = offset.dy + (_high - element.closePrice) / range;
        } else if (candle.date.compareTo(element.openTime) <= 0 && openX == null) {
          openX = size.width + offset.dx - (i + 0.5) * _candleWidth;
          openY = offset.dy + (_high - element.openPrice) / range;
          break;
        }

      }

      Color color;
      if(element.isLong) {
        if(element.closePrice > element.openPrice) {
          color = Colors.green;
        } else {
          color = Colors.red;
        }
      } else {
        if(element.closePrice < element.openPrice) {
          color = Colors.green;
        } else {
          color = Colors.red;
        }
      }

      if (openX != null && closeX != null) {
        Path path = Path()
          ..moveTo(closeX, closeY!)
          ..lineTo(openX, openY!);

        context.canvas.drawPath(
            path,
            Paint()
              ..color = color
              ..strokeWidth = 1
              ..style = PaintingStyle.stroke);

        if(element.isLong) {
          Path path2 = Path()
            ..moveTo(closeX, closeY)
            ..lineTo(closeX - 5, closeY - 8.66)
            ..lineTo(closeX + 5, closeY - 8.66)
            ..moveTo(openX, openY)
            ..lineTo(openX - 5, openY + 8.66)
            ..lineTo(openX + 5, openY + 8.66);

          context.canvas.drawPath(
              path2,
              Paint()
                ..color = Colors.white
                ..style = PaintingStyle.fill);
        }


      }

    });

    context.canvas.save();
    context.canvas.restore();
  }
}
