import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IconTextButton extends StatelessWidget {
  const IconTextButton({
    super.key,
    required this.label,
    this.icon,
    this.isInverted = false,
    required this.onPressed,
    this.isLoading = false,
  });

  const IconTextButton.inverted({
    super.key,
    required this.label,
    this.icon,
    this.isInverted = true,
    required this.onPressed,
    this.isLoading = false,
  });

  final String label;
  final IconData? icon;
  final bool isInverted;
  final bool isLoading;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: isInverted
            ? Colors.transparent
            : Theme.of(context).colorScheme.primary,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.4),
            width: 0.5,
          ),
          borderRadius: BorderRadius.circular(7),
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 0,
        ),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: isLoading
            ? [
                const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
              ]
            : [
                icon != null
                    ? Icon(
                        icon,
                        color: isInverted
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onPrimary,
                      )
                    : Container(),
                SizedBox(
                  width: icon != null ? 10 : 0,
                ),
                Text(
                  label,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontFamily: GoogleFonts.roboto(
                          fontWeight: FontWeight.w500,
                        ).fontFamily,
                        color: isInverted
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onPrimary,
                      ),
                ),
              ],
      ),
    );
  }
}
