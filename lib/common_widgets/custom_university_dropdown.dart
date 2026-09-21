
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nwc_referral/constraints/body_text.dart';
import 'package:nwc_referral/constraints/dimensions.dart';
import '../app/modules/addOrUpdateStudentNew/models/university_list_model.dart';
import '../constraints/app_colors.dart';

class CustomUniversityDropdown extends StatelessWidget {
  final bool required;
  final bool showBorder;
  final String? labelText;
  final String? hintText;
  final List<SingleUniversity> universityList;
  final Function(SingleUniversity)? onChange;
  final SingleUniversity? selectedUniversity;

  const CustomUniversityDropdown({
    this.required = false,
    required this.universityList,
    this.labelText,
    this.hintText,
    this.showBorder = true,
    this.onChange,
    super.key,
    this.selectedUniversity
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownSearch<SingleUniversity>(
          validator: required
              ? (value) {
            if (value == null) {
              return "Required";
            }
            return null;
          }
              : null,

          onChanged: (value) {
            if (onChange != null && value != null) {
              onChange!(value);
            }
          },
          selectedItem: selectedUniversity,

          dropdownBuilder: (buildContext, university) {
            return BodyText(
              text:university?.name ?? "",
              align: TextAlign.start,
              size: 12,
              color: AppColors.levelTextColor,
            );
          },


          compareFn: (item1, item2) => item1.name == item2.name,
          itemAsString: (university) => university.name ?? "",
          items: (filter, infiniteScrollProps) => universityList,
          filterFn: (university, filter) {
            final query = filter.toLowerCase();
            return (university.name?.toLowerCase().contains(query) ?? false) ||
                (university.address?.toLowerCase().contains(query) ?? false);
          },
          decoratorProps: DropDownDecoratorProps(
            decoration: InputDecoration(
              errorMaxLines: 5,
              counterText: "",
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.borderRadius.r),
                borderSide:
                const BorderSide(color: AppColors.inactiveColor),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.borderRadius.r),
                borderSide:
                const BorderSide(color: AppColors.inactiveColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.borderRadius.r),
                borderSide:
                const BorderSide(color: AppColors.levelTextColor),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.borderRadius.r),
                borderSide:
                const BorderSide(color: AppColors.primaryColor),
              ),
              contentPadding: EdgeInsets.only(
                left: 24,
                bottom: 16.h,
                top: 16.h,
              ),
              hintText: hintText,
              labelText: required ? "$labelText *" : labelText,
              floatingLabelStyle: const TextStyle(
                color: AppColors.headerTextColor,
                fontWeight: FontWeight.bold,
              ),
              suffixIconColor: AppColors.primaryColor,
              hintStyle:  TextStyle(
                color: AppColors.levelTextColor,
                fontSize: 14.sp,
              ),
              labelStyle:  TextStyle(
                color: AppColors.levelTextColor,
                fontSize: 12.sp,
              ),
            ),
          ),
          popupProps: PopupProps.menu(
            showSearchBox: true,
            searchFieldProps: TextFieldProps(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                    vertical: 8.h, horizontal: 12.w),
                // Adjust padding to control height
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(AppDimensions.borderRadius.r),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primaryColor),
                  borderRadius: BorderRadius.circular(AppDimensions.borderRadius.r),
                ),
                hintText: "Search...",
                hintStyle: TextStyle(
                    fontSize: 12.sp), // Optional: Adjust font size if needed
              ),
            ),

            itemBuilder: (context, SingleUniversity university, isSelected, _) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8.0, vertical: 4.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(width: 16.w,),
                            Text(
                              university.name ?? "",
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: AppColors.bodyTextColor,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.start,
                            ),
                            BodyText(text: university.address??"",size: 10,align: TextAlign.start,)
                          ],
                        ),
                      ),
                      const Divider(),
                    ],
                  ),
                ),
              );
            },


            listViewProps: ListViewProps(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
            ),
          ),
        ),
      ],
    );
  }
}
