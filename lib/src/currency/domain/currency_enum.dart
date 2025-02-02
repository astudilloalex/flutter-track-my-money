enum CurrencyEnum implements Comparable<CurrencyEnum> {
  usd(id: 1, name: 'USD'),
  eur(id: 2, name: 'EUR');

  const CurrencyEnum({
    required this.id,
    required this.name,
  });

  final int id;
  final String name;

  @override
  int compareTo(CurrencyEnum other) {
    return id.compareTo(other.id);
  }
}
