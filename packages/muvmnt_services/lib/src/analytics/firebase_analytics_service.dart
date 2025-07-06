import 'package:firebase_analytics/firebase_analytics.dart';
import 'analytics_service.dart';

class FirebaseAnalyticsService implements AnalyticsService {

  FirebaseAnalyticsService({required this.analytics});
  final FirebaseAnalytics analytics;

  @override
  Future<void> initialize() async {
    // Set analytics collection based on user preferences (could be loaded from settings)
    await setAnalyticsCollectionEnabled(true);

    // Configure any initial settings if needed
  }

  @override
  Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    await analytics.logScreenView(
      screenName: screenName,
      screenClass: screenClass,
    );
  }

  @override
  Future<void> logLogin({required String loginMethod}) async {
    await analytics.logLogin(loginMethod: loginMethod);
  }

  @override
  Future<void> logSignUp({required String signUpMethod}) async {
    await analytics.logSignUp(signUpMethod: signUpMethod);
  }

  @override
  Future<void> logViewProduct({
    required String productId,
    required String productName,
    required String category,
    required double price,
    String? currency,
    String? locationId,
  }) async {
    await analytics.logViewItem(
      items: [
        AnalyticsEventItem(
          itemId: productId,
          itemName: productName,
          itemCategory: category,
          price: price,
          currency: currency ?? 'USD',
        ),
      ],
      currency: currency ?? 'USD',
      value: price,
      // Custom parameters
      parameters: locationId != null ? {'location_id': locationId} : null,
    );
  }

  @override
  Future<void> logAddToCart({
    required String productId,
    required String productName,
    required double price,
    required int quantity,
    String? currency,
    String? locationId,
  }) async {
    await analytics.logAddToCart(
      items: [
        AnalyticsEventItem(
          itemId: productId,
          itemName: productName,
          price: price,
          quantity: quantity,
          currency: currency ?? 'USD',
        ),
      ],
      currency: currency ?? 'USD',
      value: price * quantity,
      // Custom parameters
      parameters: locationId != null ? {'location_id': locationId} : null,
    );
  }

  @override
  Future<void> logBeginCheckout({
    required List<Map<String, dynamic>> items,
    required double value,
    String? currency,
    String? coupon,
  }) async {
    final analyticsItems =
        items.map((item) {
          return AnalyticsEventItem(
            itemId: item['id'],
            itemName: item['name'],
            price: item['price'],
            quantity: item['quantity'],
            currency: currency ?? 'USD',
          );
        }).toList();

    await analytics.logBeginCheckout(
      items: analyticsItems,
      currency: currency ?? 'USD',
      value: value,
      coupon: coupon,
    );
  }

  @override
  Future<void> logPurchase({
    required String transactionId,
    required double value,
    required List<Map<String, dynamic>> items,
    String? currency,
    String? coupon,
    String? shipping,
    double? tax,
    String? locationId,
  }) async {
    final analyticsItems =
        items.map((item) {
          return AnalyticsEventItem(
            itemId: item['id'],
            itemName: item['name'],
            price: item['price'],
            quantity: item['quantity'],
            currency: currency ?? 'USD',
          );
        }).toList();

    var parameters = <String, Object>{'transaction_id': transactionId};

    if (locationId != null) {
      parameters['location_id'] = locationId;
    }

    await analytics.logPurchase(
      transactionId: transactionId,
      affiliation: 'Mobile App',
      currency: currency ?? 'USD',
      value: value,
      tax: tax,
      shipping: 0, //shipping,
      items: analyticsItems,
      coupon: coupon,
      parameters: parameters,
    );
  }

  @override
  Future<void> logSearch({
    required String searchTerm,
    String? locationId,
    String? categoryId,
  }) async {
    var parameters = <String, Object>{};

    if (locationId != null) {
      parameters['location_id'] = locationId;
    }

    if (categoryId != null) {
      parameters['category_id'] = categoryId;
    }

    await analytics.logSearch(
      searchTerm: searchTerm,
      parameters: parameters.isNotEmpty ? parameters : null,
    );
  }

  @override
  Future<void> logSelectLocation({
    required String locationId,
    required String locationName,
    double? latitude,
    double? longitude,
  }) async {
    // Custom event for location selection
    var parameters = <String, Object>{
      'location_id': locationId,
      'location_name': locationName,
    };

    if (latitude != null && longitude != null) {
      parameters['latitude'] = latitude.toString();
      parameters['longitude'] = longitude.toString();
    }

    await analytics.logEvent(name: 'select_location', parameters: parameters);
  }

  @override
  Future<void> logViewCategory({
    required String categoryId,
    required String categoryName,
    String? locationId,
  }) async {
    var parameters = <String, Object>{};

    if (locationId != null) {
      parameters['location_id'] = locationId;
    }

    await analytics.logViewItemList(
      itemListId: categoryId,
      itemListName: categoryName,
      parameters: parameters.isNotEmpty ? parameters : null,
    );
  }

  @override
  Future<void> setUserProperty({
    required String name,
    required String? value,
  }) async {
    await analytics.setUserProperty(name: name, value: value);
  }

  @override
  Future<void> resetAnalyticsData() async {
    await analytics.resetAnalyticsData();
  }

  @override
  Future<void> setAnalyticsCollectionEnabled(bool enabled) async {
    await analytics.setAnalyticsCollectionEnabled(enabled);
  }
}
