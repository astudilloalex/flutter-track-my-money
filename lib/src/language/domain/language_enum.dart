enum LanguageEnum implements Comparable<LanguageEnum> {
  en(id: 1, name: 'en'),
  es(id: 2, name: 'es');

  const LanguageEnum({
    required this.id,
    required this.name,
  });

  final int id;
  final String name;

  @override
  int compareTo(LanguageEnum other) {
    return id.compareTo(other.id);
  }
}
