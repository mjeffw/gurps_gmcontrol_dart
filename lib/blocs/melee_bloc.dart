import 'package:gurps_gmcontrol_dart/apis/melee_api.dart';
import 'package:gurps_gmcontrol_dart/models/melee.dart';
import 'package:rxdart/rxdart.dart';

import 'bloc_provider.dart';

class MeleeCombatant {
  final int meleeId;
  final int id;
  MeleeCombatant({this.meleeId, this.id});
}

class MeleeBloc implements BlocBase {
  // ##########  STREAMS  ##############

  ///
  /// Request the index of the Melee object to render. The index is checked to
  /// see if it already exists; if it does not, it is fetched from the api.
  ///
  final _meleesBeingFetched = Set<int>();
  var _meleeMap = <int, Melee>{};
  PublishSubject<int> _idController = PublishSubject<int>();

  Sink<int> get inMeleeId => _idController.sink;

  ///
  /// We are going to need the list of combatants to be displayed
  ///
  PublishSubject<Melee> _meleeController = PublishSubject<Melee>();
  Sink<Melee> get _inMeleesList => _meleeController.sink;
  Stream<Melee> get outMeleeList => _meleeController.stream;

  ///
  /// In a given melee, some combatants may be displayed as 'expanded'.
  ///
  PublishSubject<MeleeCombatant> _selectedCombatantController =
      PublishSubject<MeleeCombatant>();
  Sink<MeleeCombatant> get inSelectedCombatants =>
      _selectedCombatantController.sink;
  Stream<MeleeCombatant> get outSelectedCombatants =>
      _selectedCombatantController.stream;

  MeleeBloc() {
    _idController.stream
        // take some time before jumping into the request (there might be several ones in a row)
        .bufferTime(Duration(microseconds: 500))
        // and, do not update where this is no need
        .where((batch) => batch.isNotEmpty)
        .listen(_handleIndexes);

    _selectedCombatantController.stream
        .bufferTime(Duration(microseconds: 500))
        .where((batch) => batch.isNotEmpty)
        .listen(_handleSelection);
  }

  @override
  void dispose() {
    _meleeController.close();
    _idController.close();
    _selectedCombatantController.close();
  }

  ///
  /// For each of the melee index(es), we need to check if the latter
  /// has already been fetched.
  ///
  void _handleIndexes(List<int> ids) {
    // Iterate all the requested indexes
    ids.forEach((id) {
      print(id);

      // if not fetched, do that now
      if (!_meleesBeingFetched.contains(id)) {
        // remember that we are fetching it
        _meleesBeingFetched.add(id);
        // fetch it
        api.fetch(index: id).then(
            (Melee fetchedMelee) => _handleFetchedMelee(fetchedMelee, id));
      }
    });
  }

  ///
  /// once a Melee is fetched, we need to
  /// 1) record it
  /// 2) notify everyone who is interested in it
  ///
  void _handleFetchedMelee(Melee melee, int id) {
    //remember it
    _meleeMap[id] = melee;
    // remove it from the ones being fetched
    _meleesBeingFetched.remove(id);
    // notify
    _inMeleesList.add(melee);
  }

  void _handleSelection(List<MeleeCombatant> events) {
    events.forEach((MeleeCombatant f) {
      Melee melee = _meleeMap[f.meleeId];
      if (melee != null) {
        bool updated = melee.select(f.id);
        if (updated) {
          inSelectedCombatants.add(f);
        }
      }
    });
  }
}
