import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track_my_money/ui/pages/home/bloc/home_event.dart';
import 'package:track_my_money/ui/pages/home/bloc/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeState()) {
    log('HomeBloc created', name: 'Bloc');
    on<TabChangedHomeEvent>(_onTabChanged);
  }

  @override
  Future<void> close() {
    log('HomeBloc closed', name: 'Bloc');
    return super.close();
  }

  void _onTabChanged(
    TabChangedHomeEvent event,
    Emitter<HomeState> emit,
  ) {
    emit(state.copyWith(currentTab: event.tabIndex));
  }
}
