import 'package:cloud_firestore/cloud_firestore.dart';

class ExchangeRateService {
  static const double _fallbackUsdToPkr = 279.0;

  static Future<double> getUsdToPkrRate() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('settings')
          .doc('exchangeRates')
          .get();
      final rate = doc.data()?['usdToPkr'];
      if (rate is num && rate > 0) return rate.toDouble();
      return _fallbackUsdToPkr;
    } catch (_) {
      return _fallbackUsdToPkr;
    }
  }
}