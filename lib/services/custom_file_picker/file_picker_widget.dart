// ignore_for_file: must_be_immutable, library_private_types_in_public_api

import 'dart:developer';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:legal_links_app/constants/enums.dart';
import 'package:legal_links_app/resources/resources.dart';
import 'package:legal_links_app/services/custom_file_picker/image_slider.dart';
import 'package:legal_links_app/services/custom_file_picker/image_view.dart';
import 'package:legal_links_app/services/custom_file_picker/pdf_view_widget.dart';
import 'package:legal_links_app/utils/hights_widths.dart';
import 'package:open_filex/open_filex.dart';
import 'package:sizer/sizer.dart';

class FilePickerWidget extends StatefulWidget {
  List<File> list;
  ValueSetter<dynamic> onSelect;
  final bool isHideUploadButton;

  FilePickerWidget(
      {Key? key, required this.list, required this.isHideUploadButton, required this.onSelect})
      : super(key: key);

  @override
  _FilePickerWidgetState createState() => _FilePickerWidgetState();
}

class _FilePickerWidgetState extends State<FilePickerWidget> {
  List<File> list = [];
  final picker = ImagePicker();

  Future<FilePickerResult> pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: [
        'pdf',
        // 'doc',
        // 'docx',
        // 'xls',
        // 'xlsx',
        // 'png',
        // 'jpg',
        // 'jpeg',
      ],
    );
    return result!;
  }

  Future<File> getImage(bool fromCamera) async {
    File? image;
    final pickedFile =
        await picker.pickImage(source: fromCamera ? ImageSource.camera : ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        image = File(pickedFile.path);
        log(image.toString());
      } else {
        debugPrint('No image selected.');
      }
    });
    return image!;
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        for (var element in widget.list) {
          list.add(element);
          widget.onSelect(list);
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!widget.isHideUploadButton)
          GestureDetector(
            onTap: () {
              Get.bottomSheet(uploadSheet());
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Column(
                children: [
                  Container(
                    width: 15.w,
                    height: 15.w,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: R.colors.black,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                      color: R.colors.transparent,
                    ),
                    child: Image.asset(
                      R.images.upload,
                      width: 15.w,
                      height: 15.w,
                    ),
                  ),
                  h1,
                  Text(
                    "Upload",
                    style: R.textStyles.poppinsRegular(
                      color: R.colors.black,
                      fontSize: 8.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                ],
              ),
            ),
          ),
        if (!widget.isHideUploadButton)
          const SizedBox(
            width: 5,
          ),
        Expanded(
            child: Wrap(
          children: List.generate(list.length, (index) {
            return Stack(
              alignment: AlignmentDirectional.topEnd,
              children: [
                Column(
                  children: [
                    InkWell(
                      onTap: () async {
                        String fileType = list[index].path.split('.').last.toString();
                        (fileType == FileTypeEnum.jpg.name ||
                                fileType == FileTypeEnum.jpeg.name ||
                                fileType == FileTypeEnum.png.name)
                            ? SizedBox()
                            
                            // Get.dialog(ImageSlider(index: index, sliderList: list))
                            : (fileType == FileTypeEnum.pdf.name)
                                ? Get.to(() => PDFViewWidget(
                                      path: list[index].path,
                                      isForSubmit: false,
                                    ))
                                : await OpenFilex.open(list[index].path);
                      },
                      child: (list[index].path.split('.').last.toString() ==
                                  FileTypeEnum.jpg.name ||
                              list[index].path.split('.').last.toString() ==
                                  FileTypeEnum.jpeg.name ||
                              list[index].path.split('.').last.toString() == FileTypeEnum.png.name)
                          ? Container(
                              margin: const EdgeInsets.only(top: 5, left: 5, right: 2),
                              width: 15.w,
                              height: 15.w,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: FileImage(list[index]), fit: BoxFit.cover),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            )
                          : Container(
                              margin: const EdgeInsets.only(top: 5, left: 5, right: 5),
                              width: Get.width * .145,
                              height: 15.w,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                      (list[index].path.split('.').last.toString() ==
                                              FileTypeEnum.pdf.name)
                                          ? R.images.pdf
                                          : (list[index].path.split('.').last.toString() ==
                                                      FileTypeEnum.xls.name ||
                                                  list[index].path.split('.').last.toString() ==
                                                      FileTypeEnum.xlsx.name)
                                              ? R.images.xls
                                              : R.images.doc,
                                    ),
                                    fit: BoxFit.cover),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                    ),
                    h1,
                    Text(
                      "${list[index].path.split('/').last.length >= 5 ? list[index].path.split('/').last.substring(0, 5) : list[index].path.split('/').last}.${list[index].path.split('.').last}",
                      style: R.textStyles.poppinsRegular(
                        color: R.colors.black,
                        fontSize: 8.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                ),
                widget.isHideUploadButton
                    ? const SizedBox()
                    : GestureDetector(
                        onTap: () {
                          setState(() {
                            list.removeAt(index);
                          });
                        },
                        child: Container(
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                              color: R.colors.black,
                              shape: BoxShape.circle,
                              border: Border.all(color: R.colors.black),
                            ),
                            child: Center(
                              child: Icon(Icons.close, color: R.colors.white, size: 14),
                            )),
                      )
              ],
            );
          }),
        ))
      ],
    );
  }

  Widget uploadSheet() {
    return Container(
        padding: EdgeInsets.symmetric(vertical: Get.height * .02, horizontal: Get.width * 0.07),
        decoration: BoxDecoration(
          color: R.colors.white,
          borderRadius:
              const BorderRadius.only(topRight: Radius.circular(26), topLeft: Radius.circular(26)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                width: 20.w,
                height: .6.h,
                decoration: BoxDecoration(
                  color: R.colors.black,
                  borderRadius: const BorderRadius.all(Radius.circular(14)),
                )),
            SizedBox(height: 2.5.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                uploadType(image: R.images.file, title: 'document', index: 0),
                uploadType(image: R.images.camera, title: 'camera', index: 1),
                uploadType(image: R.images.gallery, title: 'gallery', index: 2),
              ],
            ),
            SizedBox(height: 2.h),
          ],
        ));
  }

  Widget uploadType({required String image, required String title, required int index}) {
    return GestureDetector(
      onTap: () async {
        switch (index) {
          case 0:
            {
              try {
                debugPrint(' Document');
                bool isSubmitted = false;

                var result = await pickFiles();
                String fileType = result.files.first.path!.split('.').last.toString();
                if ((fileType == FileTypeEnum.jpg.name ||
                    fileType == FileTypeEnum.jpeg.name ||
                    fileType == FileTypeEnum.png.name)) {
                  isSubmitted = await Get.to(ImageView(
                    path: File(result.files.first.path!),
                  ));
                } else if (fileType == FileTypeEnum.pdf.name) {
                  isSubmitted = await Get.to(() => PDFViewWidget(path: result.files.first.path!));
                } else {
                  await OpenFilex.open(result.files.first.path!);
                  isSubmitted = true;
                }

                if (isSubmitted) {
                  setState(() {
                    List<File> selectedFiles = [];
                    selectedFiles = result.paths.map((path) => File(path!)).toList();
                    selectedFiles.forEach((element) {
                      list.add(element);
                    });
                    widget.onSelect(list);
                  });
                }
                Get.back();
              } catch (e) {
                log("ERROR ON FILE PICKER 300 Line ${e.toString()}");
              }
            }
            break;
          case 1:
            debugPrint(' Camera');

            var result = await getImage(true);

            bool isSubmitted = await Get.to(ImageView(
              path: File(result.path),
            ));

            if (isSubmitted) {
              setState(() {
                List<File> selectedFiles = [];
                selectedFiles = [File(result.path)];
                selectedFiles.forEach((element) {
                  list.add(element);
                });
                widget.onSelect(list);
              });
            }

            Get.back();
            break;
          case 2:
            var result = await getImage(false);

            bool isSubmitted = await Get.to(ImageView(
              path: File(result.path),
            ));

            if (isSubmitted) {
              setState(() {
                List<File> selectedFiles = [];
                selectedFiles = [File(result.path)];
                selectedFiles.forEach((element) {
                  list.add(element);
                });
                widget.onSelect(list);
              });
            }

            Get.back();
            break;
        }
      },
      child: Column(
        children: [
          Container(
            height: 55,
            width: 55,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              color: R.colors.primary,
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: R.colors.white,
              ),
              child: Image.asset(
                image,
                color: R.colors.primary,
                height: 22,
                width: 22,
              ),
            ),
          ),
          Text(
            title,
            style: R.textStyles.poppinsRegular().copyWith(
                  color: R.colors.black,
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w500,
                  height: 2,
                ),
          ),
        ],
      ),
    );
  }
}
