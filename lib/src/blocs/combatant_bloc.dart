import 'package:gurps_gmcontrol_dart/src/blocs/bloc_provider.dart';

import 'melee_bloc.dart';

enum CombatantEventType { Maneuver }

class CombatantEvent {
  CombatantId id;
  CombatantEventType event;
  String newValue;
}

class CombatantBloc implements BlocBase {
  @override
  void dispose() {}
}
