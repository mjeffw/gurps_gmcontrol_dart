import 'package:flutter/material.dart';
import 'blocs/melee_bloc.dart';
// import 'blocs/combatant_bloc.dart';
import 'blocs/bloc_provider.dart';
import 'app.dart';

void main() {
  return runApp(BlocProvider<MeleeBloc>(
    bloc: MeleeBloc(),
    child: App(),
  ));
}
