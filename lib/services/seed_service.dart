// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../core/constants/app_text.dart';
//
// class SeedService {
//   static final _firestore = FirebaseFirestore.instance;
//
//   /// ===== Trips =====
//   static Future<void> seedTrips() async {
//     final tripsRef = _firestore.collection(AppTexts.colTrips);
//
//     final trips = [
//       {
//         'title': 'Skardu Adventure Trek',
//         'slug': 'skardu-adventure-trek',
//         'location': 'Skardu, Baltistan',
//         'price': 45000,
//         'duration': 5,
//         'type': AppTexts.tripTypeAdventure,
//         'coverImage': '',
//         'gallery': <String>[],
//         'shortDescription': 'A thrilling trek through Skardu valleys.',
//         'itinerary': [
//           {'day': 1, 'title': 'Arrival', 'description': 'Arrive in Skardu, hotel check-in.'},
//           {'day': 2, 'title': 'Trek Start', 'description': 'Begin trek towards base camp.'},
//         ],
//         'inclusions': ['Accommodation', 'Meals', 'Guide'],
//         'exclusions': ['Airfare', 'Personal expenses'],
//         'mapEmbedUrl': '',
//         'isFeatured': true,
//         'isActive': true,
//         'viewCount': 120,
//         'bookingsCount': 18,
//       },
//       {
//         'title': 'Hunza Valley Workcation',
//         'slug': 'hunza-valley-workcation',
//         'location': 'Hunza, Gilgit-Baltistan',
//         'price': 38000,
//         'duration': 7,
//         'type': AppTexts.tripTypeWorkcation,
//         'coverImage': '',
//         'gallery': <String>[],
//         'shortDescription': 'Work remotely with a view of the Karakoram peaks.',
//         'itinerary': [
//           {'day': 1, 'title': 'Arrival & Setup', 'description': 'Check-in, co-working space orientation.'},
//           {'day': 2, 'title': 'Work Day', 'description': 'High-speed wifi, mountain-view desks.'},
//         ],
//         'inclusions': ['Co-working space', 'Wifi', 'Breakfast'],
//         'exclusions': ['Airfare', 'Lunch/Dinner'],
//         'mapEmbedUrl': '',
//         'isFeatured': true,
//         'isActive': true,
//         'viewCount': 95,
//         'bookingsCount': 12,
//       },
//       {
//         'title': 'Naran Kaghan Retreat',
//         'slug': 'naran-kaghan-retreat',
//         'location': 'Naran, KPK',
//         'price': 22000,
//         'duration': 3,
//         'type': AppTexts.tripTypeRetreat,
//         'coverImage': '',
//         'gallery': <String>[],
//         'shortDescription': 'A peaceful escape into the lakes and meadows of Naran.',
//         'itinerary': [
//           {'day': 1, 'title': 'Arrival', 'description': 'Check-in, evening bonfire.'},
//           {'day': 2, 'title': 'Saif-ul-Malook', 'description': 'Visit the famous lake.'},
//         ],
//         'inclusions': ['Accommodation', 'Breakfast', 'Bonfire'],
//         'exclusions': ['Transport', 'Lunch/Dinner'],
//         'mapEmbedUrl': '',
//         'isFeatured': false,
//         'isActive': true,
//         'viewCount': 60,
//         'bookingsCount': 7,
//       },
//       {
//         'title': 'Fairy Meadows Camping',
//         'slug': 'fairy-meadows-camping',
//         'location': 'Fairy Meadows, Diamer',
//         'price': 30000,
//         'duration': 4,
//         'type': AppTexts.tripTypeAdventure,
//         'coverImage': '',
//         'gallery': <String>[],
//         'shortDescription': 'Camp under Nanga Parbat with panoramic mountain views.',
//         'itinerary': [
//           {'day': 1, 'title': 'Jeep Ride', 'description': 'Ride to Fairy Meadows base.'},
//           {'day': 2, 'title': 'Camping', 'description': 'Overnight camp with bonfire.'},
//         ],
//         'inclusions': ['Camping gear', 'Meals', 'Guide'],
//         'exclusions': ['Airfare'],
//         'mapEmbedUrl': '',
//         'isFeatured': false,
//         'isActive': true,
//         'viewCount': 150,
//         'bookingsCount': 25,
//       },
//     ];
//
//     for (final trip in trips) {
//       await tripsRef.add({
//         ...trip,
//         'createdAt': FieldValue.serverTimestamp(),
//         'updatedAt': FieldValue.serverTimestamp(),
//       });
//     }
//     print('✅ Trips seeded (${trips.length})');
//   }
//
//   /// ===== Announcements / Seasonal Banner (Admin-controlled) =====
//   static Future<void> seedAnnouncements() async {
//     await _firestore.collection(AppTexts.colAnnouncements).add({
//       'imageUrl': '',
//       'title': 'Summer Escape — Hunza Workcation',
//       'description': 'Work from the mountains this summer. Limited seats, 20% off.',
//       'ctaText': 'Book Now',
//       'ctaLink': '', // future: yahan ek tripId daal dein taake CTA us trip par le jaye
//       'isActive': true,
//       'startDate': Timestamp.now(),
//       'endDate': Timestamp.fromDate(DateTime.now().add(const Duration(days: 30))),
//     });
//     print('✅ Announcement banner seeded');
//   }
//
//   /// ===== Blogs =====
//   static Future<void> seedBlogs() async {
//     final blogsRef = _firestore.collection(AppTexts.colBlogs);
//
//     final blogs = [
//       {
//         'title': '10 Best Places to Visit in Pakistan',
//         'slug': '10-best-places-to-visit-in-pakistan',
//         'coverImage': '',
//         'category': 'Travel Guide',
//         'excerpt': 'From Hunza to Skardu — our top picks for your next trip.',
//         'isPublished': true,
//       },
//       {
//         'title': 'Top 5 Work-from-Mountain Spots',
//         'slug': 'top-5-work-from-mountain-spots',
//         'coverImage': '',
//         'category': 'Workcation',
//         'excerpt': 'Fast wifi, fresh air, and a change of scenery for remote workers.',
//         'isPublished': true,
//       },
//     ];
//
//     for (final blog in blogs) {
//       await blogsRef.add({
//         ...blog,
//         'publishedAt': FieldValue.serverTimestamp(),
//       });
//     }
//     print('✅ Blogs seeded (${blogs.length})');
//   }
//
//   /// ===== Sab Ek Sath Seed Karne Ke Liye =====
//   static Future<void> seedAll() async {
//     await seedTrips();
//     await seedAnnouncements();
//     await seedBlogs();
//     print('🎉 All collections seeded successfully');
//   }
// }