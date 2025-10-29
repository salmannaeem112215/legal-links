// ignore_for_file: library_private_types_in_public_api

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'package:legal_links_app/resources/resources.dart';
import 'package:legal_links_app/utils/common-widgets/custom_app_button.dart';

import 'package:sizer/sizer.dart';

class PDFViewWidget extends StatefulWidget {
  final String path;
  final bool isForSubmit;

  const PDFViewWidget({Key? key, required this.path, this.isForSubmit = true}) : super(key: key);

  @override
  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFViewWidget> with WidgetsBindingObserver {
  final Completer<PDFViewController> _controller = Completer<PDFViewController>();
  int? pages = 0;
  int? currentPage = 0;
  bool isReady = false;
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      color: R.colors.white,
      child: SafeArea(
        top: false,
        child: Scaffold(
            backgroundColor: R.colors.white,
            appBar: AppBar(
                backgroundColor: R.colors.transparent,
                elevation: 0,
                centerTitle: true,
                leading: InkWell(
                  onTap: () {
                    Get.back(result: false);
                  },
                  child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      child: Icon(Icons.arrow_back_rounded, color: R.colors.primary)),
                ),
                title: Text(
                  "view",
                  style: R.textStyles.poppinsRegular(color: R.colors.primary, fontSize: 14),
                )),
            body: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Expanded(
                    child: Stack(
                      children: <Widget>[
                        PDFView(
                          filePath: widget.path,
                          enableSwipe: true,
                          swipeHorizontal: true,
                          autoSpacing: false,
                          pageFling: true,
                          pageSnap: true,
                          defaultPage: currentPage!,
                          fitPolicy: FitPolicy.BOTH,
                          preventLinkNavigation:
                              false, // if set to true the link is handled in flutter
                          onRender: (_pages) {
                            setState(() {
                              pages = _pages;
                              isReady = true;
                            });
                          },
                          onError: (error) {
                            setState(() {
                              errorMessage = error.toString();
                            });
                            print(error.toString());
                          },
                          onPageError: (page, error) {
                            setState(() {
                              errorMessage = '$page: ${error.toString()}';
                            });
                            print('$page: ${error.toString()}');
                          },
                          onViewCreated: (PDFViewController pdfViewController) {
                            _controller.complete(pdfViewController);
                          },
                          onLinkHandler: (String? uri) {
                            print('goto uri: $uri');
                          },
                          onPageChanged: (int? page, int? total) {
                            print('page change: $page/$total');
                            setState(() {
                              currentPage = page;
                            });
                          },
                        ),
                        errorMessage.isEmpty
                            ? !isReady
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : Container()
                            : Center(
                                child: Text(errorMessage),
                              )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  // detailsRow(title: "you_are_happy_to_validate"),
                  // detailsRow(title: "compatible_to_use"),
                  // detailsRow(title: "this_document_is_clearly_readable"),
                  if (widget.isForSubmit)
                    Container(
                      color: R.colors.white,
                      width: 100.w,
                      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 10),
                      child: AppButton(
                          buttonTitle: "submit",
                          onTap: () {
                            Get.back(result: true);
                          }),
                    )
                  else
                    const SizedBox(
                      height: 10,
                    ),
                ],
              ),
            )),
      ),
    );
  }

  Widget detailsRow({required String title}) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Row(
        children: [
          Container(
            height: 7,
            width: 7,
            decoration: BoxDecoration(color: R.colors.primary, shape: BoxShape.circle),
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            title,
            style: R.textStyles.poppinsRegular(color: R.colors.red, fontSize: 10),
          )
        ],
      ),
    );
  }
}
