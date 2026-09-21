import 'package:flutter/material.dart';
import 'package:nwc_referral/constraints/body_text.dart';
import '../../constraints/app_colors.dart'; // Import your AppColors file

class ReferringRadio extends StatefulWidget {
  final Function(String) onChanged; // Callback function
  final String? selectedOption; // Optional initial value

  const ReferringRadio({super.key, required this.onChanged, this.selectedOption});

  @override
  State<ReferringRadio> createState() => _ReferringRadioState();
}

class _ReferringRadioState extends State<ReferringRadio> {
  late String _selectedOption;

  @override
  void initState() {
    super.initState();
    // Set the initial option to the passed value or default to "Self"
    _selectedOption = widget.selectedOption ?? "Self";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BodyText(
          text: "Referring:",
          color: AppColors.headerTextColor,
          size: 14,
        ),
        Row(
          children: [
            Radio<String>(
              value: "Self",
              groupValue: _selectedOption,
              activeColor: AppColors.primaryColor, // ✅ Custom color
              onChanged: (value) {
                setState(() {
                  _selectedOption = value!;
                });
                widget.onChanged(value!); // Notify parent widget
              },
            ),
            const BodyText(text: "Self",),
            const SizedBox(width: 20),
            Radio<String>(
              value: "Others",
              groupValue: _selectedOption,
              activeColor: AppColors.primaryColor, // ✅ Custom color
              onChanged: (value) {
                setState(() {
                  _selectedOption = value!;
                });
                widget.onChanged(value!);
              },
            ),
            const BodyText(text: "Others"),
          ],
        ),
      ],
    );
  }
}
