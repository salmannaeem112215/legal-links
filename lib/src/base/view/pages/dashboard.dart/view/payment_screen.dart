import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:legal_links_app/resources/resources.dart';
import 'package:legal_links_app/src/base/view/pages/settings/model/content_model.dart';
import 'package:legal_links_app/src/base/view/pages/settings/vm/settings_vm.dart';
import 'package:legal_links_app/utils/common-widgets/custom_button.dart';
import 'package:legal_links_app/utils/common-widgets/global_widget.dart';
import 'package:legal_links_app/utils/common-widgets/payment_confirmation_dialog.dart';
import 'package:legal_links_app/utils/hights_widths.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class PaymentScreen extends StatefulWidget {
  static String route = '/paymentscreen';

  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  // late PaymentMethod model;

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsVM>(builder: (context, vm, _) {
      return Scaffold(
        appBar: GlobalWidgets.appBar('Payment'),
        bottomNavigationBar: buttons(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              ...List.generate(
                vm.contentModel.paymentMethod?.length ?? 0,
                (index) => paymentWidget(
                  vm.contentModel.paymentMethod![index],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget paymentWidget(PaymentMethod model) {
    debugPrint("model.name ${model.providerName}||||||");
    return InkWell(
      onTap: () async {
        Get.dialog(PaymentConfirmationDialog(model: model));
      },
      child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 6.sp),
          child: Container(
            padding: EdgeInsets.all(7.sp),
            decoration: BoxDecoration(
              border: Border.all(color: R.colors.grey),
              color: R.colors.white.withOpacity(.05),
              borderRadius: BorderRadius.circular(10.sp),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: CachedNetworkImage(
                        imageUrl: model.image ?? "",
                        imageBuilder: (context, imageProvider) => Container(
                          height: 14.w,
                          width: 14.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: R.colors.red, width: 1),
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        fit: BoxFit.cover,
                        errorWidget: (context, url, e) =>
                            SizedBox(height: 14.w, width: 14.w, child: const Icon(Icons.error)),
                        placeholder: (context, url) {
                          return Center(
                              child: SizedBox(
                            height: 14.w,
                            width: 14.w,
                            child: CircularProgressIndicator.adaptive(
                              backgroundColor: R.colors.primary,
                            ),
                          ));
                        },
                      ),
                    ),
                    w3,
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${model.providerName}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                              R.textStyles.poppinsSemiBold(fontSize: 11, color: R.colors.black),
                        ),
                        rowTextWidget(title: "Name:", txt: model.userName ?? ""),
                        rowTextWidget(title: "Account Number:", txt: model.accountNumber ?? ""),
                        if (model.iban != null)
                          rowTextWidget(title: "IBAN:", txt: model.iban ?? ""),
                        if (model.branchName != null)
                          rowTextWidget(title: "Branch Name:", txt: model.branchName ?? ""),
                      ],
                    ))
                  ],
                )
              ],
            ),
          )),
    );
  }

  Row rowTextWidget({required String title, required String txt}) {
    return Row(
      children: [
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: R.textStyles.poppinsSemiBold(fontSize: 10, color: R.colors.primary),
        ),
        w1,
        Text(
          txt,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: R.textStyles.poppinsRegular(fontSize: 10, color: R.colors.primary),
        ),
      ],
    );
  }

  Widget buttons() {
    return Padding(
      padding: EdgeInsets.all(10.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: CustomButton(
              color: R.colors.primary,
              buttonTitle: "Book Now",
              tap: () async {
                // TODO: PAYMENT SCREEN TAP
                // await btnTap();
                // Get.back();
              },
              textColor: R.colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
