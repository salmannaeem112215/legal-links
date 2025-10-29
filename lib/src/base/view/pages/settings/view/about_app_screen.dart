import 'package:flutter/material.dart';
import 'package:legal_links_app/resources/resources.dart';
import 'package:legal_links_app/utils/common-widgets/global_widget.dart';
import 'package:legal_links_app/utils/hights_widths.dart';
import 'package:sizer/sizer.dart';

class AboutAppScreen extends StatefulWidget {
  static String route = '/aboutapp';
  const AboutAppScreen({super.key});

  @override
  State<AboutAppScreen> createState() => _AboutAppScreenState();
}

class _AboutAppScreenState extends State<AboutAppScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: GlobalWidgets.appBar('About App'),
          body: Padding(
            padding: EdgeInsets.symmetric(vertical: 2.sp, horizontal: 15.sp),
            child: Column(
              children: [
                h5,
                Text(
                  'About Legal links',
                  style: R.textStyles.poppinsBold(fontSize: 16),
                ),
                h5,
                Text(
                  'Legal Links expand your legal ecosystem by providing the facility of allow  social issues solutions just a click away. We help each individual because we are based on fair, realistic power structures. We stand side by side with individuals who are supporting communities in navigating, democratizing, and changing them.',
                  style: R.textStyles.poppinsMedium(),
                ),
                h3,
                Text(
                  'To generate a service that is exactly personalized to your demands, we will match our knowledge and expertise with theirs. This will result in high-quality work combined with impeccable client care.',
                  style: R.textStyles.poppinsMedium(),
                )
              ],
            ),
          )),
    );
  }
}
