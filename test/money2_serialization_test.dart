import 'dart:convert';

import 'package:test/test.dart';
import 'package:money2/money2.dart';
import 'package:money2_improver/money2_improver.dart';

void main() {
  final amount = '${'9' * 100}.${'9' * 100}';
  final minorUnits = '9' * 200;

  test('Fixed serialization', () {
    final f0 = Fixed.parse(amount);
    final json = f0.toJson();
    final f1 = FixedImprover.fromJson(json);
    expect(f1.toString(), amount);
  });

  test('Fixed jsonEncode', () {
    final f0 = Fixed.parse(amount);
    final json = jsonEncode(f0.toJson());
    final f1 = FixedImprover.fromJson(jsonDecode(json));
    expect(f1.toString(), amount);
  });

  test('Currency serialization (base)', () {
    final c0 = Currency.create('EVER', 9);
    final json = c0.toJson();
    final c1 = CurrencyImprover.fromJson(json);
    expect(c0, c1);

    expect(c1.code, c0.code);
    expect(c1.scale, c0.scale);
    expect(c1.symbol, c0.symbol);
    expect(c1.pattern, c0.pattern);
    expect(c1.invertSeparators, c0.invertSeparators);
    expect(c1.country, c0.country);
    expect(c1.unit, c0.unit);
    expect(c1.name, c0.name);
  });

  test('Currency serialization (full)', () {
    final c0 = Currency.create(
      'EVER',
      9,
      symbol: 'EVER',
      pattern: '0.######### S',
      invertSeparators: true,
      country: 'AA',
      unit: 'abux',
      name: 'AA bux',
    );
    final json = c0.toJson();
    final c1 = CurrencyImprover.fromJson(json);
    expect(c0, c1);

    expect(c1.code, c0.code);
    expect(c1.scale, c0.scale);
    expect(c1.symbol, c0.symbol);
    expect(c1.pattern, c0.pattern);
    expect(c1.invertSeparators, c0.invertSeparators);
    expect(c1.country, c0.country);
    expect(c1.unit, c0.unit);
    expect(c1.name, c0.name);
  });

  test('Money serialization', () {
    final c = Currency.create('c100', 100, symbol: '=100=');
    final m0 = MoneyImprover.parseWithCurrencyImproved(amount, c);
    final json = m0.toJson();
    final m1 = MoneyImprover.fromJson(json);
    expect(m1.compareTo(m0), 0);
    expect(m1.minorUnits, BigInt.parse(minorUnits));
  });
}
