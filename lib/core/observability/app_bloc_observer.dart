import 'package:booking/core/observability/logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Logs every Cubit state transition and error — wired in both entry points
/// through `Bloc.observer = AppBlocObserver()`.
class AppBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    logInfo('${bloc.runtimeType}: ${change.currentState.runtimeType} -> '
        '${change.nextState.runtimeType}');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    logError('${bloc.runtimeType} error', error, stackTrace);
  }
}
