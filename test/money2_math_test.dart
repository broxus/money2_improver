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

  test('scale 0-$maxScale and integers 0-$maxInts addition and subtraction test', () {
    for (var scale = 0; scale <= maxScale; scale++) {
      for (var ints = 0; ints <= maxInts; ints++) {
        final c = Currencies().find('C$scale');
        expect(c, isNotNull);
        final intsStr = ints == 0 ? '1' : '9' * ints;
        final str0 = '1';
        final str1 = scale == 0 ? '${intsStr}1' : '${intsStr}1.${'0' * (scale - 1)}1';
        final str2 = scale == 0 ? '${intsStr}2' : '${intsStr}2.${'0' * (scale - 1)}1';

        final m0 = Money.fromFixedWithCurrency(Fixed.parse(str0, scale: scale), c!);
        final m1 = Money.fromFixedWithCurrency(Fixed.parse(str1, scale: scale), c);
        final m2 = Money.fromFixedWithCurrency(Fixed.parse(str2, scale: scale), c);
        final mDiff = m2 - m1;
        final mSum = m1 + m0;

        expect(mDiff.amount, Fixed.one, reason: 'Failed with $scale scale, $ints ints');
        expect(mSum.amount, m2.amount, reason: 'Failed with $scale scale, $ints ints');
      }
    }
  });
}
