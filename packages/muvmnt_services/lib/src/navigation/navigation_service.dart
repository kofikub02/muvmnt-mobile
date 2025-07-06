abstract class NavigationService {
  Future<void> navigateToScreen(String route, {Object? arguments});
  Future<void> navigateAndReplace(String route, {Object? arguments});
  Future<void> goBack();
}
