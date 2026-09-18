import 'package:share_plus/share_plus.dart';
import '../models/trip_model.dart';

class ShareService {
  static Future<void> shareTrip(TripModel trip) async {
    final text =
        'Check out this amazing trip: ${trip.title}\n'
        '${trip.location} · ${trip.duration} Days\n'
        'Starting from PKR ${trip.price.toStringAsFixed(0)}\n\n'
        'Book now on GoVenture!';

    await SharePlus.instance.share(ShareParams(text: text));
  }
}