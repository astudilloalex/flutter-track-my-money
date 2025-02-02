enum TypeEnum implements Comparable<TypeEnum> {
  income(id: 1, name: 'income'),
  expense(id: 2, name: 'expense');

  const TypeEnum({
    required this.id,
    required this.name,
  });

  final int id;
  final String name;

  @override
  int compareTo(TypeEnum other) {
    return id.compareTo(other.id);
  }
}
