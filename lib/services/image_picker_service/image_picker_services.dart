import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ImagePickerServices {
  // get profile image function
  static File? profileImage;
  static File? coverImage;
  static List<File>? photoIDList;

  // ✅ Utility: Save file permanently
  static Future<File> _saveImagePermanently(File imageFile) async {
    final directory = await getApplicationDocumentsDirectory();
    final fileName = "${DateTime.now().millisecondsSinceEpoch}.jpg";
    final savedImage = await imageFile.copy('${directory.path}/$fileName');
    return savedImage;
  }

  static Future<bool> checkFileSize(path, {bool isVideo = false}) async {
    var fileSizeLimit = isVideo ? 1024 * 10 : 1024 * 100;
    File f = File(path);
    var s = f.lengthSync();
    log(s.toString()); // returns in bytes
    var fileSizeInKB = s / 1024;
    // Convert the KB to MegaBytes (1 MB = 1024 KBytes)
    // var fileSizeInMB = fileSizeInKB / 1024;
    debugPrint(
        "_____________FILES SIZE IN KB:$fileSizeInKB"); // returns in bytes

    if (fileSizeInKB > fileSizeLimit) {
      debugPrint("File size greater than the limit");
      return false;
    } else {
      debugPrint("file can be selected");
      return true;
    }
  }
  // get profile image function

  static Future getProfileImage({
    bool isCamera = false,
    bool? isSizeOptional = false,
    BuildContext? context,
  }) async {
    final pickedFile = isCamera
        ? await ImagePicker().pickImage(
            source: ImageSource.camera,
            imageQuality: 85,
          )
        : await ImagePicker().pickImage(
            source: ImageSource.gallery,
            imageQuality: 85,
          );
    if (pickedFile != null) {
      // profileImage= File(pickedFile.path);
      File? croppedFile = await cropImage(
          filePath: pickedFile.path, isOptionsEnabled: isSizeOptional!);
      profileImage = File(croppedFile?.path ?? "");
    }
  }

  static List<File>? tempList = [];
  static Future<File?> cropImage(
      {required String filePath, required bool isOptionsEnabled}) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: filePath,
      aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0), // square
  uiSettings: [
    AndroidUiSettings(
      toolbarTitle: 'Crop Image',
      toolbarColor: Colors.deepOrange,
      toolbarWidgetColor: Colors.white,
      lockAspectRatio: false,
    ),
    IOSUiSettings(
      title: 'Crop Image',
    ),]
      // aspectRatioPresets: isOptionsEnabled
      //     ? [
      //         CropAspectRatioPreset.square,
      //         CropAspectRatioPreset.ratio3x2,
      //         CropAspectRatioPreset.original,
      //         CropAspectRatioPreset.ratio4x3,
      //         CropAspectRatioPreset.ratio16x9
      //       ]
      //     : [
      //         CropAspectRatioPreset.square,
      //       ],
    );
    File tempFile = File(croppedFile!.path);
    return await _saveImagePermanently(tempFile);
    return tempFile;
  }
}
