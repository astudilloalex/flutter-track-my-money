import 'package:equatable/equatable.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props {
    return [];
  }
}

final class TabChangedHomeEvent extends HomeEvent {
  const TabChangedHomeEvent(this.tabIndex);

  final int tabIndex;

  @override
  List<Object?> get props {
    return [
      tabIndex,
    ];
  }
}
