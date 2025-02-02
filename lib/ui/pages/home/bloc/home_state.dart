import 'package:equatable/equatable.dart';

final class HomeState extends Equatable {
  const HomeState({
    this.currentTab = 0,
  });

  final int currentTab;

  @override
  List<Object?> get props {
    return [
      currentTab,
    ];
  }

  HomeState copyWith({
    int? currentTab,
  }) {
    return HomeState(
      currentTab: currentTab ?? this.currentTab,
    );
  }
}
