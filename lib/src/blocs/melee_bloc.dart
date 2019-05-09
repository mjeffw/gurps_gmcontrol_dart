import 'package:gurps_gmcontrol_dart/src/apis/melee_api.dart';
import 'package:gurps_gmcontrol_dart/src/models/melee.dart';
import 'package:rxdart/rxdart.dart';

import 'bloc_provider.dart';

///
/// Uniquely identifies a combatant
///
class CombatantId {
  final int meleeId;
  final int id;
  CombatantId({this.meleeId, this.id});
}

class CombatantSelectionId {
  final bool selected;
  final CombatantId combatantId;
  CombatantSelectionId({this.combatantId, this.selected});
}

class MeleeBloc implements BlocBase {
  // ##########  STREAMS  ##############

  ///
  /// Temporarily store the index (ID) of a melee being read from the datastore.
  /// This prevents the same melee from being fetched twice.
  ///
  final _meleesBeingFetched = Set<int>();

  ///
  /// Cache of melees read from the datastore. If the melee object is updated,
  /// we'll have to write it back to the datastore as well.
  ///
  var _meleeMap = <int, Melee>{};

  ///
  /// The only event this stream (currently) understands is the request of
  /// the index of the Melee object to render. The index is checked to
  /// see if it already exists; if it does not, it is fetched from the api.
  ///
  PublishSubject<int> _idController = PublishSubject<int>();
  Sink<int> get meleeEventSink => _idController.sink;

  ///
  /// The meleeDataStream contains the Melee object for every index requested
  /// via the meleeEventSink.
  ///
  PublishSubject<Melee> _meleeController = PublishSubject<Melee>();
  Sink<Melee> get _inMeleesList => _meleeController.sink;
  Stream<Melee> get meleeDataStream => _meleeController.stream;

  ///
  /// Need to change the streams below to a single "event" based stream.
  /// First event: select combatant.
  /// There will be others, like increment turn/round.
  ///

  ///
  /// In a given melee, some combatants may be displayed as 'expanded'.
  ///
  var _selectedIdController = PublishSubject<CombatantId>();
  Sink<CombatantId> get selectionEventSink => _selectedIdController.sink;

  var _selectedController = PublishSubject<CombatantSelectionId>();
  Sink<CombatantSelectionId> get _inSelected => _selectedController.sink;
  Stream<CombatantSelectionId> get selectedStream => _selectedController.stream;

  MeleeBloc() {
    _idController.stream
        // take some time before jumping into the request (there might be several ones in a row)
        .bufferTime(Duration(microseconds: 500))
        // and, do not update where this is no need
        .where((batch) => batch.isNotEmpty)
        .listen(_handleIndexes);

    _selectedIdController.stream
        .bufferTime(Duration(microseconds: 500))
        .where((batch) => batch.isNotEmpty)
        .listen(_handleSelection);
  }

  get combatantEventSink => null;

  @override
  void dispose() {
    _meleeController.close();
    _idController.close();
    _selectedController.close();
    _selectedIdController.close();
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

  void _handleSelection(List<CombatantId> events) {
    events.forEach((CombatantId f) {
      Melee melee = _meleeMap[f.meleeId];
      if (melee != null) {
        bool updated = melee.select(f.id);
        if (updated) {
          melee.combatants.forEach((it) => _inSelected.add(CombatantSelectionId(
              combatantId: CombatantId(meleeId: melee.id, id: it.id),
              selected: melee.selected.contains(it))));
        }
      }
    });
  }
}
