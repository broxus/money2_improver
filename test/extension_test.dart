import 'package:test/test.dart';
import 'package:money2/money2.dart';
import 'package:money2_improver/money2_improver.dart';

void main() {
  const maxScale = 100;
  const maxInts = 100;

  setUp(() {
    for (var scale = 0; scale <= maxScale; scale++) {
      final c = Currency.create('C$scale', scale, symbol: '=$scale=');
      Currencies().register(c);
    }
  });

  test('test default currency formatting', () {
    final everWithDefaultFormatting = Currency.create(
      'EVER',
      9,
      symbol: 'EVER',
    );
    expect(
      MoneyImprover.parseWithCurrencyImproved(
        '2.0',
        everWithDefaultFormatting,
      ).formatImproved(),
      'EVER2.00',
      reason: 'Failed default formatting',
    );
  });

  test('test custom currency formatting', () {
    final everWithDefaultFormatting = Currency.create(
      'EVER',
      9,
      symbol: 'EVER',
      pattern: '0.000000000 S',
    );
    expect(
      MoneyImprover.parseWithCurrencyImproved(
        '2.0',
        everWithDefaultFormatting,
      ).formatImproved(),
      '2.000000000 EVER',
      reason: 'Failed custom formatting',
    );
  });

  test('test custom currency formatting 2', () {
    final everWithDefaultFormatting = Currency.create(
      'EVER',
      9,
      symbol: 'EVER',
      pattern: '0.000000000 S',
    );
    expect(
      MoneyImprover.parseWithCurrencyImproved(
        '2.01',
        everWithDefaultFormatting,
      ).formatImproved(),
      '2.010000000 EVER',
      reason: 'Failed custom formatting',
    );
  });

  test('test custom currency formatting 3 (trim zeros)', () {
    final everWithDefaultFormatting = Currency.create(
      'EVER',
      9,
      symbol: 'EVER',
      pattern: '0.######### S',
    );
    expect(
      MoneyImprover.parseWithCurrencyImproved(
        '2.01',
        everWithDefaultFormatting,
      ).formatImproved(),
      '2.01 EVER',
      reason: 'Failed custom formatting',
    );
  });

  test('test custom explicit formatting', () {
    final everWithDefaultFormatting = Currency.create(
      'EVER',
      9,
      symbol: 'EVER',
      pattern: '0.######### S',
    );
    expect(
        MoneyImprover.parseWithCurrencyImproved(
          '2.01',
          everWithDefaultFormatting,
        ).formatImproved(
          pattern: 'S 0.#########',
        ),
        'EVER 2.01',
        reason: 'Failed custom formatting');
  });

  test('scale 0-$maxScale test', () {
    for (var scale = 0; scale <= maxScale; scale++) {
      final c = Currencies().find('C$scale');
      expect(c, isNotNull);
      final str = scale == 0 ? '0' : '0.${'0' * (scale - 1)}1';
      final fmt = scale == 0 ? '0' : '0.${'#' * scale}';
      expect(
          MoneyImprover.parseWithCurrencyImproved(str, c!)
              .formatImproved(pattern: fmt),
          str,
          reason: 'Failed with $scale scale');
    }
  });

  test('integers 0-$maxInts test', () {
    for (var ints = 0; ints <= maxInts; ints++) {
      final c = Currencies().find('C0');
      expect(c, isNotNull);
      final str = ints == 0 ? '0' : '9' * ints;
      final fmt = '0';
      expect(
          MoneyImprover.parseWithCurrencyImproved(str, c!)
              .formatImproved(pattern: fmt),
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
        final fmt = scale == 0 ? '0' : '0.${'0' * scale}';
        expect(
            MoneyImprover.parseWithCurrencyImproved(str, c!)
                .formatImproved(pattern: fmt),
            str,
            reason: 'Failed with $scale scale, $ints ints');
      }
    }
  });
}
