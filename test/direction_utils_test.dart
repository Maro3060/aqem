import 'package:flutter_test/flutter_test.dart';

import 'package:aqem/core/utils/direction_utils.dart';

void main() {
  group('DirectionUtils.getDirection', () {
    test('returns North (شمال) for 0°', () {
      expect(DirectionUtils.getDirection(0), 'شمال');
    });

    test('returns North for 359° (wraps around)', () {
      expect(DirectionUtils.getDirection(359), 'شمال');
    });

    test('returns East (شرق) for 90°', () {
      expect(DirectionUtils.getDirection(90), 'شرق');
    });

    test('returns South (جنوب) for 180°', () {
      expect(DirectionUtils.getDirection(180), 'جنوب');
    });

    test('returns West (غرب) for 270°', () {
      expect(DirectionUtils.getDirection(270), 'غرب');
    });

    test('normalizes negative bearings', () {
      expect(DirectionUtils.getDirection(-90), 'غرب'); // -90 ≡ 270
    });

    test('handles bearings beyond 360°', () {
      expect(DirectionUtils.getDirection(450), 'شرق'); // 450 ≡ 90
    });

    test('handles 22.5° boundaries correctly', () {
      // index = ((bearing + 22.5) ~/ 45) % 8
      // 0..22  → North (شمال), 23..67 → North-East (شمال شرقي)
      expect(DirectionUtils.getDirection(22), 'شمال');
      expect(DirectionUtils.getDirection(23), 'شمال شرقي');
      expect(DirectionUtils.getDirection(67), 'شمال شرقي');
      expect(DirectionUtils.getDirection(68), 'شرق');
    });
  });
}
