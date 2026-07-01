import 'package:farmtec/core/l10n/app_localizations.dart';
import 'package:farmtec/core/themes/app_fonts.dart';
import 'package:farmtec/core/themes/pallete.dart';
import 'package:farmtec/features/my_farm/presentation/widgets/my_farm_card_style.dart';
import 'package:flutter/material.dart';

class _SoilMetric {
  final IconData icon;
  final String labelKey;
  final String value;
  final String unit;
  final String? statusKey;
  final Color color;
  final double progress;

  const _SoilMetric({
    required this.icon,
    required this.labelKey,
    required this.value,
    required this.unit,
    this.statusKey,
    required this.color,
    required this.progress,
  });
}

class FarmSoilMetricsCard extends StatelessWidget {
  final bool isDark;
  final Color cardColor;
  final Color textColor;
  final Color subColor;

  const FarmSoilMetricsCard({
    super.key,
    required this.isDark,
    required this.cardColor,
    required this.textColor,
    required this.subColor,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    const metrics = [
      _SoilMetric(
        icon: Icons.science_rounded,
        labelKey: 'ph_level',
        value: '6.5',
        unit: '',
        statusKey: 'medium',
        color: Color(0xFF9C27B0),
        progress: 0.65,
      ),
      _SoilMetric(
        icon: Icons.grain_rounded,
        labelKey: 'potassium_k',
        value: '82',
        unit: 'ppm',
        color: Color(0xFFFF9800),
        progress: 0.82,
      ),
      _SoilMetric(
        icon: Icons.water_drop_rounded,
        labelKey: 'phosphorus_p',
        value: '45',
        unit: 'ppm',
        color: Color(0xFF2196F3),
        progress: 0.45,
      ),
      _SoilMetric(
        icon: Icons.eco_rounded,
        labelKey: 'nitrogen_n',
        value: '48',
        unit: 'ppm',
        color: Color(0xFF4CAF50),
        progress: 0.48,
      ),
    ];

    return Container(
      decoration: myFarmCardDecoration(isDark, cardColor),
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (int i = 0; i < metrics.length; i++) ...[
              if (i > 0)
                VerticalDivider(
                  width: 1,
                  thickness: 1,
                  color:
                      isDark
                          ? Pallete.darkOutline.withAlpha(80)
                          : const Color(0xFFE5E7EB),
                ),
              Expanded(child: _soilMetricColumn(l, metrics[i])),
            ],
          ],
        ),
      ),
    );
  }

  Widget _soilMetricColumn(AppLocalizations l, _SoilMetric metric) {
    final unitText = metric.unit.isEmpty ? '' : ' ${l.tr(metric.unit)}';
    final statusText =
        metric.statusKey != null ? l.tr(metric.statusKey!) : null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Column(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: metric.color.withAlpha(20),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(metric.icon, color: metric.color, size: 15),
          ),
          const SizedBox(height: 6),
          Text(
            l.tr(metric.labelKey),
            style: AppFonts.font(fontSize: 8, color: subColor),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            l.convertNumbers(metric.value),
            style: AppFonts.font(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: textColor,
            ),
          ),
          if (statusText != null)
            Text(
              statusText,
              style: AppFonts.font(
                fontSize: 8,
                fontWeight: FontWeight.w600,
                color: metric.color,
              ),
            )
          else if (unitText.isNotEmpty)
            Text(
              unitText.trim(),
              style: AppFonts.font(fontSize: 8, color: subColor),
              textAlign: TextAlign.center,
            ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: metric.progress,
              minHeight: 4,
              backgroundColor:
                  isDark ? Pallete.darkSurfaceVariant : const Color(0xFFEEF2EC),
              valueColor: AlwaysStoppedAnimation(metric.color),
            ),
          ),
        ],
      ),
    );
  }
}
