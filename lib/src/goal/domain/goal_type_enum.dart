enum GoalTypeEnum implements Comparable<GoalTypeEnum> {
  automatic(id: 1, name: 'automatic'),
  manual(id: 2, name: 'manual');

  const GoalTypeEnum({
    required this.id,
    required this.name,
  });

  final int id;
  final String name;

  @override
  int compareTo(GoalTypeEnum other) {
    return id.compareTo(other.id);
  }

  static GoalTypeEnum fromId(int id) {
    return GoalTypeEnum.values.firstWhere(
      (type) => type.id == id,
    );
  }
}
