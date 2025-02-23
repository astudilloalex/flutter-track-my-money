enum TypeEnum implements Comparable<TypeEnum> {
  income(color: 0xFF4CAF50, id: 1, name: 'income'),
  expense(color: 0xFFF44336, id: 2, name: 'expense');

  const TypeEnum({
    required this.color,
    required this.id,
    required this.name,
  });

  final int color;
  final int id;
  final String name;

  @override
  int compareTo(TypeEnum other) {
    return id.compareTo(other.id);
  }

  static TypeEnum fromId(int id) {
    return TypeEnum.values.firstWhere(
      (type) => type.id == id,
    );
  }
}
