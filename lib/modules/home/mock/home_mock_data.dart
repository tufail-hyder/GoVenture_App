import '../../../models/trip_model.dart';
import '../../../models/banner_model.dart';
import '../../../models/blog_model.dart';
import '../../../models/upcoming_booking_model.dart';
import '../../../core/constants/app_text.dart';

class HomeMockData {
  static List<TripModel> trips({int count = 4}) {
    return List.generate(count, (i) {
      return TripModel(
        id: 'mock_trip_$i',
        title: 'Sample Trip ${i + 1}',
        slug: 'sample-trip-${i + 1}',
        location: 'Hunza Valley',
        price: 25000 + (i * 5000),
        duration: 3 + i,
        type: [AppTexts.tripTypeAdventure, AppTexts.tripTypeWorkcation, AppTexts.tripTypeRetreat][i % 3],
        coverImage: 'https://picsum.photos/seed/trip$i/400/300',
        gallery: const [],
        shortDescription: 'This is placeholder trip data for UI testing.',
        itinerary: const [],
        inclusions: const ['Sample Inclusion'],
        exclusions: const ['Sample Exclusion'],
        mapEmbedUrl: '',
        isFeatured: true,
        isActive: true,
        viewCount: 50,
        bookingsCount: 5,
      );
    });
  }

  static List<TripModel> experiences({int count = 3}) {
    final tags = ['Trekking', 'Camping', 'Rafting'];
    return List.generate(count, (i) {
      return TripModel(
        id: 'mock_exp_$i',
        title: tags[i % tags.length],
        slug: 'mock-experience-$i',
        location: 'Gilgit-Baltistan',
        price: 20000,
        duration: 3,
        type: AppTexts.tripTypeAdventure,
        coverImage: 'https://picsum.photos/seed/exp$i/400/400',
        gallery: const [],
        shortDescription: '',
        itinerary: const [],
        inclusions: const [],
        exclusions: const [],
        mapEmbedUrl: '',
        isFeatured: false,
        isActive: true,
        isTopExperience: true,
        experienceTag: tags[i % tags.length],
      );
    });
  }

  static BannerModel banner() {
    return BannerModel(
      id: 'mock_banner',
      imageUrl: 'https://picsum.photos/seed/banner/600/300',
      title: 'Summer Escape — Hunza Workcation',
      description: 'Work from the mountains this summer. Limited seats, 20% off.',
      ctaText: 'Book Now',
      ctaLink: '',
      isActive: true,
    );
  }

  static List<BlogModel> blogs({int count = 2}) {
    return List.generate(count, (i) {
      return BlogModel(
        id: 'mock_blog_$i',
        title: 'Sample Blog Post ${i + 1}',
        slug: 'sample-blog-${i + 1}',
        coverImage: 'https://picsum.photos/seed/blog$i/200/150',
        category: 'Travel Guide',
        excerpt: 'Placeholder blog excerpt for UI testing.',
        isPublished: true,
        publishedAt: DateTime.now(),
      );
    });
  }

  static List<UpcomingBookingModel> upcomingBookings({int count = 2}) {
    return List.generate(count, (i) {
      return UpcomingBookingModel(
        id: 'mock_booking_$i',
        tripId: 'mock_trip_$i',
        tripTitle: 'Sample Booked Trip ${i + 1}',
        tripImage: 'https://picsum.photos/seed/booking$i/150/150',
        travelDate: DateTime.now().add(Duration(days: 10 + i)),
        status: AppTexts.bookingUpcoming,
      );
    });
  }
}