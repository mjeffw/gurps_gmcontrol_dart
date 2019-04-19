import 'package:flutter/material.dart';
import 'package:gurps_gmcontrol_dart/src/app.dart';
import 'package:gurps_gmcontrol_dart/src/blocs/bloc_provider.dart';
import 'package:gurps_gmcontrol_dart/src/blocs/melee_bloc.dart';

void main() {
  return runApp(BlocProvider<MeleeBloc>(
    bloc: MeleeBloc(),
    child: App(),
  ));
}
