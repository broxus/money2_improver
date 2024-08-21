import 'package:test/test.dart';
import 'package:money2/money2.dart';

void main() {
  const maxScale = 100;
  const maxInts = 100;

  setUp(() {
    for (var scale = 0; scale <= maxScale; scale++) {
      final c = Currency.create('C$scale', scale, symbol: '=$scale=');
      Currencies().register(c);
    }
  });

  test('scale 0-$maxScale test', () {
    for (var scale = 0; scale <= maxScale; scale++) {
      final c = Currencies().find('C$scale');
      expect(c, isNotNull);
      final str = scale == 0 ? '0' : '0.${'0' * (scale - 1)}1';
      final fmt = scale == 0 ? '0' : '0.${'0' * scale}';
      expect(
        Money.fromFixedWithCurrency(
          Fixed.parse(str, scale: scale),
          c!,
        ).amount.format(fmt),
        str,
        reason: 'Failed with $scale scale',
      );
    }
  });

  test('integers 0-$maxInts test', () {
    for (var ints = 0; ints <= maxInts; ints++) {
      final c = Currencies().find('C0');
      expect(c, isNotNull);
      final str = ints == 0 ? '0' : '9' * ints;
      final fmt = '#';
      expect(
          Money.fromFixedWithCurrency(Fixed.parse(str, scale: 0), c!)
              .amount
              .format(fmt)
              .replaceFirst(RegExp(r'^\.'), '0.'),
          str,
          reason: 'Failed with $ints ints');
    }
  });

  test('scale 0-$maxScale and integers 0-$maxInts test', () {
    for (var scale = 0; scale <= maxScale; scale++) {
      for (var ints = 0; ints <= maxInts; ints++) {
        final c = Currencies().find('C$scale');
        expect(c, isNotNull);
        final intsStr = ints == 0 ? '0' : '9' * ints;
        final str = scale == 0 ? intsStr : '$intsStr.${'0' * (scale - 1)}1';
        final fmt = scale == 0 ? '#' : '#.${'#' * scale}';
        expect(
            Money.fromFixedWithCurrency(Fixed.parse(str, scale: scale), c!)
                .amount
                .format(fmt)
                .replaceFirst(RegExp(r'^\.'), '0.'),
            str,
            reason: 'Failed with $scale scale, $ints ints');
      }
    }
  });
}
