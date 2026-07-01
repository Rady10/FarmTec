import 'package:farmtec/core/l10n/app_localizations.dart';
import 'package:farmtec/core/themes/app_fonts.dart';
import 'package:farmtec/core/themes/pallete.dart';
import 'package:farmtec/features/dashboard/presentation/widgets/moisture_circle_painter.dart';
import 'package:flutter/material.dart';

class MoistureGauge extends StatelessWidget {
  final bool isDark;
  final Color textColor;

  const MoistureGauge({
    super.key,
    required this.isDark,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return SizedBox(
      width: 78,
      child: Column(
        children: [
          SizedBox(
            width: 68,
            height: 68,
            child: CustomPaint(
              painter: MoistureCirclePainter(0.74, isDark),
              child: Center(
                child: Text(
                  l.convertNumbers('74%'),
                  style: AppFonts.font(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: textColor,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l.tr('moisture'),
            textAlign: TextAlign.center,
            style: AppFonts.font(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: isDark ? Pallete.darkTextSecondary : Pallete.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}
