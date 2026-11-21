class CrisisFilterService {
  CrisisFilterService._();

  // Kriz ve acil tehlike anahtar kelimeleri (küçük harf kontrolü)
  static final List<String> _crisisKeywords = [
    'intihar',
    'ölmek istiyorum',
    'ölmek istedim',
    'yaşamak istemiyorum',
    'canıma kıy',
    'kendimi öldür',
    'kendime zarar',
    'bileklerimi',
    'hayatıma son ver',
    'yaşamaktan bıktım',
    'artık dayanamıyorum bitir',
    'kendimi as',
    'kendimi at',
    'suicide',
    'kill myself',
    'end my life',
    'self harm',
  ];

  /// Verilen metinde kriz veya kendine zarar riski olup olmadığını inceler
  static bool containsCrisisRisk(String text) {
    if (text.trim().isEmpty) return false;
    final lower = text.toLowerCase();

    for (final keyword in _crisisKeywords) {
      if (lower.contains(keyword)) {
        return true;
      }
    }
    return false;
  }
}
