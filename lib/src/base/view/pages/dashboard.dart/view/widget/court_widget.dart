import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:legal_links_app/src/base/view/pages/dashboard.dart/model/chamber_model.dart';
import 'package:sizer/sizer.dart';

import '../../../../../../../resources/resources.dart';
import '../../../../../../../utils/hights_widths.dart';

// ignore: must_be_immutable
class CourtWidget extends StatefulWidget {
  ChamberModel model;

  CourtWidget({super.key, required this.model});

  @override
  State<CourtWidget> createState() => _CourtWidgetState();
}

class _CourtWidgetState extends State<CourtWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.all(4.sp),
        width: 35.w,
        decoration: BoxDecoration(
          color: R.colors.white,
          boxShadow: [
            BoxShadow(
              color: R.colors.black.withOpacity(0.1),
              offset: const Offset(-1, -1),
              blurRadius: 6,
            ),
            BoxShadow(
              color: R.colors.black.withOpacity(0.1),
              offset: const Offset(1, 1),
              blurRadius: 6,
            ),
          ],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              child: CachedNetworkImage(
                imageUrl: widget.model.image ?? "",
                fit: BoxFit.cover,
                height: 16.h,
                width: 40.w,
                errorWidget: (context, url, error) {
                  return SizedBox(
                    height: 16.h,
                    width: 40.w,
                    child: const Icon(Icons.error_rounded),
                  );
                },
              ),
            ),
            h1,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                "${widget.model.name}",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: R.textStyles.poppinsMedium(fontSize: 11),
              ),
            ),
            h1,
          ],
        ),
      ),
    );
  }
}
