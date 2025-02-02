enum LottieAsset implements Comparable<LottieAsset> {
  loading(name: 'assets/lottie/loading.json');

  const LottieAsset({
    required this.name,
  });

  final String name;

  @override
  int compareTo(LottieAsset other) {
    return name.compareTo(other.name);
  }
}
