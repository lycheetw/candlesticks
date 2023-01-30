import 'package:candlesticks/candlesticks.dart';
import 'package:flutter/material.dart';

class TradingLog {
  final String name;
  final double openPrice;
  final DateTime openTime;
  final double closePrice;
  final DateTime closeTime;
  final bool isLong;


  TradingLog({
    required this.name,
    required this.openTime,
    required this.openPrice,
    required this.closeTime,
    required this.closePrice,
    required this.isLong,
  });

  bool operator ==(other) {
    if (other is TradingLog) {
      return other.name == this.name;
    } else {
      return false;
    }
  }
}