import 'package:go_router/go_router.dart';
import 'package:mvmnt_cli/services/navigation/navigation_service.dart';

class NavigationServiceImpl implements NavigationService {

  NavigationServiceImpl(this._goRouter);
  final GoRouter _goRouter;

  @override
  Future<void> navigateToScreen(String route, {Object? arguments}) async {
    await _goRouter.push(route, extra: arguments);
  }

  @override
  Future<void> navigateAndReplace(String route, {Object? arguments}) async {
    await _goRouter.pushReplacement(route, extra: arguments);
  }

  @override
  Future<void> goBack() async {
    if (_goRouter.canPop()) {
      _goRouter.pop();
    }
  }
}
