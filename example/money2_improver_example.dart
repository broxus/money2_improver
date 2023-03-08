import 'package:money2/money2.dart';
import 'package:money2_improver/money2_improver.dart';

void main() {
  final everWithDefaultFormatting = Currency.create('EVER', 9, symbol: 'EVER', pattern: '0.######### S');
  print(
    MoneyImprover.parseWithCurrencyImproved('2.01', everWithDefaultFormatting).formatImproved(trimZerosRigh: true),
  );
}
