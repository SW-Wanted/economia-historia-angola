import 'package:flutter/material.dart';

import '../core/constants/app_spacing.dart';
import '../core/utils/responsive.dart';
import 'app_header.dart';

class ScreenFrame extends StatelessWidget {
  const ScreenFrame({
    super.key,
    required this.children,
    this.title,
    this.showBack = false,
    this.paddingBottom = 28,
    this.floatingActionButton,
  });

  final List<Widget> children;
  final String? title;
  final bool showBack;
  final double paddingBottom;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: title == null ? null : AppHeader(title: title!, showBack: showBack),
      floatingActionButton: floatingActionButton,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: Responsive.maxWidth(context)),
            child: ListView(
              padding: EdgeInsets.fromLTRB(AppSpacing.margin, title == null ? 20 : 16, AppSpacing.margin, paddingBottom),
              children: children,
            ),
          ),
        ),
      ),
    );
  }
}
