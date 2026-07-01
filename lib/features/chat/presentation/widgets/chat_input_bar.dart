import 'package:farmtec/core/l10n/app_localizations.dart';
import 'package:farmtec/core/themes/app_fonts.dart';
import 'package:farmtec/core/themes/pallete.dart';
import 'package:flutter/material.dart';

class ChatInputBar extends StatelessWidget {
  final bool isDark;
  final AppLocalizations l;
  final TextEditingController textController;
  final FocusNode focusNode;
  final ValueChanged<String> onSend;
  final bool isSending;

  const ChatInputBar({
    super.key,
    required this.isDark,
    required this.l,
    required this.textController,
    required this.focusNode,
    required this.onSend,
    this.isSending = false,
  });

  @override
  Widget build(BuildContext context) {
    final barBg = isDark ? Pallete.darkBackground : Pallete.background;
    final fieldBg = isDark ? Pallete.darkSurfaceVariant : const Color(0xFFF3F4F0);
    final borderClr = isDark ? Pallete.darkOutline : const Color(0xFFE2E3DC);
    final textClr = isDark ? Pallete.darkTextPrimary : Pallete.textPrimary;
    final hintClr = isDark ? Pallete.darkTextTertiary : Pallete.textHint;

    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        10,
        16,
        MediaQuery.of(context).padding.bottom + 12,
      ),
      color: barBg,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: textController,
              focusNode: focusNode,
              style: AppFonts.font(fontSize: 14, color: textClr),
              cursorColor: isDark ? Pallete.chartGreen : Pallete.primary,
              decoration: InputDecoration(
                hintText: l.tr('ask_anything'),
                hintStyle: AppFonts.font(fontSize: 14, color: hintClr),
                filled: true,
                fillColor: fieldBg,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(28),
                  borderSide: BorderSide(color: borderClr),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(28),
                  borderSide: BorderSide(color: borderClr),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(28),
                  borderSide: BorderSide(
                    color: isDark ? Pallete.chartGreen : Pallete.primary,
                    width: 1.5,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 14,
                ),
                prefixIcon: Icon(
                  Icons.attach_file_rounded,
                  color: isDark ? Pallete.darkTextTertiary : Pallete.textHint,
                  size: 20,
                ),
                isDense: true,
              ),
              enabled: !isSending,
              onSubmitted: isSending ? null : onSend,
              textInputAction: TextInputAction.send,
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: isSending ? null : () => onSend(textController.text),
            child: Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: (isDark ? Pallete.chartGreen : Pallete.primary)
                    .withAlpha(isSending ? 120 : 255),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Pallete.primary.withAlpha(40),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child:
                  isSending
                      ? const Padding(
                        padding: EdgeInsets.all(12),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                      : const Icon(
                        Icons.arrow_upward_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
            ),
          ),
        ],
      ),
    );
  }
}
