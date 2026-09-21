import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nwc_referral/constraints/body_text.dart';
import 'package:nwc_referral/constraints/dimensions.dart';
import 'package:path/path.dart' as path;

import '../../../../constraints/app_colors.dart';
import '../../../../constraints/header_text.dart';

class SingleSelectedDocument extends StatelessWidget {
  final Map<String, dynamic> document;
  final void Function(String newName) onRename; // Callback for rename
  final void Function() onDelete; // Callback for delete
  final Function()? onPreview;

  const SingleSelectedDocument({
    required this.document,
    required this.onRename,
    required this.onDelete,
    required this.onPreview,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.levelTextColor, width: .1),
        borderRadius: BorderRadius.all(Radius.circular(15.r)),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 2,
          )
        ],
      ),
      padding: EdgeInsets.all(AppDimensions.contentPadding),
      child: InkWell(
        onTap: onPreview,
        child: Row(
          children: [
            const Icon(Icons.file_copy_outlined),
            SizedBox(width: 8.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeaderText(
                    text: document['name'] ?? 'Unnamed Document',
                    align: TextAlign.start,
                    maxLine: 1,
                    size: 14,
                  ),
                  Row(
                    children: [
                      Icon(Icons.arrow_upward,color: Colors.green,size: 12,),
                      BodyText(
                        text: "Ready to upload",
                        align: TextAlign.end,
                        size: 12,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            InkWell(
              child: Icon(
                Icons.edit,
                color: AppColors.secondaryColor,
                size: 18,
              ),
              onTap: () async {
                final fileNameWithExt =
                    document['name'] ?? ''; // Get full name with extension
                final fileName = path.basenameWithoutExtension(
                    fileNameWithExt); // Remove extension

                // Show a dialog to rename the document
                String? newName = await showDialog<String>(
                  context: context,
                  builder: (context) {
                    String tempName =
                        fileName; // Start with the file name without extension
                    return AlertDialog(
                      title: Text("Rename Document"),
                      content: TextField(
                        onChanged: (value) {
                          tempName = value;
                        },
                        decoration: InputDecoration(
                          hintText: "Enter new name",
                        ),
                        controller: TextEditingController(
                          text: fileName, // Show only the name without extension
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, null),
                          child: Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, tempName),
                          child: Text("Rename"),
                        ),
                      ],
                    );
                  },
                );

                if (newName != null && newName.isNotEmpty) {
                  final updatedName =
                      '$newName${path.extension(fileNameWithExt)}'; // Add the original extension back
                  onRename(updatedName); // Call the rename callback
                }
              },
            ),
            SizedBox(width: AppDimensions.contentPadding.w,),
            InkWell(
              child: Icon(
                Icons.delete,
                color: Colors.red,
                size: 18,
              ),
              onTap: () {
                onDelete(); // Call the delete callback
              },
            ),
          ],
        ),
      ),
    );
  }
}
