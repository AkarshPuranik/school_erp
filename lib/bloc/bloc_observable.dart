import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';


class ObserverBloc extends BlocObserver {
  /// {@macro counter_observer}
  const ObserverBloc();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    final previousStateType = change.currentState;
    final nextStateType = change.nextState;
    if (previousStateType == null || nextStateType == null) {
      debugPrint('${bloc.runtimeType} $change');
    }

    String formatStateName(String stateType) {
      return stateType.replaceAll(r'_$', '').replaceAll('Impl', '');
    }

    final formattedPreviousStateType = formatStateName(previousStateType.runtimeType.toString());
    final formattedNextStateType = formatStateName(nextStateType.runtimeType.toString());
    final logMessage = 'previous: $formattedPreviousStateType, next: $formattedNextStateType';
  }
}