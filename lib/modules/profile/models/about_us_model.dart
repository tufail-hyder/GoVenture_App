import 'package:cloud_firestore/cloud_firestore.dart';

class AboutUsModel {
  final String whoWeAre;

  final String milestoneYears;
  final String milestoneTravelers;
  final String milestoneTours;
  final String milestoneDestinations;

  final String whoWeServe;
  final String businessPortfolioUrl;

  final String whatMakesUsDifferent;
  final List<String> differentiators;

  final List<String> whyUs;

  final List<String> responsibleTourism;
  final String rootNetworkUrl;
  final List<String> responsibleTourismPoints;

  final List<String> founderBio;
  final String founderName;
  final String founderInstagramUrl;

  const AboutUsModel({
    required this.whoWeAre,
    required this.milestoneYears,
    required this.milestoneTravelers,
    required this.milestoneTours,
    required this.milestoneDestinations,
    required this.whoWeServe,
    required this.businessPortfolioUrl,
    required this.whatMakesUsDifferent,
    required this.differentiators,
    required this.whyUs,
    required this.responsibleTourism,
    required this.rootNetworkUrl,
    required this.responsibleTourismPoints,
    required this.founderBio,
    required this.founderName,
    required this.founderInstagramUrl,
  });

  factory AboutUsModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};

    List<String> stringList(dynamic value) {
      if (value is List) return value.map((e) => e.toString()).toList();
      return <String>[];
    }

    return AboutUsModel(
      whoWeAre: data['whoWeAre'] ?? '',
      milestoneYears: data['milestoneYears'] ?? '',
      milestoneTravelers: data['milestoneTravelers'] ?? '',
      milestoneTours: data['milestoneTours'] ?? '',
      milestoneDestinations: data['milestoneDestinations'] ?? '',
      whoWeServe: data['whoWeServe'] ?? '',
      businessPortfolioUrl: data['businessPortfolioUrl'] ?? '',
      whatMakesUsDifferent: data['whatMakesUsDifferent'] ?? '',
      differentiators: stringList(data['differentiators']),
      whyUs: stringList(data['whyUs']),
      responsibleTourism: stringList(data['responsibleTourism']),
      rootNetworkUrl: data['rootNetworkUrl'] ?? '',
      responsibleTourismPoints: stringList(data['responsibleTourismPoints']),
      founderBio: stringList(data['founderBio']),
      founderName: data['founderName'] ?? '',
      founderInstagramUrl: data['founderInstagramUrl'] ?? '',
    );
  }

  factory AboutUsModel.empty() => const AboutUsModel(
    whoWeAre: '',
    milestoneYears: '',
    milestoneTravelers: '',
    milestoneTours: '',
    milestoneDestinations: '',
    whoWeServe: '',
    businessPortfolioUrl: '',
    whatMakesUsDifferent: '',
    differentiators: [],
    whyUs: [],
    responsibleTourism: [],
    rootNetworkUrl: '',
    responsibleTourismPoints: [],
    founderBio: [],
    founderName: '',
    founderInstagramUrl: '',
  );

  bool get isEmpty => whoWeAre.isEmpty && whyUs.isEmpty && founderBio.isEmpty;
}