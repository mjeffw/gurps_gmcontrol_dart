import 'package:flutter_test/flutter_test.dart';
import 'package:gurps_gmcontrol_dart/src/apis/melee_api.dart';
import 'package:gurps_gmcontrol_dart/src/models/melee.dart';

void main() {
  group('description', () {
    test('fetch', () async {
      Melee m = await meleeApi.fetch(index: 0);
      expect(m.id, 0);
      expect(m.combatants, hasLength(3));
    });
  });
}
