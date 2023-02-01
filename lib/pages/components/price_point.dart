import 'dart:math';
import 'package:collection/collection.dart';

class PricePoint {
  double x;
  double y;

  PricePoint({required this.x, required this.y});
}

DateTime now = DateTime.now();

List<PricePoint> get pricePoints {
  int max = 42;
  int min = 35;
  final Random random = Random();
  final randomNumbers = <double>[];
  for (var i = 0; i <= DateTime(now.year, now.month + 1, 0).day - 1; i++) {
    randomNumbers.add(min +  (max-min) * random.nextDouble() );
    // randomNumbers.add(random.nextDouble());
  }

  return randomNumbers
      .mapIndexed(
          (index, element) => PricePoint(x: index.toDouble(), y: element))
      .toList();
}

List<PricePoint> get pricePoints2 {
  int max = 42;
  int min = 35;
  final Random random = Random();
  final randomNumbers = <double>[];
  for (var i = 0; i <= DateTime(now.year, now.month + 1, 0).day -1; i++) {
    randomNumbers.add(36.5);
    // randomNumbers.add(random.nextDouble());
  }

  return randomNumbers
      .mapIndexed(
          (index, element) => PricePoint(x: index.toDouble(), y: element))
      .toList();
}