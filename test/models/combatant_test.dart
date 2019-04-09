import 'package:flutter_test/flutter_test.dart';
import 'package:gurps_gmcontrol_dart/models/combatant.dart';

void main() {
  group('FpCondition', () {
    test('Normal', () {
      final fp = FpCondition(maxFatiguePoints: 20, fatiguePoints: 20);
      expect(fp.condition, FpConditionValue.normal);
    });
    test('Very tired', () {
      final fp = FpCondition(maxFatiguePoints: 18, fatiguePoints: 5);
      expect(fp.condition, FpConditionValue.very_tired);
    });
    test('Near collapse', () {
      final fp = FpCondition(maxFatiguePoints: 18, fatiguePoints: 0);
      expect(fp.condition, FpConditionValue.near_collapse);
    });
    test('Collapsed', () {
      final fp = FpCondition(maxFatiguePoints: 18, fatiguePoints: -18);
      expect(fp.condition, FpConditionValue.collapse);
    });
  });
}
