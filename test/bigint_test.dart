import 'package:test/test.dart';

void main() {
  test('integers BigInt test', () {
    for (var ints = 0; ints <= 100; ints++) {
      final intsStr = ints == 0 ? '0' : '9' * ints;
      final bi = BigInt.parse(intsStr);
      expect(bi.toString(), intsStr, reason: '$ints ints');
    }
  });
}
