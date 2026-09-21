import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nwc_referral/constraints/dimensions.dart';
import 'package:path/path.dart' as path;

import '../../../../constraints/app_colors.dart';
import '../../../../constraints/body_text.dart';
import '../../../../constraints/header_text.dart';

class SingleUploadedDocument extends StatelessWidget {
  final String fileName;
  final String? fileUrl;
  final String? comments;
  final Function()? onPreview;
  final Function(String newName)? onRename;
  final Function()? onDelete;

  const SingleUploadedDocument({
    required this.fileName,
    this.fileUrl,
    this.comments,
    this.onPreview,
    this.onRename,
    this.onDelete,
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
          ),
        ],
      ),
      padding: const EdgeInsets.all(AppDimensions.contentPadding),
      child: InkWell(
        onTap: onPreview,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.file_copy_outlined),
            SizedBox(width: 8.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeaderText(
                    text: fileName,
                    align: TextAlign.start,
                    maxLine: 1,
                    size: 14,
                  ),
                  BodyText(text: "Uploaded at: 16/12/2024",align: TextAlign.end,size: 12,),
                ],
              ),
            ),
            InkWell(
              child: Icon(Icons.edit, color: AppColors.secondaryColor,size: 18,),
              onTap: () async {
                 {
                  final fileNameWithoutExt =
                  path.basenameWithoutExtension(fileName); // Remove extension

                  String? newName = await showDialog<String>(
                    context: context,
                    builder: (context) {
                      String tempName = fileNameWithoutExt;
                      return AlertDialog(
                        title: const Text("Rename Document"),
                        content: TextField(
                          onChanged: (value) {
                            tempName = value;
                          },
                          decoration: const InputDecoration(
                            hintText: "Enter new name",
                          ),
                          controller: TextEditingController(
                            text: fileNameWithoutExt,
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, null),
                            child: const Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, tempName),
                            child: const Text("Rename"),
                          ),
                        ],
                      );
                    },
                  );

                  if (newName != null && newName.isNotEmpty) {
                    final updatedName =
                        '$newName${path.extension(fileName)}'; // Add the original extension back
                    onRename!(updatedName);
                  }
                }
              },
            ),
            /*SizedBox(width: AppDimensions.contentPadding.w,),
            InkWell(
              onTap: onDelete,
              child: Icon(Icons.delete, color: Colors.red,size: 18,),
            ),*/
          ],
        ),
      ),
    );
  }
}
