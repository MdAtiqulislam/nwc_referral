import 'package:flutter/material.dart';
import 'package:nwc_referral/constraints/body_text.dart';
import '../constraints/app_colors.dart';

class ImmigrationHistoryRadio extends StatefulWidget {
  final Function(String) onChanged; // Callback function
  final String? selectedOption; // Nullable selected option

  const ImmigrationHistoryRadio({
    super.key,
    required this.onChanged,
    this.selectedOption, // Allowing external value
  });

  @override
  State<ImmigrationHistoryRadio> createState() => _ImmigrationHistoryRadioState();
}

class _ImmigrationHistoryRadioState extends State<ImmigrationHistoryRadio> {
  late String _selectedOption;

  @override
  void initState() {
    super.initState();
    _selectedOption = widget.selectedOption ?? "No"; // Default to "No" if null
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const BodyText(
          text: "Previous Visa Refusal:",
          color: AppColors.headerTextColor,
          size: 14,
        ),
        Row(
          children: [
            Radio<String>(
              value: "No",
              groupValue: _selectedOption,
              activeColor: AppColors.primaryColor,
              onChanged: (value) {
                setState(() {
                  _selectedOption = value!;
                });
                widget.onChanged(value!);
              },
            ),
            const BodyText(text: "No"),
            const SizedBox(width: 20),
            Radio<String>(
              value: "Yes",
              groupValue: _selectedOption,
              activeColor: AppColors.primaryColor,
              onChanged: (value) {
                setState(() {
                  _selectedOption = value!;
                });
                widget.onChanged(value!);
              },
            ),
            const BodyText(text: "Yes"),
          ],
        ),
      ],
    );
  }
}
