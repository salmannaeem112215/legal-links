import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:legal_links_app/services/custom_file_picker/file_picker_widget.dart';
import 'package:legal_links_app/src/auth/model/user_model.dart';
import 'package:legal_links_app/src/auth/vm/auth_vm.dart';
import 'package:legal_links_app/utils/common-widgets/custom_button.dart';
import 'package:legal_links_app/utils/zbot_toast.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../../resources/resources.dart';
import '../../../../resources/validator.dart';
import '../../../../utils/common-widgets/custom_textformfield.dart';
import '../../../../utils/hights_widths.dart';
import '../../model/lawyer_model.dart';

class SignupScreenTwoOfLawyer extends StatefulWidget {
  const SignupScreenTwoOfLawyer({super.key});

  @override
  State<SignupScreenTwoOfLawyer> createState() => _SignupScreenTwoOfLawyerState();
}

class _SignupScreenTwoOfLawyerState extends State<SignupScreenTwoOfLawyer> {
  FocusNode lawyerFocus = FocusNode();
  // TextEditingController anyotherSpeclawyerController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // List<RowItem> rowsList = [
  //   RowItem(
  //     degree: 'Degree',
  //     uni: 'Institute/University',
  //     showDeleteIcon: false,
  //   ),
  //   RowItem(
  //     degree: 'Degree',
  //     uni: 'Institute/University',
  //     showDeleteIcon: true,
  //   ),
  // ];
  List<Qualifications> qualificationList = [Qualifications()];
  List<Experience> experienceList = [Experience()];
  List<String> practiceAreaList = [""];
  TextEditingController LCNoController = TextEditingController();
  TextEditingController HCNoController = TextEditingController();

  FocusNode LCNoFocus = FocusNode();
  FocusNode HCNoFocus = FocusNode();

  // List<ExperienceItem> experienceList = [
  //   ExperienceItem(
  //     designation: 'Designation',
  //     court: 'Court/Chamber',
  //     showDeleteIcon: false,
  //   ),
  //   ExperienceItem(
  //     designation: 'Designation',
  //     court: 'Court/Chamber',
  //     showDeleteIcon: true,
  //   ),
  // ];

