class FallbackPrompts {
  FallbackPrompts._();

  static const List<String> defaultQuestions = [
    "Bu düşünce bir tahmin mi, yoksa kesin bir gerçek mi?",
    "Buna destek olan somut kanıtlar ve aksini gösteren işaretler neler?",
    "Bunu bir arkadaşın yaşasa ona nasıl destek olurdun?",
  ];

  static const String finalActionQuestion =
      "Şimdi yapabileceğin, iki dakikadan kısa tek bir adım ne?";

  static const String defaultReliefMessage =
      "Düşünce tamamen yok olmadı; ama artık zihninde daha hafif ve daha taşınabilir.";
}
