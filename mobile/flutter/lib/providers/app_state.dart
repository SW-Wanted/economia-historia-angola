import 'package:flutter/widgets.dart';

class AppState extends ChangeNotifier {
  int _navIndex = 0;
  int _quizAnswer = -1;

  int get navIndex => _navIndex;
  int get quizAnswer => _quizAnswer;

  void setNavIndex(int value) {
    _navIndex = value;
    notifyListeners();
  }

  void selectQuizAnswer(int value) {
    _quizAnswer = value;
    notifyListeners();
  }
}

class AppStateScope extends InheritedNotifier<AppState> {
  const AppStateScope({
    super.key,
    required AppState notifier,
    required super.child,
  }) : super(notifier: notifier);

  static AppState of(BuildContext context, {bool listen = true}) {
    if (listen) {
      final scope = context.dependOnInheritedWidgetOfExactType<AppStateScope>();
      assert(scope?.notifier != null, 'AppStateScope not found in context');
      return scope!.notifier!;
    }
    final element = context.getElementForInheritedWidgetOfExactType<AppStateScope>();
    final scope = element?.widget as AppStateScope?;
    assert(scope?.notifier != null, 'AppStateScope not found in context');
    return scope!.notifier!;
  }
}