  // List<PracticeAreaItems> practiceList = [
  //   PracticeAreaItems(
  //     practiceArea: 'Designation',
  //     showDeleteIcon: false,
  //   ),
  //   PracticeAreaItems(
  //     practiceArea: 'Designation',
  //     showDeleteIcon: true,
  //   ),
  // ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<AuthVM>(builder: (context, vm, _) {
        return Scaffold(
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 12.sp, horizontal: 12.sp),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextFormField(
                    controller: LCNoController,
                    focusNode: LCNoFocus,
                    inputAction: TextInputAction.next,
                    hintText: 'License No.',
                    fieldTitle: "License No.",
                    validator: FieldValidator.validateEmpty,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    inputType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(20),
                    ],
                  ),
                  // h1,
                  CustomTextFormField(
                    controller: HCNoController,
                    focusNode: HCNoFocus,
                    inputAction: TextInputAction.next,
                    hintText: 'H.C No.',
                    fieldTitle: "H.C No.",
                    validator: FieldValidator.validateEmpty,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    inputType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(20),
                    ],
                  ),
                  h1,
                  speciallistLawyerDropdown(vm: vm),
                  // h1,
                  // CustomTextFormField(
                  //   controller: anyotherSpeclawyerController,
                  //   hintText: 'Any other Speciality',
                  //   //focusNode: lawyerFocus,
                  //   inputAction: TextInputAction.next,
                  //   inputType: TextInputType.name,
                  //   validator: FieldValidator.validateEmpty,
                  //   autovalidateMode: AutovalidateMode.onUserInteraction,
                  // ),
                  // h1,
                  heading('Your Qualification', () {
                    setState(() {
                      qualificationList.add(Qualifications());
                    });
                  }),
                  // h1,
                  for (int index = 0; index < qualificationList.length; index++) ...[
                    qualificationFieldRow(qualificationList[index], index),
                    h0P8,
                  ],
                  // h1,
                  heading('Your Experience', () {
                    setState(() {
                      experienceList.add(
                        Experience(),
                      );
                    });
                  }),
                  // h1,
                  for (int index = 0; index < experienceList.length; index++) ...[
                    customTextFieldExperience(experienceList[index], index),
                    h0P8,
                  ],
                  // h1,
                  heading('Practice Area', () {
                    setState(() {
                      practiceAreaList.add("");
                    });
                  }),
                  // h1,
                  for (int index = 0; index < practiceAreaList.length; index++) ...[
                    practiceField(practiceAreaList[index], index),
                    h0P8,
                  ],
                  // h1,
                  Text(
                    "Attachments",
                    style: R.textStyles.poppinsSemiBold(),
                  ),
                  h0P5,
                  Text(
                    "Upload your lawyer's card, CNIC, and registration certificates for verification",
                    style: R.textStyles.poppinsRegular(color: R.colors.darkGrey),
                  ),
                  h1P5,
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.w),
                    decoration: R.decoration.decoration(),
                    child: FilePickerWidget(
                      list: vm.attachmentsList,
                      isHideUploadButton: false,
                      onSelect: (list) {
                        vm.attachmentsList = list;
                      },
                    ),
                  ),
                  h3,
                  CustomButton(
                    buttonTitle: 'Continue',
                    tap: () async {
                      await butonFn(vm);
                    },
                  )
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  LawyerModelSignup? laywersSpe;

  Widget speciallistLawyerDropdown({required AuthVM vm}) {
    return DropdownButtonFormField<LawyerModelSignup?>(
      borderRadius: BorderRadius.circular(8),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      items: vm.castList
          .map((item) => DropdownMenuItem<LawyerModelSignup?>(
                value: item,
                child: Text(
                  item.specialist ?? "",
                  style: R.textStyles.poppinsRegular(color: R.colors.black, fontSize: 8),
                ),
              ))
          .toList(),
      decoration: R.decoration.fieldDecoration(hintText: "Select Specialist"),
      value: laywersSpe,
      validator: (value) {
        if (value == null) {
          return "required";
        }
        return null;
      },
      onChanged: (value) {
        laywersSpe = value;
      },
    );
  }

  Widget categoryLawyerDropdown({required AuthVM vm}) {
    return DropdownButtonFormField<LawyerModelSignup?>(
      borderRadius: BorderRadius.circular(8),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      items: vm.castList
          .map((item) => DropdownMenuItem<LawyerModelSignup?>(
                value: item,
                child: Text(
                  item.specialist ?? "",
                  style: R.textStyles.poppinsRegular(color: R.colors.black, fontSize: 8),
                ),
              ))
          .toList(),
      decoration: R.decoration.fieldDecoration(hintText: "Select Specialist"),
      value: laywersSpe,
      validator: (value) {
        if (value == null) {
          return "required";
        }
        return null;
      },
      onChanged: (value) {
        laywersSpe = value;
      },
    );
  }

  Widget heading(String text, VoidCallback onTap) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: R.textStyles.poppinsSemiBold(),
        ),
        TextButton(
            onPressed: onTap,
            child: Text(
              'ADD MORE',
              style: R.textStyles.poppinsSemiBold(color: R.colors.primary, fontSize: 10),
            )),
      ],
    );
  }

  Widget qualificationFieldRow(Qualifications item, int index) {
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: CustomTextFormField(
            hintText: "Degree",
            // focusNode: degreeFocus,
            inputAction: TextInputAction.next,
            inputType: TextInputType.name,
            validator: FieldValidator.validateEmpty,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onChanged: (value) {
              setState(() {
                qualificationList[index].degree = value;
              });
              return "";
            },
          ),
        ),
        w2,
        Expanded(
          flex: 5,
          child: CustomTextFormField(
            hintText: "Institute/University",
            // focusNode: instituteFocus,
            inputAction: TextInputAction.next,
            inputType: TextInputType.name,
            validator: FieldValidator.validateEmpty,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onChanged: (value) {
              setState(() {
                qualificationList[index].institute = value;
              });
              return "";
            },
          ),
        ),
        if (index >= 1)
          Expanded(
            flex: 1,
            child: IconButton(
              onPressed: () {
                setState(() {
                  qualificationList.removeAt(index);
                });
              },
              icon: Icon(
                Icons.delete,
                color: R.colors.red,
                size: 20.sp,
              ),
            ),
          ),
        Expanded(
          flex: index == 0 ? 2 : 1,
          child: Container(),
        ),
      ],
    );
  }

  Widget customTextFieldExperience(Experience item, int index) {
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: CustomTextFormField(
            hintText: "Designation",
            inputAction: TextInputAction.next,
            inputType: TextInputType.name,
            validator: FieldValidator.validateEmpty,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onChanged: (value) {
              setState(() {
                experienceList[index].position = value;
              });
              return "";
            },
          ),
        ),
        w2,
        Expanded(
          flex: 5,
          child: CustomTextFormField(
            hintText: "Firm/Court",
            // focusNode: lawyerFocus,
            inputAction: TextInputAction.next,
            inputType: TextInputType.name,
            validator: FieldValidator.validateEmpty,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onChanged: (value) {
              setState(() {
                experienceList[index].lawFirm = value;
              });
              return "";
            },
          ),
        ),
        if (index >= 1)
          Expanded(
            flex: 1,
            child: IconButton(
              onPressed: () {
                setState(() {
                  experienceList.removeAt(index);
                });
              },
              icon: Icon(
                Icons.delete,
                color: R.colors.red,
                size: 22.sp,
              ),
            ),
          ),
        Expanded(
          flex: index == 0 ? 2 : 1,
          child: Container(),
        ),
      ],
    );
  }

  Widget practiceField(String item, int index) {
    return Row(
      children: [
        Expanded(
          flex: 9,
          child: CustomTextFormField(
            hintText: "Practice Area",
            //focusNode: lawyerFocus,
            inputAction: TextInputAction.next,
            inputType: TextInputType.name,
            validator: FieldValidator.validateEmpty,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onChanged: (value) {
              setState(() {
                practiceAreaList[index] = value;
              });
              return "";
            },
          ),
        ),
        if (index >= 1)
          Expanded(
            flex: 1,
            child: IconButton(
              onPressed: () {
                setState(() {
                  practiceAreaList.removeAt(index);
                });
              },
              icon: Icon(
                Icons.delete,
                color: R.colors.primary,
                size: 25.sp,
              ),
            ),
          ),
        Expanded(
          flex: index == 0 ? 2 : 1,
          child: Container(),
        ),
      ],
    );
  }

  Future<void> butonFn(AuthVM vm) async {
    if (_formKey.currentState!.validate()) {
      if (vm.attachmentsList.isNotEmpty) {
        vm.tempLawyerModel = UserModel(
          // page 1 data
          role: context.read<AuthVM>().userRole,
          fullName: vm.tempLawyerModel.fullName,
          phoneNumber: vm.tempLawyerModel.phoneNumber,
          email: vm.tempLawyerModel.email,
          status: vm.tempLawyerModel.status,
          yearOfExperience: vm.tempLawyerModel.yearOfExperience,
          gender: vm.tempLawyerModel.gender,
          // profileImages: vm.tempLawyerModel.profileImages ?? [],upload on 3
          // current page data
          specialist: [laywersSpe?.specialist ?? ""],
          qualifications: List.from(qualificationList),
          experience: List.from(experienceList),
          practiceAreas: List.from(practiceAreaList),
          lcno: LCNoController.text.trim(),
          hcno: HCNoController.text.trim(),
        );
        context.read<AuthVM>().singupPageController.jumpToPage(2);
        context.read<AuthVM>().singupPage = 2;
        context.read<AuthVM>().update();
        // Get.toNamed(SignupScreenThreeOfLawyer.route);
      } else {
        ZBotToast.showToastError(message: "Please Upload Documents");
      }
    }
  }
}



