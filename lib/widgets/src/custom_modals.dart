import 'package:employee_work/core/extensions/extension.dart';
import 'package:flutter/material.dart';

class CustomModal {
  static Future<void> showRoundedModal(
    BuildContext context,
    Widget Function(BuildContext) builder, {
    double radius = 12,
  }) {
    return showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(radius)),
      ),
      backgroundColor: context.colors.neutral100,
      context: context,
      builder: builder,
    );
  }

  static Future<void> normalMainModal(
    BuildContext context,
    Widget Function(BuildContext) builder,
  ) {
    return showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      backgroundColor: context.colors.neutral0,
      context: context,
      builder: (modalContext) => Container(
        padding: const EdgeInsets.all(16),
        height: 250 + MediaQuery.viewInsetsOf(context).bottom / 2,
        child: builder(modalContext),
      ),
    );
  }

  static Future<void> longModal(
    BuildContext context,
    Widget Function(BuildContext) builder,
  ) {
    return showModalBottomSheet(
      isScrollControlled: true, // Enables full-screen modal
      enableDrag: false, // Disables scroll dismiss
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      backgroundColor: context.colors.white,
      context: context,
      builder: (BuildContext bottomSheetContext) => FractionallySizedBox(
        heightFactor: 0.80, // Takes the full height of the screen
        child: Padding(
          padding: EdgeInsets.only(
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: builder(bottomSheetContext),
        ),
      ),
    );
  }

  static Future<void> fullModal(
    BuildContext context,
    Widget Function(BuildContext) builder,
  ) {
    return showModalBottomSheet(
      isScrollControlled: true, // Enables full-screen modal
      enableDrag: false, // Disables scroll dismiss
      backgroundColor: context.colors.white,
      context: context,
      builder: (BuildContext bottomSheetContext) => FractionallySizedBox(
        heightFactor: 1, // Takes the full height of the screen
        child: builder(bottomSheetContext),
      ),
    );
  }
}
