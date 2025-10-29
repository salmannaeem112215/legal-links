// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:legal_links_app/src/auth/model/user_model.dart';
import 'package:legal_links_app/src/base/view/pages/dashboard.dart/view/lawyer_detail_screen.dart';
import 'package:sizer/sizer.dart';

import '../../../../../../../resources/resources.dart';
import '../../../../../../../utils/hights_widths.dart';

class LawyerWidget extends StatefulWidget {
  UserModel model;

  LawyerWidget({super.key, required this.model});

  @override
  State<LawyerWidget> createState() => _LawyerWidgetState();
}

class _LawyerWidgetState extends State<LawyerWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        debugPrint('clsdj');
        visitProfileFn();
      },
      child: Container(
        margin: EdgeInsets.all(4.sp),
        padding: EdgeInsets.all(8.sp),
        width: 60.w,
        // height: 15.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: R.colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.20),
              offset: const Offset(-5, -2),
              blurRadius: 12,
            ),
            BoxShadow(
              color: Colors.grey.withOpacity(0.20),
              offset: const Offset(3, 3),
              blurRadius: 12,
            ),
          ],
          gradient: LinearGradient(
            colors: [
              R.colors.champagne,
              R.colors.lightPrimary,
              R.colors.primary,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: CachedNetworkImage(
                    imageUrl: widget.model.profileImages?.first ?? '',
                    imageBuilder: (context, imageProvider) => Container(
                      height: 14.w,
                      width: 14.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: R.colors.white, width: 1),
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
                        child:
                            CircularProgressIndicator.adaptive(backgroundColor: R.colors.primary),
                      ));
                    },
                  ),
                ),
                w2,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${widget.model.fullName}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: R.textStyles.poppinsSemiBold(fontSize: 11, color: R.colors.white),
                      ),
                      Text(
                        "${widget.model.specialist?.first}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: R.textStyles.poppinsRegular(fontSize: 10, color: R.colors.white),
                      ),
                      Text(
                        " ${widget.model.yearOfExperience}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: R.textStyles.poppinsRegular(fontSize: 10, color: R.colors.white),
                      ),
                    ],
                  ),
                ),
                h1,
              ],
            ),
            h2,
            Row(
              children: [
                RatingBar.builder(
                  initialRating: 2.0,
                  itemSize: 10.sp,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 1,
                  //itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: R.colors.orange,
                  ),
                  onRatingUpdate: (rating) {},
                ),
                Text(
                  '4.5/8',
                  style: R.textStyles.poppinsSemiBold(color: R.colors.white),
                ),
                const Spacer(),
                Text(
                  "${widget.model.feePerMeeting?.toStringAsFixed(2)}",
                  style: R.textStyles.poppinsSemiBold(color: R.colors.white),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void visitProfileFn() {
    Get.toNamed(LawyerDetailsScrren.route, arguments: {"model": widget.model});
  }
}
