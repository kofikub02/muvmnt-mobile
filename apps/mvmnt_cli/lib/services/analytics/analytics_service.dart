abstract class AnalyticsService {
  /// Initialize the analytics service
  Future<void> initialize();

  /// Log a screen view event
  Future<void> logScreenView({required String screenName, String? screenClass});

  /// Log a user sign-in event
  Future<void> logLogin({required String loginMethod});

  /// Log a user sign-up event
  Future<void> logSignUp({required String signUpMethod});

  /// Log a product view event
  Future<void> logViewProduct({
    required String productId,
    required String productName,
    required String category,
    required double price,
    String? currency,
    String? locationId,
  });

  /// Log adding a product to cart
  Future<void> logAddToCart({
    required String productId,
    required String productName,
    required double price,
    required int quantity,
    String? currency,
    String? locationId,
  });

  /// Log beginning the checkout process
  Future<void> logBeginCheckout({
    required List<Map<String, dynamic>> items,
    required double value,
    String? currency,
    String? coupon,
  });

  /// Log purchase completion
  Future<void> logPurchase({
    required String transactionId,
    required double value,
    required List<Map<String, dynamic>> items,
    String? currency,
    String? coupon,
    String? shipping,
    double? tax,
    String? locationId,
  });

  /// Log search event
  Future<void> logSearch({
    required String searchTerm,
    String? locationId,
    String? categoryId,
  });

  /// Log location selection
  Future<void> logSelectLocation({
    required String locationId,
    required String locationName,
    double? latitude,
    double? longitude,
  });

  /// Log category view
  Future<void> logViewCategory({
    required String categoryId,
    required String categoryName,
    String? locationId,
  });

  /// Set user properties
  Future<void> setUserProperty({required String name, required String? value});

  /// Reset analytics data for current user
  Future<void> resetAnalyticsData();

  /// Enable or disable analytics collection
  Future<void> setAnalyticsCollectionEnabled(bool enabled);
}