// class RowItem {
//   final String degree;
//   final String uni;
//   final bool showDeleteIcon;

//   RowItem({
//     required this.degree,
//     required this.uni,
//     this.showDeleteIcon = true,
//   });
// }

// class ExperienceItem {
//   final String designation;
//   final String court;
//   final bool showDeleteIcon;

//   ExperienceItem({
//     required this.designation,
//     required this.court,
//     this.showDeleteIcon = true,
//   });
// }

// class PracticeAreaItems {
//   final String practiceArea;

//   final bool showDeleteIcon;

//   PracticeAreaItems({
//     required this.practiceArea,
//     this.showDeleteIcon = true,
//   });
// }


/*    // debugPrint('${R.colors.cyanPrint} Qualification ${qualificationList.length}:');
    // debugPrint('${R.colors.cyanPrint} -------------------');
    for (int index = 0; index < qualificationList.length; index++) {
      debugPrint('${R.colors.cyanPrint} Qualification ${index + 1}:');
      debugPrint('${R.colors.cyanPrint} Degree: ${qualificationList[index].degree}');
      debugPrint(
          '${R.colors.cyanPrint} Institute/University: ${qualificationList[index].institute}');
      debugPrint('${R.colors.cyanPrint} -------------------');
    }

    for (int index = 0; index < experienceList.length; index++) {
      debugPrint('${R.colors.greenPrint} experience ${index + 1}:');
      debugPrint('${R.colors.greenPrint} position: ${experienceList[index].position}');
      debugPrint('${R.colors.greenPrint} firm/court: ${experienceList[index].lawFirm}');
      debugPrint('${R.colors.greenPrint} -------------------');
    }

    for (int index = 0; index < practiceAreaList.length; index++) {
      debugPrint('${R.colors.yellowPrint} practive area ${index + 1}:');
      debugPrint('${R.colors.yellowPrint} practice: ${practiceAreaList[index]}');

      debugPrint('${R.colors.yellowPrint} -------------------');
    } */