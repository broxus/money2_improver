import 'package:money2/money2.dart';

extension MoneyImprover on Money {
  /// Creates a Money from a [Fixed] [amount].
  ///
  /// The [amount] is scaled to match the currency selected via
  /// [currency].
  static Money parseWithCurrencyImproved(String amount, Currency currency, {int? scale}) =>
      Money.fromFixedWithCurrency(Fixed.parse(amount, scale: scale ?? currency.scale), currency);

  /// Formats a [Money] value into a String according to the
  /// passed [pattern].
  ///
  /// If [invertSeparator] is true then the role of the '.' and ',' are
  /// reversed. By default the '.' is used as the decimal separator
  /// whilst the ',' is used as the grouping separator.
  ///
  /// S outputs the currencies symbol e.g. $.
  /// 0 A single digit
  /// # A single digit, omitted if the value is zero (works only for integer part and as last
  ///   fractional symbol as flag for trimming zeros)
  /// . or , Decimal separator dependant on [invertSeparator]
  /// - Minus sign
  /// , or . Grouping separator dependant on [invertSeparator]
  /// space Space character.
  String formatImproved({String? pattern, bool invertSeparator = false}) {
    final p = pattern ?? currency.pattern;
    final decimalSeparator = invertSeparator ? ',' : '.';
    return p.replaceAllMapped(RegExp(r'([0#.\-,]+)'), (m) {
      final result = amount.format(m[0]!, invertSeparator: invertSeparator);
      final trimZerosRight = RegExp(r'#$').hasMatch(m[0]!);
      return trimZerosRight
          ? result.replaceFirst(RegExp(r'0*$'), '').replaceFirst(RegExp('\\$decimalSeparator\$'), '')
          : result;
    }).replaceAllMapped(RegExp(r'S'), (m) => currency.symbol);
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount.toJson(),
      'currency': currency.toJson(),
    };
  }

  static Money fromJson(Map<String, dynamic> json) {
    return Money.fromFixedWithCurrency(
      FixedImprover.fromJson(json['amount']),
      CurrencyImprover.fromJson(json['currency']),
    );
  }
}

extension CurrencyImprover on Currency {
  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'scale': scale,
      'symbol': symbol,
      'pattern': pattern,
      'invertSeparators': invertSeparators,
      'country': country,
      'unit': unit,
      'name': name,
    };
  }

  static Currency fromJson(Map<String, dynamic> json) {
    return Currency.create(
      json['code'],
      json['scale'],
      symbol: json['symbol'],
      pattern: json['pattern'],
      invertSeparators: json['invertSeparators'],
      country: json['country'],
      unit: json['unit'],
      name: json['name'],
    );
  }
}

extension FixedImprover on Fixed {
  Map<String, dynamic> toJson() {
    return {
      'minorUnits': minorUnits,
      'scale': scale,
    };
  }

  static Fixed fromJson(Map<String, dynamic> json) {
    return Fixed.fromBigInt(
      json['minorUnits'],
      scale: json['scale'],
    );
  }
}
