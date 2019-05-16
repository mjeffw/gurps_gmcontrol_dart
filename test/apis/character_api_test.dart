import 'package:flutter_test/flutter_test.dart';
import 'package:gurps_gmcontrol_dart/src/apis/character_api.dart';
import 'package:gurps_gmcontrol_dart/src/models/character.dart';

void main() {
  group('api', () {
    test('fetch Grend', () async {
      Character c = await characterApi.fetch(100);
      expect(c.bio.name, 'Grend Gnashtooth');
    });

    test('fetch Findlay', () async {
      Character c = await characterApi.fetch(102);
      expect(c.bio.name, 'Findlay Silvertongue');
    });
  });
}
