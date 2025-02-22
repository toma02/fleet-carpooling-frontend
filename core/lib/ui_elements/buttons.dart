import 'package:flutter/material.dart';
import 'colors' as my_defined_colors;

class MyElevatedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final Color? backgroundColor;
  final Color? textColor;
  final bool isLoading;

  const MyElevatedButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.backgroundColor,
    this.textColor,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24.0, 12, 24, 12),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 54,
              child: ElevatedButton(
                onPressed: isLoading ? null : onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: backgroundColor ??
                      my_defined_colors.AppColors.buttonColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                ),
                child: isLoading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            textColor ??
                                my_defined_colors.AppColors.primaryColor,
                          ),
                        ),
                      )
                    : Text(
                        label,
                        style: TextStyle(
                          color: textColor ??
                              my_defined_colors.AppColors.primaryColor,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MyRadioButton extends StatefulWidget {
  final String title;
  final ValueChanged<bool?> onChanged;
  final bool value;

  const MyRadioButton(
      {super.key,
      required this.title,
      required this.onChanged,
      required this.value});

  @override
  // ignore: library_private_types_in_public_api
  _MyRadioButtonState createState() => _MyRadioButtonState();
}

class _MyRadioButtonState extends State<MyRadioButton> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        widget.title,
        style:
            const TextStyle(color: my_defined_colors.AppColors.mainTextColor),
      ),
      leading: Radio<bool>(
        fillColor: MaterialStateColor.resolveWith(
          (Set<MaterialState> states) {
            return my_defined_colors.AppColors.buttonColor;
          },
        ),
        value: widget.value,
        groupValue: true,
        onChanged: widget.onChanged,
      ),
    );
  }
}

class CircularIconButton extends StatelessWidget {
  final VoidCallback onPressed;

  const CircularIconButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(0),
        backgroundColor: my_defined_colors.AppColors.buttonColor,
      ),
      child: const Icon(Icons.arrow_back,
          color: my_defined_colors.AppColors.primaryColor),
    );
  }
}
