import 'package:flutter/material.dart';
import 'package:legal_links_app/src/base/view/pages/settings/vm/settings_vm.dart';
import 'package:legal_links_app/utils/hights_widths.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../../../../resources/resources.dart';
import '../../../../../../utils/common-widgets/global_widget.dart';

class TermsAndConditions extends StatelessWidget {
  static String route = "/TermOfUseScreen";
  const TermsAndConditions({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GlobalWidgets.appBar('Terms & Conditions'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 25, right: 25, top: 35),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.read<SettingsVM>().contentModel.termsOfUse ?? "",
              style: R.textStyles.poppinsRegular(
                color: R.colors.black,
                fontSize: 10,
                fontWeight: FontWeight.w400,
              ),
            ),
            h2,
          ],
        ),
      ),
    );
  }
}
