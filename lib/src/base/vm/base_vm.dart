import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:legal_links_app/constants/enums.dart';
import 'package:legal_links_app/services/firebase_collections.dart';
import 'package:legal_links_app/src/auth/model/user_model.dart';
import 'package:legal_links_app/src/base/view/base_view.dart';
import 'package:legal_links_app/src/base/view/pages/appointment/model/booking_model.dart';
import 'package:legal_links_app/src/lawyer_base/view/pages/dashboard/model/lawyer_schedule_model.dart';
import 'package:legal_links_app/utils/zbot_toast.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BaseVM extends ChangeNotifier {
  int currentIndex = 0;
  List<UserModel> lawyersList = [];
  LawyerScheduleModel? lyrSchByID;
  BookingModel? tempBookingModel;

  Future<void> getAllLawyers() async {
    try {
    // var vm = Provider.of<AuthVM>(Get.context!, listen: false);
    debugPrint("getAllLawyers GETTING _________");

    ZBotToast.loadingShow();
    QuerySnapshot q = await FBCollections.users
        .where("status", isNotEqualTo: UserStatus.DELETED.index)
        .where("role", isEqualTo: UserRole.LAWYER.index)
        .get();

    lawyersList.clear();

    for (var element in q.docs) {
      lawyersList.add(UserModel.fromJson(element));
    }

    debugPrint("getAllLawyers GETTING _________ ${lawyersList.length}");
    notifyListeners();
    ZBotToast.loadingClose();
    } catch (e) {
      ZBotToast.loadingClose();
      debugPrint(e.toString());
    }
  }

  Future<bool> getLawyerScheduleById(String? lawyerId) async {
    bool check = false;
    try {
      debugPrint("lawyerId $lawyerId");
      DocumentSnapshot doc = await FBCollections.lawyerScedule.doc(lawyerId).get();
      debugPrint("doc ${doc.id}");
      debugPrint("doc ${doc.reference.id}");

      debugPrint("doc ${doc.data()}");
      if (doc.exists) {
        lyrSchByID = LawyerScheduleModel.fromJson(doc.data());
        check = true;
        notifyListeners();
      } else {
        debugPrint("Lawyer doesnt have schedule yet.");
        // ZBotToast.showToastError(message: "Lawyer doesnt have schedule yet.");
      }
    } catch (e) {
      debugPrint("Error getting document by ID: $e");
      ZBotToast.showToastError(message: "$e");
    }

    return check;
  }

  Future<bool> createBookings(BookingModel model) async {
    bool p = false;
    try {
      ZBotToast.loadingShow();
      await FBCollections.bookings.doc(model.id).set(model.toJson());
      ZBotToast.showToastSuccess(message: "Booking added successfully.");
      p = true;
      notifyListeners();
      Get.back();
      Get.offAllNamed(BaseView.route);
      // Get.context!.read<BaseVM>()
      currentIndex = 0;
      notifyListeners();
    } catch (e) {
      String error = e.toString().split(']').toList().last;
      ZBotToast.showToastError(message: error);
      ZBotToast.loadingClose();
    }
    return p;
  }

  Future<String?> uploadImageUser(File image, String id, String customerId) async {

    String? imageURL;

    try {
      ZBotToast.loadingShow();
      debugPrint("check");

      Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child('bookings/$id-$customerId');
      UploadTask uploadTask = firebaseStorageRef.putFile(image);
      await uploadTask.then(
        (res) async {
          imageURL = await res.ref.getDownloadURL();
          debugPrint("=|= $imageURL");
          notifyListeners();
        },
      );
      ZBotToast.loadingClose();

      return imageURL;
    } catch (e) {
      debugPrint(e.toString());
      ZBotToast.loadingClose();
    }
    ZBotToast.loadingClose();

    return imageURL;
  }
  Future<String?> uploadImageUserInSupabase(File image, String id, String customerId) async {
  String? imageURL;
    final supabase = Supabase.instance.client;

  try {
    ZBotToast.loadingShow();
    debugPrint("Uploading to Supabase...");

    final String fileName =
        'bookings/$id-$customerId-${DateTime.now().microsecondsSinceEpoch}.${image.path.split('.').last}';

    // Upload to Supabase Storage
    final uploadResponse = await supabase.storage
        .from('user-images') // ⚠️ Replace with your bucket name in Supabase
        .upload(fileName, image);

    if (uploadResponse.isEmpty) {
      throw Exception('Upload failed');
    }

    // Get public URL
    final publicUrl = supabase.storage
        .from('user-images') // same bucket name
        .getPublicUrl(fileName);

    imageURL = publicUrl;
    debugPrint("✅ Uploaded: $imageURL");

    notifyListeners();
    ZBotToast.loadingClose();

    return imageURL;
  } catch (e) {
    debugPrint("❌ Supabase upload error: $e");
    ZBotToast.loadingClose();
  }

  return imageURL;
}

  void update() {
    notifyListeners();
  }
}
