class SeasonInfo {
  final String name;
  final String description;
  final String image;

  SeasonInfo({required this.name, required this.description, required this.image});

  factory SeasonInfo.fromMap(Map<String, dynamic> m) => SeasonInfo(
    name: m['name'] ?? '',
    description: m['description'] ?? '',
    image: m['image'] ?? '',
  );
}

class NamedItem {
  final String name;
  final String description;
  final String image;

  NamedItem({required this.name, required this.description, this.image = ''});

  factory NamedItem.fromMap(Map<String, dynamic> m) => NamedItem(
    name: m['name'] ?? '',
    description: m['description'] ?? '',
    image: m['image'] ?? '',
  );
}

class DestinationModel {
  final String id;
  final String title;
  final String location;
  final String coverImage;
  final double elevation;
  final String weatherSummary;
  final String coldestMonth;
  final String coldestTemp;
  final String hottestMonth;
  final String hottestTemp;
  final String region;
  final String overview;
  final String cultureHistory;
  final List<SeasonInfo> seasons;
  final String foodIntro;
  final List<NamedItem> foodItems;
  final String craftsIntro;
  final List<NamedItem> craftItems;
  final String demographics;
  final List<NamedItem> attractions;
  final List<String> interestingFacts;
  final List<String> galleryImages;

  DestinationModel({
    required this.id,
    required this.title,
    required this.location,
    required this.coverImage,
    this.elevation = 0,
    this.coldestMonth = '',
    this.coldestTemp = '',
    this.hottestMonth = '',
    this.hottestTemp = '',
    this.region = '',
    this.weatherSummary = '',
    this.overview = '',
    this.cultureHistory = '',
    this.seasons = const [],
    this.foodIntro = '',
    this.foodItems = const [],
    this.craftsIntro = '',
    this.craftItems = const [],
    this.demographics = '',
    this.attractions = const [],
    this.interestingFacts = const [],
    this.galleryImages = const [],
  });

  factory DestinationModel.fromMap(String id, Map<String, dynamic> m) {
    List<T> mapList<T>(String key, T Function(Map<String, dynamic>) fromMap) {
      final raw = m[key];
      if (raw is! List) return <T>[];
      return raw.map((e) => fromMap(Map<String, dynamic>.from(e))).toList();
    }

    return DestinationModel(
      id: id,
      title: m['title'] ?? '',
      location: m['location'] ?? '',
      coverImage: m['coverImage'] ?? '',
      elevation: double.tryParse(m['elevation']?.toString() ?? '') ?? 0,
      coldestMonth: m['coldestMonth'] ?? '',
      coldestTemp: m['coldestTemp'] ?? '',
      hottestMonth: m['hottestMonth'] ?? '',
      region: m['region'] ?? '',
      hottestTemp: m['hottestTemp'] ?? '',
      weatherSummary: m['weatherSummary'] ?? '',
      overview: m['overview'] ?? '',
      cultureHistory: m['cultureHistory'] ?? '',
      seasons: mapList('seasons', SeasonInfo.fromMap),
      foodIntro: m['foodIntro'] ?? '',
      foodItems: mapList('foodItems', NamedItem.fromMap),
      craftsIntro: m['craftsIntro'] ?? '',
      craftItems: mapList('craftItems', NamedItem.fromMap),
      demographics: m['demographics'] ?? '',
      attractions: mapList('attractions', NamedItem.fromMap),
      interestingFacts: (m['interestingFacts'] as List?)?.map((e) => e.toString()).toList() ?? [],
      galleryImages: (m['galleryImages'] as List?)?.map((e) => e.toString()).toList() ?? [],
    );
  }
}