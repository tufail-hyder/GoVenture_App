import 'package:cloud_firestore/cloud_firestore.dart';

/// One-time seeder for the GoVenture appSettings/aboutUs Firestore document.
///
/// HOW TO USE:
/// 1. Temporarily call `AboutUsSeeder.seedAboutUs()` once.
/// 2. Run the app so the data is written to Firestore.
/// 3. Remove the call after successful seeding.
class AboutUsSeeder {
  static Future<void> seedAboutUs() async {
    await FirebaseFirestore.instance
        .collection('appSettings')
        .doc('aboutUs')
        .set({
      'whoWeAre':
      'GoVenture is a Pakistan-based experiential travel and tourism company dedicated to helping people explore the beauty, culture, and adventure of Pakistan. We create meaningful travel experiences for adventure seekers, families, groups, corporate clients, and individuals looking to escape the routine of everyday life. From breathtaking mountain landscapes and hidden valleys to rich cultural heritage and unforgettable local experiences, GoVenture connects travelers with the best that Pakistan has to offer.',

      'milestoneYears': '4+',
      'milestoneTravelers': '500+',
      'milestoneTours': '50+',
      'milestoneDestinations': '30+',

      'whoWeServe':
      'GoVenture provides travel and tourism services to individuals, families, groups, corporate organizations, and international visitors. Whether you are planning a weekend getaway, an adventurous expedition, a customized family vacation, or a corporate retreat, our team works to design and deliver memorable travel experiences tailored to your needs.',

      'businessPortfolioUrl': 'https://goventure.pk/',

      'whatMakesUsDifferent':
      'What makes GoVenture different is our commitment to creating authentic, well-planned, and memorable travel experiences. We combine adventure, culture, comfort, and responsible tourism to ensure every journey is enjoyable and meaningful. Our focus is not just on visiting destinations but on helping travelers connect with the people, stories, landscapes, and traditions that make Pakistan truly special.',

      'differentiators': [
        'Authentic Pakistani Travel Experiences',
        'Adventure, Cultural, and Nature Tourism',
        'Customized Trips for Individuals and Groups',
        'Professional and Reliable Travel Services',
        'Focus on Safety, Comfort, and Customer Satisfaction',
        'Support for Sustainable and Responsible Tourism',
      ],

      'whyUs': [
        'At GoVenture, we believe that travel is more than just visiting a place; it is about creating memories, discovering new perspectives, and experiencing the world in a meaningful way. Our team is dedicated to making every trip smooth, exciting, and comfortable for our travelers.',
        'Whether you are a solo traveler, a family, a group of friends, or a corporate organization, we offer carefully planned experiences that match your interests and expectations. From transportation and accommodation to activities and local exploration, we take care of the details so you can focus on enjoying the journey.',
      ],

      'responsibleTourism': [
        'We believe tourism should benefit both travelers and local communities. Pakistan is home to incredible natural landscapes, diverse cultures, historic landmarks, and welcoming communities. Our goal is to promote tourism that respects the environment, preserves local heritage, and creates positive opportunities for the communities we visit.',
        'Through responsible travel practices, we encourage travelers to respect local traditions, protect natural environments, support local businesses, and leave a positive impact wherever they go.',
      ],

      'rootNetworkUrl': '',

      'responsibleTourismPoints': [
        'Supporting Local Communities and Businesses',
        'Promoting Pakistani Culture and Heritage',
        'Encouraging Sustainable and Responsible Travel',
        'Respecting Nature and the Environment',
        'Creating Meaningful Economic Opportunities Through Tourism',
      ],

      'founderBio': [
        'GoVenture was founded by Ali Haider, a passionate entrepreneur, technology enthusiast, and travel enthusiast with a vision to make exploring Pakistan easier, more accessible, and more meaningful for everyone.',
        'With a background in technology, digital product development, and business operations, Ali Haider recognized the opportunity to combine technology with tourism to create a modern travel platform for Pakistan. His goal is to simplify the travel planning experience while connecting people with extraordinary destinations and experiences.',
        'Through GoVenture, Ali Haider aims to build a trusted travel community where people can discover the hidden beauty of Pakistan, experience its diverse cultures, and create unforgettable memories through thoughtfully designed journeys.',
      ],

      'founderName': 'Ali Haider',
      'founderInstagramUrl': '',
    }, SetOptions(merge: true));
  }
}