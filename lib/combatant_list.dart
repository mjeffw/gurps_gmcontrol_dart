import 'dart:async';

import 'package:flutter/material.dart';
import 'models/combatant.dart';
import 'combatant_widget.dart';
import 'default_app_bar.dart';
import 'mocks/mock_combatant.dart';

class CombatantList extends StatefulWidget {
  @override
  _CombatantListState createState() => _CombatantListState();
}

class _CombatantListState extends State<CombatantList> {
  List<Combatant> _combatants = [];
  bool _loading = false;
  int _selectedIndex = -1;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    if (this.mounted) {
      setState(() => this._loading = true);

      Timer(Duration(seconds: 3), () async {
        final combatants = MockCombatant.fetchAll();
        combatants.sort((a, b) => b.speed.compareTo(a.speed));

        setState(() {
          this._combatants = combatants;
          this._loading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(),
      body: RefreshIndicator(
        onRefresh: loadData,
        child: Column(children: [
          _progressBar(context),
          Expanded(child: _listView(context)),
        ]),
      ),
    );
  }

  Widget _progressBar(BuildContext context) {
    return this._loading
        ? LinearProgressIndicator(
            value: null,
            backgroundColor: Colors.white,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
          )
        : Container();
  }

  Widget _listView(BuildContext context) {
    return ListView.builder(
      itemBuilder: _listViewItemBuilder,
      itemCount: this._combatants.length,
    );
  }

  Widget _listViewItemBuilder(BuildContext context, int index) {
    return GestureDetector(
      onTap: () => _selectCombatant(index),
      child: _renderCombatant(index),
    );
  }

  void _selectCombatant(int index) {
    setState(() {
      this._selectedIndex = (this._selectedIndex == index) ? -1 : index;
    });
  }

  Widget _renderCombatant(int index) {
    final combatant = this._combatants[index];
    return new CombatantWidget(combatant, index == _selectedIndex);
  }
}
