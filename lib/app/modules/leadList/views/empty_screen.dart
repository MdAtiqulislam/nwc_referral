import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../constraints/header_text.dart';
import '../controllers/lead_list_controller.dart';


class EmptyScreen extends GetView<LeadListController> {
  const EmptyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child:Column(
          children: [
            SizedBox(height:32.h// AppDimensions.sectionPaddingVer,
            ),
            const HeaderText(text: "You currently have no student added.",),
            SizedBox(height:16.h// AppDimensions.widgetPaddingVer,
            ),
            const Divider(thickness: .5,)
          ],
        ),)
      ],
    );
  }
}
