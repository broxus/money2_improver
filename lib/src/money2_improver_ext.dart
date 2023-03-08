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
}
