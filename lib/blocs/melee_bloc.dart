import '../models/combatant.dart';
import 'package:rxdart/rxdart.dart';
import 'bloc_provider.dart';

class MeleeBloc implements BlocBase {
  // ##########  STREAMS  ##############

  ///
  /// We are going to need the list of combatants to be displayed
  ///
  PublishSubject<List<Combatant>> _meleeController =
      PublishSubject<List<Combatant>>();
  //  Sink<List<Combatant>> get _inMeleeList => _meleeController.sink;
  Stream<List<Combatant>> get outMeleeList => _meleeController.stream;

  ///
  /// Each time we need to render a Combatant, we will pass its [index]
  /// so that, we will be able to check whether it has already been fetched
  /// If not, we will automatically fetch the page
  ///
  // PublishSubject<int> _indexController = PublishSubject<int>();
  // Sink<int> get inMeleeIndex => _indexController.sink;

  @override
  void dispose() {
    _meleeController.close();
    // _indexController.close();
  }
}
